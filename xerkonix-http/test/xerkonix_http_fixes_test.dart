// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_http/xerkonix_http.dart';

void main() {
  group('M32 — legacy client auth header uses config (no double space)', () {
    test('Authorization header is single-spaced Bearer', () {
      final request = XkHttpRequest(httpConfig: const XkHttpConfig());
      final headers = request.generateHeaders(token: 'JWT123');
      expect(headers['Authorization'], 'Bearer JWT123');
      // Regression: previously produced "Bearer  JWT123" (double space).
      expect(headers['Authorization'], isNot(contains('  ')));
    });

    test('honours a custom auth header name + bare-token scheme', () {
      final request = XkHttpRequest(
        httpConfig: const XkHttpConfig(
          authHeaderName: 'x-cosentio-account-session',
        ),
      );
      final headers = request.generateHeaders(token: 'SESSION123');
      expect(headers['x-cosentio-account-session'], 'SESSION123');
      expect(headers.containsKey('Authorization'), isFalse);
    });

    test('honours an explicit custom scheme', () {
      final request = XkHttpRequest(
        httpConfig: const XkHttpConfig(authHeaderScheme: 'Token '),
      );
      final headers = request.generateHeaders(token: 'abc');
      expect(headers['Authorization'], 'Token abc');
    });

    test('multipart headers carry auth but not a boundary-clobbering type', () {
      final request = XkHttpRequest(httpConfig: const XkHttpConfig());
      final headers = request.generateMultipartHeaders(token: 'JWT123');
      expect(headers['Authorization'], 'Bearer JWT123');
      expect(headers.containsKey('Content-Type'), isFalse);
    });
  });

  group('M34 — absolute URL + query preserves scheme/host', () {
    final request = XkHttpRequest(httpConfig: const XkHttpConfig());

    test('absolute custom URL keeps scheme/host when query is added', () {
      final uri = request.custom(
        uriAddress: 'https://api.x.com/v1/items',
        queryParameters: <String, dynamic>{'page': 2, 'q': 'hi'},
      );
      expect(uri.scheme, 'https');
      expect(uri.host, 'api.x.com');
      expect(uri.path, '/v1/items');
      expect(uri.queryParameters['page'], '2');
      expect(uri.queryParameters['q'], 'hi');
    });

    test('merges query with a query already present in the absolute URL', () {
      final uri = request.custom(
        uriAddress: 'https://api.x.com/v1/items?existing=1',
        queryParameters: <String, dynamic>{'page': 2},
      );
      expect(uri.host, 'api.x.com');
      expect(uri.queryParameters['existing'], '1');
      expect(uri.queryParameters['page'], '2');
    });

    test('raw query no longer bypasses baseUrl', () {
      final baseRequest = XkHttpRequest(
        httpConfig: const XkHttpConfig(baseUrl: 'https://api.x.com/api/v1'),
      );
      final uri = baseRequest.resolveUri(path: '/people', query: 'q=a&n=2');
      expect(uri.host, 'api.x.com');
      expect(uri.path, '/api/v1/people');
      expect(uri.queryParameters['q'], 'a');
      expect(uri.queryParameters['n'], '2');
    });
  });

  group('M33 — CUSTOM/MULTIPART go through response.process', () {
    XkHttpClient clientWith(MockClient mock) => XkHttpClient(
          httpConfig: const XkHttpConfig(enableLogging: false),
          client: mock,
        );

    test('custom throws typed XkException on error status (not raw decode)',
        () async {
      final mock = MockClient((http.Request req) async {
        return http.Response(
          jsonEncode(<String, dynamic>{
            'error': <String, dynamic>{'code': 'X_BAD', 'detail': 'nope'},
          }),
          400,
        );
      });
      final client = clientWith(mock);
      await expectLater(
        client.custom(uriAddress: 'https://api.x.com/v1/x', method: 'GET'),
        throwsA(isA<XkException>()),
      );
    });

    test('custom returns decoded body on 200', () async {
      final mock = MockClient(
        (http.Request req) async => http.Response('{"ok":true}', 200),
      );
      final result = await clientWith(mock)
          .custom(uriAddress: 'https://api.x.com/v1/x', method: 'GET');
      expect(result, <String, dynamic>{'ok': true});
    });

    test('multipart honours query params and processes error envelopes',
        () async {
      Uri? seenUrl;
      final mock = MockClient((http.Request req) async {
        seenUrl = req.url;
        return http.Response(
          jsonEncode(<String, dynamic>{
            'error': <String, dynamic>{'code': 'TOO_BIG', 'detail': 'big'},
          }),
          422,
        );
      });
      final client = clientWith(mock);
      try {
        await client.multipart(
          uriAddress: 'https://api.x.com/v1/upload',
          method: 'POST',
          bytes: <int>[1, 2, 3],
          filename: 'a.txt',
          queryParameters: <String, dynamic>{'folder': 'docs'},
        );
        fail('expected XkException');
      } on XkException catch (e) {
        expect(e.xkError.statusCode, 422);
        expect(e.xkError.code, 'TOO_BIG');
      }
      expect(seenUrl?.queryParameters['folder'], 'docs');
      expect(seenUrl?.host, 'api.x.com');
    });
  });

  group('L7 — client lifecycle', () {
    test('injected client is reused and NOT closed by XkHttpClient.close', () {
      final tracker = _TrackingClient();
      final client =
          XkHttpClient(httpConfig: const XkHttpConfig(), client: tracker);
      client.close();
      expect(tracker.closed, isFalse); // caller owns injected client
    });
  });
}

class _TrackingClient extends http.BaseClient {
  bool closed = false;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(const Stream<List<int>>.empty(), 200);
  }

  @override
  void close() {
    closed = true;
  }
}
