import 'dart:async';

import '../error/xerkonix_error.dart';

/// A side-effect/retry callback invoked when an error with a matching key is
/// dispatched through [XkErrorHooks].
///
/// Return `true` to signal "handled — retry the operation" (e.g. after a 401
/// refresh); return `false`/`null` for a terminal side-effect (e.g. show a
/// toast and navigate). The [context] is opaque and app-supplied.
typedef XkErrorHook = FutureOr<bool?> Function(XkError error, Object? context);

/// A registry of on-code / on-status side-effect hooks.
///
/// This is the *hook surface* only — the package wires no product behaviour.
/// Apps register hooks so that, for example, `GUEST_LIMIT_REACHED` can pop a
/// toast and navigate, or `401` can trigger a refresh-and-retry — all without
/// product-specific branching leaking into the shared client/error layer.
///
/// ```dart
/// final hooks = XkErrorHooks()
///   ..onCode('COSENTIO_GUEST_LIMIT_REACHED', (e, ctx) { showSignupToast(); return false; })
///   ..onStatus(401, (e, ctx) async => await refreshSession()); // retry
///
/// final retry = await hooks.dispatch(error);
/// if (retry == true) { /* re-run request */ }
/// ```
class XkErrorHooks {
  XkErrorHooks({
    Map<String, XkErrorHook>? codeHooks,
    Map<int, XkErrorHook>? statusHooks,
  })  : _codeHooks = <String, XkErrorHook>{...?codeHooks},
        _statusHooks = <int, XkErrorHook>{...?statusHooks};

  final Map<String, XkErrorHook> _codeHooks;
  final Map<int, XkErrorHook> _statusHooks;

  /// Registers a hook for a business [code]. Returns `this` for chaining.
  XkErrorHooks onCode(String code, XkErrorHook hook) {
    _codeHooks[code] = hook;
    return this;
  }

  /// Registers a hook for an HTTP [statusCode]. Returns `this` for chaining.
  XkErrorHooks onStatus(int statusCode, XkErrorHook hook) {
    _statusHooks[statusCode] = hook;
    return this;
  }

  bool hasCode(String code) => _codeHooks.containsKey(code);
  bool hasStatus(int statusCode) => _statusHooks.containsKey(statusCode);

  /// Dispatches [error] to the best-matching hook (code first, then status).
  ///
  /// Returns the hook's result (`true` == retry) or `null` when no hook matched.
  Future<bool?> dispatch(XkError error, {Object? context}) async {
    final String? code = error.code?.trim();
    if (code != null && code.isNotEmpty) {
      final XkErrorHook? hook = _codeHooks[code];
      if (hook != null) {
        return await hook(error, context);
      }
    }
    final int? status = error.statusCode;
    if (status != null) {
      final XkErrorHook? hook = _statusHooks[status];
      if (hook != null) {
        return await hook(error, context);
      }
    }
    return null;
  }
}
