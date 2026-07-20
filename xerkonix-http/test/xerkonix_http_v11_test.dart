// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_http/xerkonix_http.dart';

void main() {
  group('XkHttpConfig 1.1.0 options', () {
    test('defaults for new fields', () {
      const config = XkHttpConfig();
      expect(config.baseUrl, isNull);
      expect(config.authHeaderName, 'Authorization');
      expect(config.unwrapDataEnvelope, isFalse);
      expect(config.authEndpointSkipList, contains('/api/v1/auth/'));
      // Authorization header -> uses tokenType scheme.
      expect(config.effectiveAuthHeaderScheme, 'Bearer ');
    });

    test('custom header defaults to empty scheme', () {
      const config = XkHttpConfig(authHeaderName: 'x-cosentio-account-session');
      expect(config.effectiveAuthHeaderScheme, '');
    });

    test('copyWith preserves and overrides', () {
      const config = XkHttpConfig(host: 'a.com');
      final updated = config.copyWith(baseUrl: 'https://api.x.com/api/v1');
      expect(updated.host, 'a.com');
      expect(updated.baseUrl, 'https://api.x.com/api/v1');
    });
  });

  group('resolveUri base-url', () {
    test('joins baseUrl + path with prefix', () {
      final request = XkHttpRequest(
        httpConfig: const XkHttpConfig(baseUrl: 'https://api.x.com/api/v1'),
      );
      final uri = request.resolveUri(path: '/people', queryParameters: {'q': 'a'});
      expect(uri.toString(), 'https://api.x.com/api/v1/people?q=a');
    });

    test('falls back to discrete host/port when no baseUrl', () {
      final request = XkHttpRequest(
        httpConfig: const XkHttpConfig(scheme: 'http', host: 'localhost', port: 8080),
      );
      final uri = request.resolveUri(path: '/x');
      expect(uri.scheme, 'http');
      expect(uri.host, 'localhost');
      expect(uri.port, 8080);
    });
  });

  group('XkHttpResponse.process', () {
    XkHttpResponse resp({bool unwrap = false}) =>
        XkHttpResponse(httpConfig: XkHttpConfig(enableLogging: false, unwrapDataEnvelope: unwrap));

    test('200 returns decoded body', () {
      final r = resp().process(http.Response('{"a":1}', 200));
      expect(r, <String, dynamic>{'a': 1});
    });

    test('204 returns null', () {
      expect(resp().process(http.Response('', 204)), isNull);
    });

    test('unwraps {statusCode,data} envelope when enabled', () {
      final r = resp(unwrap: true).process(
        http.Response('{"statusCode":200,"data":{"x":9}}', 200),
      );
      expect(r, <String, dynamic>{'x': 9});
    });

    test('402 -> XkException with PaymentRequired code/status', () {
      try {
        resp().process(http.Response(
          jsonEncode(<String, dynamic>{
            'error': <String, dynamic>{
              'code': 'COSENTIO_QUOTA_EXCEEDED',
              'detail': 'quota exhausted',
              'metadata': <String, dynamic>{'remaining': 0},
            },
          }),
          402,
        ));
        fail('expected XkException');
      } on XkException catch (e) {
        expect(e.xkError.statusCode, 402);
        expect(e.xkError.code, 'COSENTIO_QUOTA_EXCEEDED');
        expect(e.xkError.metadata['remaining'], 0);
      }
    });

    test('429 -> XkException rate-limit', () {
      try {
        resp().process(http.Response('{"detail":"rate"}', 429));
        fail('expected XkException');
      } on XkException catch (e) {
        expect(e.xkError.statusCode, 429);
      }
    });

    test('arbitrary status uses default fallback branch (no generic throw)', () {
      try {
        resp().process(http.Response('', 418));
        fail('expected XkException');
      } on XkException catch (e) {
        expect(e.xkError.statusCode, 418);
      }
    });
  });

  group('XkInterceptedClient', () {
    test('injects custom auth header with configured name/scheme', () async {
      Map<String, String>? seen;
      final mock = MockClient((http.Request req) async {
        seen = req.headers;
        return http.Response('{"ok":true}', 200);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(authHeaderName: 'x-cosentio-account-session'),
        getAuthToken: () => 'SESSION123',
      );
      await client.get(Uri.parse('https://api.x.com/api/v1/home'));
      expect(seen?['x-cosentio-account-session'], 'SESSION123');
    });

    test('captures rotating token from response header', () async {
      String? captured;
      final mock = MockClient((http.Request req) async {
        return http.Response(
          '{}',
          200,
          headers: <String, String>{'x-cosentio-account-session': 'ROTATED'},
        );
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(authHeaderName: 'x-cosentio-account-session'),
        onSessionToken: (String t) => captured = t,
      );
      await client.get(Uri.parse('https://api.x.com/api/v1/home'));
      expect(captured, 'ROTATED');
    });

    test('refreshes and retries once on 401, with re-entrancy guard', () async {
      var calls = 0;
      var refreshCalls = 0;
      final mock = MockClient((http.Request req) async {
        calls++;
        final String auth = req.headers['x-cosentio-account-session'] ?? '';
        if (auth == 'NEW') {
          return http.Response('{"ok":true}', 200);
        }
        return http.Response('{"error":{"code":"COSENTIO_AUTH_INVALID_TOKEN"}}', 401);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(authHeaderName: 'x-cosentio-account-session'),
        getAuthToken: () => 'OLD',
        getRefreshToken: () => 'REFRESH',
        refresh: (String r) async {
          refreshCalls++;
          return 'NEW';
        },
      );
      final resp = await client.get(Uri.parse('https://api.x.com/api/v1/home'));
      expect(resp.statusCode, 200);
      expect(refreshCalls, 1);
      expect(calls, 2); // original 401 + one retry
    });

    test('skips refresh for auth endpoints', () async {
      var refreshCalls = 0;
      final mock = MockClient((http.Request req) async {
        return http.Response('{}', 401);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(),
        getRefreshToken: () => 'REFRESH',
        refresh: (String r) async {
          refreshCalls++;
          return 'NEW';
        },
      );
      final resp = await client.post(
        Uri.parse('https://api.x.com/api/v1/auth/login'),
        body: '{}',
      );
      expect(resp.statusCode, 401);
      expect(refreshCalls, 0);
    });

    test('does not retry when refresh returns empty', () async {
      final mock = MockClient((http.Request req) async {
        return http.Response('{}', 401);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(),
        getRefreshToken: () => 'REFRESH',
        refresh: (String r) async => '',
      );
      final resp = await client.get(Uri.parse('https://api.x.com/api/v1/home'));
      expect(resp.statusCode, 401);
    });

    test('persists the rotated session token via onSessionToken after refresh',
        () async {
      String? persisted;
      final mock = MockClient((http.Request req) async {
        final String auth = req.headers['x-cosentio-account-session'] ?? '';
        return http.Response('{}', auth == 'NEW' ? 200 : 401);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(authHeaderName: 'x-cosentio-account-session'),
        getAuthToken: () => 'OLD',
        getRefreshToken: () => 'REFRESH',
        refresh: (String r) async => 'NEW',
        onSessionToken: (String t) => persisted = t,
      );
      final resp = await client.get(Uri.parse('https://api.x.com/api/v1/home'));
      expect(resp.statusCode, 200);
      expect(persisted, 'NEW'); // 갱신된 세션 토큰이 영속화됨 → refresh 폭주 방지
    });

    test('concurrent 401s share ONE refresh (single-flight) and both retry',
        () async {
      var refreshCalls = 0;
      final mock = MockClient((http.Request req) async {
        final String auth = req.headers['x-cosentio-account-session'] ?? '';
        if (auth == 'NEW') return http.Response('{"ok":true}', 200);
        return http.Response('{}', 401);
      });
      final client = XkInterceptedClient(
        inner: mock,
        config: const XkHttpConfig(authHeaderName: 'x-cosentio-account-session'),
        getAuthToken: () => 'OLD',
        getRefreshToken: () => 'REFRESH',
        refresh: (String r) async {
          refreshCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return 'NEW';
        },
      );
      // 만료 토큰으로 두 요청이 동시에 나가 둘 다 401 → 갱신은 1회만, 둘 다 성공.
      final List<http.Response> results = await Future.wait(<Future<http.Response>>[
        client.get(Uri.parse('https://api.x.com/api/v1/a')),
        client.get(Uri.parse('https://api.x.com/api/v1/b')),
      ]);
      expect(results[0].statusCode, 200);
      expect(results[1].statusCode, 200); // 예전엔 두 번째가 401을 그대로 반환했다
      expect(refreshCalls, 1); // single-flight
    });
  });

  group('generateHttpFromBaseUrl', () {
    test('builds config with baseUrl and options', () {
      final xkHttp = XkHttpUtils.generateHttpFromBaseUrl(
        baseUrl: 'https://api.x.com/api/v1',
        authHeaderName: 'x-cosentio-account-session',
        unwrapDataEnvelope: true,
      );
      expect(xkHttp.config.baseUrl, 'https://api.x.com/api/v1');
      expect(xkHttp.config.authHeaderName, 'x-cosentio-account-session');
      expect(xkHttp.config.unwrapDataEnvelope, isTrue);
    });
  });
}
