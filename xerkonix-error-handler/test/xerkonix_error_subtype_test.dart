// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

void main() {
  group('M35 — fromStatusCode preserves subtype identity', () {
    test('402 is a PaymentRequired (not a re-wrapped base XkError)', () {
      final e = XkErrorNormalizer.fromStatusCode(
        402,
        code: 'COSENTIO_QUOTA_EXCEEDED',
        metadata: <String, dynamic>{'remaining': 0},
      );
      expect(e, isA<PaymentRequired>());
      expect(e.runtimeType, PaymentRequired);
      expect(e.statusCode, 402);
      expect(e.code, 'COSENTIO_QUOTA_EXCEEDED');
      expect(e.metadata['remaining'], 0);
    });

    test('429 is a TooManyRequests with preserved status/metadata', () {
      final e = XkErrorNormalizer.fromStatusCode(
        429,
        metadata: <String, dynamic>{'retryAfter': 5},
      );
      expect(e, isA<TooManyRequests>());
      expect(e.statusCode, 429);
      expect(e.metadata['retryAfter'], 5);
    });

    test('403 is a Forbidden (subtype), status preserved', () {
      final e = XkErrorNormalizer.fromStatusCode(403);
      expect(e, isA<Forbidden>());
      expect(e.statusCode, 403);
    });

    test('unmapped status is UnknownError but keeps the real status/metadata',
        () {
      final e = XkErrorNormalizer.fromStatusCode(
        418,
        metadata: <String, dynamic>{'teapot': true},
      );
      expect(e, isA<UnknownError>());
      expect(e.statusCode, 418);
      expect(e.metadata['teapot'], true);
    });

    test('fromEnvelope surfaces the typed subtype', () {
      final e = XkErrorNormalizer.fromEnvelope(
        <String, dynamic>{
          'error': <String, dynamic>{'code': 'X', 'detail': 'd'},
        },
        402,
      );
      expect(e, isA<PaymentRequired>());
      expect(e!.code, 'X');
      expect(e.detail, 'd');
    });
  });

  group('M35 — exception factory forwards caller-supplied error', () {
    test('BadRequestException stores the passed error, not a default', () {
      final custom = XkErrors.badRequest(
        code: 'COSENTIO_CUSTOM',
        detail: 'custom detail',
        metadata: <String, dynamic>{'field': 'email'},
      );
      final ex = XkException.badRequest(xkError: custom);
      expect(identical(ex.xkError, custom), isTrue);
      expect(ex.xkError.code, 'COSENTIO_CUSTOM');
      expect(ex.xkError.detail, 'custom detail');
      expect(ex.xkError.metadata['field'], 'email');
    });

    test('preserves a typed subtype passed through the exception', () {
      final pr = XkErrorNormalizer.fromStatusCode(402, code: 'Q');
      final ex = XkException.unknownError(xkError: pr);
      expect(ex.xkError, isA<PaymentRequired>());
      expect(ex.xkError.statusCode, 402);
      expect(ex.xkError.code, 'Q');
    });

    test('falls back to the type default when no error supplied', () {
      final ex = XkException.notFound();
      expect(ex.xkError, isA<NotFound>());
      expect(ex.xkError.statusCode, 404);
    });
  });
}
