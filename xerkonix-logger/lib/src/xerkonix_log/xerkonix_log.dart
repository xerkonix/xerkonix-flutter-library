import 'package:flutter/foundation.dart';

import '../xerkonix_logger/xerkonix_logger.dart';
import 'xerkonix_log_level.dart';

/// A tag-prefixed, level-gated logging facade built on top of the existing
/// [Logger] factory family.
///
/// This is additive: the original [Logger] / [LoggerUtil] APIs keep working
/// unchanged. [XkLog] adds three things product apps were previously hand-rolling:
///
///  * **Tag/prefix support** — messages are prefixed like `[Cosentio] …`, either
///    via [XkLog.tagged] or the per-call `tag:` parameter.
///  * **Release/debug gating** — a configurable [minLevel] that, by default,
///    suppresses `verbose`/`debug` output when [kReleaseMode] is `true`.
///  * A one-call **global error handler** wire-up (see
///    `XkLoggerGlobalHandler.install`).
///
/// Example:
/// ```dart
/// final log = XkLog.tagged('Cosentio');
/// log.d('starting up');           // -> "[Cosentio] starting up" (debug only)
/// log.e('boom', tag: 'Payment');  // -> "[Payment] boom"
/// ```
class XkLog {
  /// Creates a logger. When [tag] is provided every message is prefixed with
  /// `[tag]`. [minLevel] overrides the [defaultMinLevel] for this instance.
  const XkLog({this.tag, XkLogLevel? minLevel}) : _minLevel = minLevel;

  /// Convenience constructor mirroring the common `Logger.tagged('X')` idiom.
  const XkLog.tagged(this.tag, {XkLogLevel? minLevel}) : _minLevel = minLevel;

  /// Optional prefix tag, rendered as `[tag] message`.
  final String? tag;

  final XkLogLevel? _minLevel;

  /// Process-wide default minimum level. In release builds this defaults to
  /// [XkLogLevel.info] (so `debug`/`verbose` are suppressed); in debug builds it
  /// defaults to [XkLogLevel.verbose] (everything is shown).
  ///
  /// Assign to override globally, e.g. `XkLog.defaultMinLevel = XkLogLevel.warning;`.
  static XkLogLevel defaultMinLevel =
      kReleaseMode ? XkLogLevel.info : XkLogLevel.verbose;

  /// The effective minimum level for this instance.
  XkLogLevel get minLevel => _minLevel ?? defaultMinLevel;

  bool _enabled(XkLogLevel level) => level.isAtLeast(minLevel);

  String _decorate(Object? message, String? callTag) {
    final String? effectiveTag = callTag ?? tag;
    if (effectiveTag == null || effectiveTag.isEmpty) {
      return '$message';
    }
    return '[$effectiveTag] $message';
  }

  /// Returns a copy of this logger with a (possibly) different [tag]/[minLevel].
  XkLog copyWith({String? tag, XkLogLevel? minLevel}) =>
      XkLog(tag: tag ?? this.tag, minLevel: minLevel ?? _minLevel);

  void v(Object? message, {String? tag}) {
    if (!_enabled(XkLogLevel.verbose)) return;
    Logger.log(_decorate(message, tag));
  }

  void d(Object? message, {String? tag}) {
    if (!_enabled(XkLogLevel.debug)) return;
    Logger.debug(_decorate(message, tag));
  }

  void i(Object? message, {String? tag}) {
    if (!_enabled(XkLogLevel.info)) return;
    Logger.info(_decorate(message, tag));
  }

  void w(Object? message, {String? tag}) {
    if (!_enabled(XkLogLevel.warning)) return;
    Logger.warning(_decorate(message, tag));
  }

  void e(Object? message, {Object? error, StackTrace? stackTrace, String? tag}) {
    if (!_enabled(XkLogLevel.error)) return;
    final StringBuffer buffer = StringBuffer(_decorate(message, tag));
    if (error != null) {
      buffer.write('\n$error');
    }
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    Logger.errorMessage(buffer.toString());
  }

  /// Logs an [Exception] with the exception logger, respecting [minLevel].
  void exception(Object error, {StackTrace? stackTrace, String? tag}) {
    if (!_enabled(XkLogLevel.error)) return;
    if (error is Exception) {
      Logger.exception(error, errorMethodCount: 10);
    } else {
      Logger.errorMessage(_decorate('$error\n${stackTrace ?? ''}', tag));
    }
  }
}
