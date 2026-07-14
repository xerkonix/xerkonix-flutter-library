import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';

import '../constant/http_constant.dart';
import '../http_utils/xerkonix_http_config.dart';
import 'xerkonix_http_request.dart';
import 'xerkonix_http_response.dart';

class XkHttpClient {
  /// [client] lets callers inject (and reuse) a single [http.Client] across
  /// requests — connection pooling, mockability, and a deterministic [close]
  /// contract. When omitted, a default [http.Client] is created and owned by
  /// this instance (and torn down by [close]).
  XkHttpClient({required this.httpConfig, http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null {
    request = XkHttpRequest(httpConfig: httpConfig);
    response = XkHttpResponse(httpConfig: httpConfig);
  }

  final XkHttpConfig httpConfig;

  final http.Client _client;
  final bool _ownsClient;

  late XkHttpRequest request;

  late XkHttpResponse response;

  void _logRequest(http.Request httpRequest) {
    if (httpConfig.isLoggingEnabled) {
      Logger.httpRequest(
        httpRequest: httpRequest,
        logBody: httpConfig.isRequestBodyLoggingEnabled,
        maxBodyLength: httpConfig.maxLogBodyLength,
      );
    }
  }

  /// Sends [httpRequest] over the shared client and routes the response through
  /// the shared [XkHttpResponse.process] pipeline (status handling + typed error
  /// envelopes), with unified timeout/error normalisation.
  Future<dynamic> _send(http.BaseRequest httpRequest) async {
    try {
      final streamedResponse =
          await _client.send(httpRequest).timeout(httpConfig.networkTimeLimit);
      final result = await http.Response.fromStream(streamedResponse);
      return response.process(result);
    } on TimeoutException {
      throw XkException.requestTimeout();
    } on XkException {
      rethrow;
    } catch (error) {
      Logger.errorMessage(error);
      throw XkException.unknownError();
    }
  }

  /// 공통 HTTP 요청 실행 메서드
  Future<dynamic> _executeRequest({
    required String method,
    required String path,
    int? port,
    Map<String, dynamic>? queryParameters,
    String? query,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    final Uri uri = request.resolveUri(
      path: path,
      port: port,
      queryParameters: queryParameters,
      query: query,
    );
    final Map<String, String> headers = request.generateHeaders(
      token: token,
      headerList: headerList,
    );
    final http.Request httpRequest = request.generateRequest(
      method: method,
      headers: headers,
      uri: uri,
      body: body,
    );
    _logRequest(httpRequest);
    return _send(httpRequest);
  }

  Future<dynamic> get({
    required String path,
    int? port,
    Map<String, dynamic>? queryParameters,
    String? query,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    return _executeRequest(
      method: XkHttpConst.method.get,
      path: path,
      port: port,
      queryParameters: queryParameters,
      query: query,
      token: token,
      headerList: headerList,
    );
  }

  Future<dynamic> post({
    required String path,
    int? port,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    return _executeRequest(
      method: XkHttpConst.method.post,
      path: path,
      port: port,
      body: body,
      token: token,
      headerList: headerList,
    );
  }

  Future<dynamic> put({
    required String path,
    int? port,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    return _executeRequest(
      method: XkHttpConst.method.put,
      path: path,
      port: port,
      body: body,
      token: token,
      headerList: headerList,
    );
  }

  Future<dynamic> delete({
    required String path,
    int? port,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    return _executeRequest(
      method: XkHttpConst.method.delete,
      path: path,
      port: port,
      body: body,
      token: token,
      headerList: headerList,
    );
  }

  Future<dynamic> patch({
    required String path,
    int? port,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    return _executeRequest(
      method: XkHttpConst.method.patch,
      path: path,
      port: port,
      body: body,
      token: token,
      headerList: headerList,
    );
  }

  /// Uploads a file as `multipart/form-data`.
  ///
  /// The payload is passed as [bytes] + [filename] (plus optional [field] name)
  /// rather than a `dart:io` [File], so this compiles and runs on Flutter Web as
  /// well as native platforms. Callers on native/desktop can read the file via
  /// `file.readAsBytes()`; Web callers can use an `XFile`/picker's `readAsBytes`.
  ///
  /// Like every other request type, query parameters are honoured and the
  /// response is routed through [XkHttpResponse.process] (unified status +
  /// typed-error-envelope handling), instead of the previous bespoke decode.
  Future<dynamic> multipart({
    required String uriAddress,
    required String method,
    required List<int> bytes,
    required String filename,
    String field = 'file',
    Map<String, dynamic>? queryParameters,
    String? query,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    final Uri url = request.custom(
      uriAddress: uriAddress,
      queryParameters: queryParameters,
      query: query,
    );
    final multipartHeaders =
        request.generateMultipartHeaders(token: token, headerList: headerList);
    final http.MultipartRequest multipartRequest =
        http.MultipartRequest(method, url);
    multipartRequest.headers.addAll(multipartHeaders);
    multipartRequest.files.add(
      http.MultipartFile.fromBytes(field, bytes, filename: filename),
    );

    if (httpConfig.isLoggingEnabled) {
      Logger.multipartRequest(multipartRequest: multipartRequest);
    }
    return _send(multipartRequest);
  }

  Future<dynamic> custom({
    required String uriAddress,
    required String method,
    Map<String, dynamic>? queryParameters,
    String? query,
    Map<String, dynamic>? body,
    String? token,
    List<Map<String, String>>? headerList,
  }) async {
    final Uri uri = request.custom(
      uriAddress: uriAddress,
      queryParameters: queryParameters,
      query: query,
    );
    final Map<String, String> headers =
        request.generateHeaders(token: token, headerList: headerList);
    final http.Request httpRequest = request.generateRequest(
      method: method,
      headers: headers,
      body: body,
      uri: uri,
    );
    _logRequest(httpRequest);
    return _send(httpRequest);
  }

  /// Closes the underlying [http.Client] when it is owned by this instance
  /// (i.e. was not injected by the caller). Injected clients are the caller's to
  /// manage.
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
