// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

void main() {
  group('XkError metadata/statusCode/code', () {
    test('carries metadata and statusCode', () {
      final error = XkError(
        code: 'COSENTIO_QUOTA_EXCEEDED',
        statusCode: 402,
        metadata: <String, dynamic>{'remaining': 0},
      );
      expect(error.code, 'COSENTIO_QUOTA_EXCEEDED');
      expect(error.statusCode, 402);
      expect(error.metadata['remaining'], 0);
    });

    test('metadata defaults to empty non-null map', () {
      final error = XkError();
      expect(error.metadata, isEmpty);
    });
  });

  group('New subtypes', () {
    test('paymentRequired -> 402', () {
      final e = XkErrors.paymentRequired();
      expect(e, isA<PaymentRequired>());
      expect(e.statusCode, 402);
      expect(e.code, '402');
    });

    test('tooManyRequests -> 429', () {
      final e = XkErrors.tooManyRequests();
      expect(e, isA<TooManyRequests>());
      expect(e.statusCode, 429);
      expect(e.code, '429');
    });

    test('networkTimeout / networkUnknown carry synthetic codes', () {
      expect(XkErrors.networkTimeout().code, XkErrorCodes.networkTimeout);
      expect(XkErrors.networkUnknown().code, XkErrorCodes.networkUnknown);
    });
  });

  group('XkErrorNormalizer.fromStatusCode', () {
    test('maps known codes to subtypes and preserves status/metadata', () {
      final e = XkErrors.fromStatusCode(
        429,
        code: 'COSENTIO_RATE_LIMITED',
        metadata: <String, dynamic>{'retryAfter': 5},
      );
      expect(e.statusCode, 429);
      expect(e.code, 'COSENTIO_RATE_LIMITED');
      expect(e.metadata['retryAfter'], 5);
    });

    test('unmapped status still preserves the real status code', () {
      final e = XkErrorNormalizer.fromStatusCode(418);
      expect(e.statusCode, 418);
    });
  });

  group('XkErrorNormalizer.normalizeException', () {
    test('TimeoutException -> NetworkTimeout', () {
      final e = XkErrorNormalizer.normalizeException(TimeoutException('t'));
      expect(e.code, XkErrorCodes.networkTimeout);
    });

    test('SocketException -> NetworkUnknown', () {
      final e = XkErrorNormalizer.normalizeException(
        const SocketException('no route'),
      );
      expect(e.code, XkErrorCodes.networkUnknown);
    });

    test('ClientException -> NetworkUnknown', () {
      final e = XkErrorNormalizer.normalizeException(
        http.ClientException('closed'),
      );
      expect(e.code, XkErrorCodes.networkUnknown);
    });

    test('FormatException -> InvalidFormat', () {
      final e = XkErrorNormalizer.normalizeException(const FormatException('bad'));
      expect(e, isA<InvalidFormat>());
    });

    test('existing XkError passes through', () {
      final input = XkErrors.forbidden();
      expect(identical(XkErrorNormalizer.normalizeException(input), input), isTrue);
    });
  });

  group('XkErrorNormalizer.fromEnvelope', () {
    test('parses nested error envelope', () {
      final e = XkErrorNormalizer.fromEnvelope(
        <String, dynamic>{
          'error': <String, dynamic>{
            'code': 'COSENTIO_GUEST_LIMIT_REACHED',
            'title': '한도 초과',
            'detail': '비회원 무료 분석을 모두 사용했어요.',
            'metadata': <String, dynamic>{'limit': 3},
          },
        },
        403,
      );
      expect(e, isNotNull);
      expect(e!.code, 'COSENTIO_GUEST_LIMIT_REACHED');
      expect(e.statusCode, 403);
      expect(e.detail, '비회원 무료 분석을 모두 사용했어요.');
      expect(e.metadata['limit'], 3);
    });

    test('parses bare {detail} envelope', () {
      final e = XkErrorNormalizer.fromEnvelope(
        <String, dynamic>{'detail': '요청 실패'},
        400,
      );
      expect(e!.detail, '요청 실패');
    });

    test('returns null for < 400', () {
      expect(XkErrorNormalizer.fromEnvelope(<String, dynamic>{}, 200), isNull);
    });
  });

  group('XkMessageRegistry', () {
    test('resolves by code first', () {
      final registry = XkMessageRegistry.korean();
      final msg = registry.messageFor(
        XkError(code: 'COSENTIO_GUEST_LIMIT_REACHED'),
      );
      expect(msg, contains('비회원'));
    });

    test('falls back to status when code missing', () {
      final registry = XkMessageRegistry.korean();
      final msg = registry.messageFor(XkError(statusCode: 401));
      expect(msg, contains('로그인'));
    });

    test('uses server detail before generic fallback', () {
      final registry = XkMessageRegistry.korean();
      final msg = registry.messageFor(
        XkError(detail: '커스텀 상세 메시지', statusCode: 418),
      );
      expect(msg, '커스텀 상세 메시지');
    });

    test('generic fallback for unknown', () {
      final registry = XkMessageRegistry.korean();
      final msg = registry.messageFor(XkError());
      expect(msg, registry.fallback.detail);
    });

    test('includes the full COSENTIO_* + admin set', () {
      expect(
        XkMessageRegistry.koreanMessages.containsKey('COSENTIO_AI_INPUT_EMOJI_ONLY'),
        isTrue,
      );
      expect(
        XkMessageRegistry.koreanMessages.containsKey('COSENTIO_ADMIN_USER_EMAIL_CONFLICT'),
        isTrue,
      );
      // ~37 COSENTIO_* + admin + network codes.
      expect(XkMessageRegistry.koreanMessages.length, greaterThanOrEqualTo(37));
    });

    test('per-instance registration does not leak globally', () {
      final a = XkMessageRegistry();
      final b = XkMessageRegistry();
      a.registerCode('X', XkErrorMessage(title: 't', detail: 'only-a'));
      expect(a.hasCode('X'), isTrue);
      expect(b.hasCode('X'), isFalse);
    });
  });

  group('XkErrorHooks', () {
    test('dispatches on code and returns retry signal', () async {
      var called = false;
      final hooks = XkErrorHooks()
        ..onCode('COSENTIO_GUEST_LIMIT_REACHED', (error, ctx) {
          called = true;
          return false;
        });
      final result = await hooks.dispatch(
        XkError(code: 'COSENTIO_GUEST_LIMIT_REACHED'),
      );
      expect(called, isTrue);
      expect(result, isFalse);
    });

    test('dispatches on status when no code hook, and supports retry', () async {
      final hooks = XkErrorHooks()..onStatus(401, (error, ctx) async => true);
      final result = await hooks.dispatch(XkError(statusCode: 401));
      expect(result, isTrue);
    });

    test('returns null when nothing matches', () async {
      final hooks = XkErrorHooks();
      expect(await hooks.dispatch(XkError(code: 'nope')), isNull);
    });
  });

  group('Toast + snackbar renderers', () {
    testWidgets('showXkToast inserts an overlay toast', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showXkToast(context, '토스트 메시지'),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump(); // insert overlay
      await tester.pump(const Duration(milliseconds: 260)); // slide in
      expect(find.text('토스트 메시지'), findsOneWidget);
      expect(find.byType(XkErrorToast), findsOneWidget);
    });

    testWidgets('showXkSnackBar shows a SnackBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showXkSnackBar(context, '스낵바 메시지'),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      expect(find.text('스낵바 메시지'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
