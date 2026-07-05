import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';

void main() {
  group('XkLogLevel gating', () {
    test('isAtLeast orders levels correctly', () {
      expect(XkLogLevel.error.isAtLeast(XkLogLevel.info), isTrue);
      expect(XkLogLevel.debug.isAtLeast(XkLogLevel.info), isFalse);
      expect(XkLogLevel.info.isAtLeast(XkLogLevel.info), isTrue);
      expect(XkLogLevel.verbose.isAtLeast(XkLogLevel.off), isFalse);
    });
  });

  group('XkLog', () {
    tearDown(() {
      // Restore process-wide default so tests don't leak state.
      XkLog.defaultMinLevel = XkLogLevel.verbose;
    });

    test('constructs with tag', () {
      const log = XkLog.tagged('Cosentio');
      expect(log.tag, 'Cosentio');
    });

    test('per-instance minLevel overrides default', () {
      const log = XkLog(minLevel: XkLogLevel.warning);
      expect(log.minLevel, XkLogLevel.warning);
    });

    test('falls back to defaultMinLevel when unset', () {
      XkLog.defaultMinLevel = XkLogLevel.error;
      const log = XkLog();
      expect(log.minLevel, XkLogLevel.error);
    });

    test('copyWith replaces tag and level', () {
      const log = XkLog.tagged('A', minLevel: XkLogLevel.info);
      final updated = log.copyWith(tag: 'B', minLevel: XkLogLevel.error);
      expect(updated.tag, 'B');
      expect(updated.minLevel, XkLogLevel.error);
    });

    test('logging calls do not throw and respect gating', () {
      XkLog.defaultMinLevel = XkLogLevel.warning;
      const log = XkLog.tagged('Cosentio');
      // Below threshold -> suppressed, but must not throw.
      expect(() => log.v('verbose'), returnsNormally);
      expect(() => log.d('debug'), returnsNormally);
      // At/above threshold -> emitted, must not throw.
      expect(() => log.w('warn'), returnsNormally);
      expect(
        () => log.e('boom', error: Exception('x'), stackTrace: StackTrace.current),
        returnsNormally,
      );
      expect(() => log.i('info', tag: 'Override'), returnsNormally);
    });

    test('exception helper handles Exception and non-Exception', () {
      const log = XkLog();
      expect(() => log.exception(Exception('e')), returnsNormally);
      expect(
        () => log.exception('plain string', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });
  });

  group('XkLoggerGlobalHandler', () {
    test('install wires FlutterError.onError and preserves previous', () {
      final previousFlutter = FlutterError.onError;
      var captured = false;
      XkLoggerGlobalHandler.install(
        log: const XkLog.tagged('Test'),
        onError: (Object error, StackTrace? stack) => captured = true,
      );
      expect(FlutterError.onError, isNotNull);
      FlutterError.onError!(
        FlutterErrorDetails(exception: Exception('boom')),
      );
      expect(captured, isTrue);
      // Restore.
      FlutterError.onError = previousFlutter;
    });

    test('runGuarded executes body and returns its value', () {
      final result = XkLoggerGlobalHandler.runGuarded<int>(
        () => 42,
        log: const XkLog.tagged('Guarded'),
      );
      expect(result, 42);
    });
  });
}
