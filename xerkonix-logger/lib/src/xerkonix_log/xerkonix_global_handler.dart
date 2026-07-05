import 'dart:async';

import 'package:flutter/foundation.dart';

import 'xerkonix_log.dart';

/// One-call wire-up of Flutter's global error hooks to an [XkLog].
///
/// Mirrors the pattern product apps hand-roll in `main.dart`: it sets
/// [FlutterError.onError], [PlatformDispatcher.instance.onError], and (via
/// [runGuarded]) a [runZonedGuarded] wrapper — all funnelling uncaught errors
/// into a single [XkLog] instance.
///
/// Typical usage:
/// ```dart
/// void main() {
///   XkLoggerGlobalHandler.runGuarded(
///     () {
///       WidgetsFlutterBinding.ensureInitialized();
///       runApp(const MyApp());
///     },
///     log: XkLog.tagged('Cosentio'),
///   );
/// }
/// ```
///
/// If you prefer to manage your own zone, call [install] instead to only attach
/// the [FlutterError]/[PlatformDispatcher] hooks.
class XkLoggerGlobalHandler {
  const XkLoggerGlobalHandler._();

  /// Attaches [FlutterError.onError] and [PlatformDispatcher.instance.onError]
  /// to [log]. Both existing handlers are preserved and chained unless
  /// [preservePrevious] is `false`.
  ///
  /// When [presentErrors] is `true` (the default) Flutter framework errors are
  /// still forwarded to [FlutterError.presentError] (red-screen in debug).
  ///
  /// Optional [onError] is invoked for every captured error, useful for wiring a
  /// crash reporter (Sentry/Crashlytics) without editing this package.
  static void install({
    XkLog? log,
    bool preservePrevious = true,
    bool presentErrors = true,
    void Function(Object error, StackTrace? stack)? onError,
  }) {
    final XkLog logger = log ?? const XkLog();

    final FlutterExceptionHandler? previousFlutterOnError =
        preservePrevious ? FlutterError.onError : null;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (presentErrors) {
        FlutterError.presentError(details);
      }
      logger.e(
        'FlutterError: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );
      onError?.call(details.exception, details.stack);
      previousFlutterOnError?.call(details);
    };

    final bool Function(Object, StackTrace)? previousPlatformOnError =
        preservePrevious ? PlatformDispatcher.instance.onError : null;
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Uncaught async error', error: error, stackTrace: stack);
      onError?.call(error, stack);
      // Preserve any previously-registered handler's result, else mark handled.
      return previousPlatformOnError?.call(error, stack) ?? true;
    };
  }

  /// Runs [body] inside a [runZonedGuarded] zone that routes uncaught zone
  /// errors to [log], additionally calling [install] so framework/platform hooks
  /// are wired too.
  ///
  /// Returns whatever the zone returns (usually `null`).
  static R? runGuarded<R>(
    R Function() body, {
    XkLog? log,
    bool presentErrors = true,
    void Function(Object error, StackTrace stack)? onError,
  }) {
    final XkLog logger = log ?? const XkLog();
    return runZonedGuarded<R>(
      () {
        install(
          log: logger,
          presentErrors: presentErrors,
          onError: onError == null
              ? null
              : (Object error, StackTrace? stack) =>
                  onError(error, stack ?? StackTrace.current),
        );
        return body();
      },
      (Object error, StackTrace stack) {
        logger.e('Zone error', error: error, stackTrace: stack);
        onError?.call(error, stack);
      },
    );
  }
}
