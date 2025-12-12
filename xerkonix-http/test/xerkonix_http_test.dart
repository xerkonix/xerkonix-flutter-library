import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_http/xerkonix_http.dart';
import 'package:http/http.dart' as http;

void main() {
  group('XkHttpUtils Tests', () {
    test('generateHttp should create XkHttp instance with default values', () {
      final xkHttp = XkHttpUtils.generateHttp(host: 'example.com');
      
      expect(xkHttp.config.scheme, 'https');
      expect(xkHttp.config.host, 'example.com');
      expect(xkHttp.config.port, 3000);
      expect(xkHttp.config.contentType, 'application/json');
      expect(xkHttp.config.tokenType, 'Bearer ');
      expect(xkHttp.config.jsonDecodingOption, JsonDecodingOption.noOption);
    });

    test('generateHttp should create XkHttp instance with custom values', () {
      final xkHttp = XkHttpUtils.generateHttp(
        scheme: 'http',
        host: 'localhost',
        port: 8080,
        contentType: 'application/xml',
        tokenType: 'Token ',
        jsonDecodingOption: JsonDecodingOption.utf8,
      );
      
      expect(xkHttp.config.scheme, 'http');
      expect(xkHttp.config.host, 'localhost');
      expect(xkHttp.config.port, 8080);
      expect(xkHttp.config.contentType, 'application/xml');
      expect(xkHttp.config.tokenType, 'Token ');
      expect(xkHttp.config.jsonDecodingOption, JsonDecodingOption.utf8);
    });

    test('jsonDecode should decode JSON response', () {
      final response = http.Response('{"key": "value"}', 200);
      final result = XkHttpUtils.jsonDecode(response: response);
      
      expect(result, isA<Map>());
      expect(result['key'], 'value');
    });

    test('jsonDecodeFromUTF8 should decode UTF-8 JSON response', () {
      final response = http.Response('{"key": "value"}', 200);
      final result = XkHttpUtils.jsonDecodeFromUTF8(response: response);
      
      expect(result, isA<Map>());
      expect(result['key'], 'value');
    });

    test('encodeRequestBodyToJson should encode data to JSON bytes', () {
      final data = {'key': 'value'};
      final result = XkHttpUtils.encodeRequestBodyToJson(
        data,
        XkHttpConst.contentType.json,
      );
      
      expect(result, isA<List<int>>());
    });

    test('encodeRequestBodyToJson should return original data for non-JSON content type', () {
      final data = 'plain text';
      final result = XkHttpUtils.encodeRequestBodyToJson(
        data,
        'text/plain',
      );
      
      expect(result, data);
    });
  });

  group('XkHttpConfig Tests', () {
    test('XkHttpConfig should have default values', () {
      const config = XkHttpConfig();
      
      expect(config.scheme, 'https');
      expect(config.host, 'localhost');
      expect(config.port, 443);
      expect(config.contentType, 'application/json');
      expect(config.tokenType, 'Bearer ');
      expect(config.networkTimeLimit, const Duration(milliseconds: 20000));
      expect(config.jsonDecodingOption, JsonDecodingOption.noOption);
    });

    test('XkHttpConfig should accept custom values', () {
      const config = XkHttpConfig(
        scheme: 'http',
        host: 'example.com',
        port: 8080,
        contentType: 'application/xml',
        tokenType: 'Token ',
        networkTimeLimit: Duration(seconds: 30),
        jsonDecodingOption: JsonDecodingOption.utf8,
      );
      
      expect(config.scheme, 'http');
      expect(config.host, 'example.com');
      expect(config.port, 8080);
      expect(config.contentType, 'application/xml');
      expect(config.tokenType, 'Token ');
      expect(config.networkTimeLimit, const Duration(seconds: 30));
      expect(config.jsonDecodingOption, JsonDecodingOption.utf8);
    });
  });

  group('XkHttpConst Tests', () {
    test('XkHttpConst should have correct content type', () {
      expect(XkHttpConst.contentType.json, 'application/json');
    });

    test('XkHttpConst should have correct token type', () {
      expect(XkHttpConst.tokenType.bearer, 'Bearer ');
    });

    test('XkHttpConst should have correct HTTP methods', () {
      expect(XkHttpConst.method.get, 'GET');
      expect(XkHttpConst.method.post, 'POST');
      expect(XkHttpConst.method.put, 'PUT');
      expect(XkHttpConst.method.delete, 'DELETE');
      expect(XkHttpConst.method.patch, 'PATCH');
    });

    test('XkHttpConst should have correct JSON decoding options', () {
      expect(XkHttpConst.jsonEncodingOption.noOption, JsonDecodingOption.noOption);
      expect(XkHttpConst.jsonEncodingOption.utf8, JsonDecodingOption.utf8);
    });
  });
}
