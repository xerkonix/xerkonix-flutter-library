// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';

void main() {
  group('XkLogSanitizer.sanitizeHeaders (M31)', () {
    test('masks Authorization / Cookie / session headers', () {
      final masked = XkLogSanitizer.sanitizeHeaders(<String, String>{
        'Authorization': 'Bearer super-secret-jwt',
        'Cookie': 'sid=abc123',
        'x-cosentio-account-session': 'SESSION123',
        'Content-Type': 'application/json',
      });
      expect(masked['Authorization'], XkLogSanitizer.redacted);
      expect(masked['Cookie'], XkLogSanitizer.redacted);
      expect(masked['x-cosentio-account-session'], XkLogSanitizer.redacted);
      // Non-sensitive header preserved.
      expect(masked['Content-Type'], 'application/json');
    });

    test('masks by key fragment (token/secret/password), case-insensitive', () {
      final masked = XkLogSanitizer.sanitizeHeaders(<String, String>{
        'X-Refresh-Token': 'r',
        'my-api-key': 'k',
        'user-password': 'p',
        'X-Request-Id': 'ok',
      });
      expect(masked['X-Refresh-Token'], XkLogSanitizer.redacted);
      expect(masked['my-api-key'], XkLogSanitizer.redacted);
      expect(masked['user-password'], XkLogSanitizer.redacted);
      expect(masked['X-Request-Id'], 'ok');
    });
  });

  group('XkLogSanitizer.sanitizeUri (M31)', () {
    test('redacts sensitive query params, keeps others + scheme/host', () {
      final out = XkLogSanitizer.sanitizeUri(
        Uri.parse('https://api.x.com/v1/me?access_token=abc&page=2'),
      );
      expect(out, contains('page=2'));
      expect(out, contains('access_token=${XkLogSanitizer.redacted}'));
      expect(out, isNot(contains('abc')));
      expect(out, startsWith('https://api.x.com/v1/me'));
    });

    test('no query passes through unchanged', () {
      expect(
        XkLogSanitizer.sanitizeUri(Uri.parse('https://api.x.com/v1/me')),
        'https://api.x.com/v1/me',
      );
    });
  });

  group('XkLogSanitizer.bodyForLog (M31)', () {
    test('off by default -> disabled marker, never the raw body', () {
      final out = XkLogSanitizer.bodyForLog('{"pan":"4111111111111111"}');
      expect(out, '<body logging disabled>');
      expect(out, isNot(contains('4111')));
    });

    test('truncates when enabled and over the limit', () {
      final out =
          XkLogSanitizer.bodyForLog('x' * 50, logBody: true, maxLength: 10);
      expect(out, startsWith('xxxxxxxxxx'));
      expect(out, contains('truncated 40 chars'));
    });

    test('returns full body when enabled and under the limit', () {
      expect(
        XkLogSanitizer.bodyForLog('short', logBody: true, maxLength: 100),
        'short',
      );
    });
  });
}
