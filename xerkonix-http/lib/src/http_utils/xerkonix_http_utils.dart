import 'dart:convert' as convert;
import 'package:xerkonix_logger/xerkonix_logger.dart';
import 'package:http/http.dart' as http;

import '../constant/http_constant.dart';
import '../xerkonix_http/xerkonix_http.dart';
import '../xerkonix_http/xerkonix_http_client.dart';
import 'xerkonix_http_config.dart';

class XkHttpUtils {
  XkHttpUtils._();

  static dynamic encodeRequestBodyToJson(dynamic data, String contentType) {
    return contentType == XkHttpConst.contentType.json
        ? convert.utf8.encode(convert.jsonEncode(data))
        : data;
  }

  static dynamic jsonDecode({required http.Response response}) {
    return convert.jsonDecode(response.body);
  }

  static dynamic jsonDecodeFromUTF8({required http.Response response}) {
    return convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
  }

  static void requestLogger({required http.Request request}) {
    Logger.httpRequest(httpRequest: request);
  }

  static void responseLogger({required http.Response response}) {
    Logger.httpResponse(httpResponse: response);
  }

  static XkHttp generateHttp(
      {String? scheme,
      required String host,
      int? port,
      String? contentType,
      String? tokenType,
      JsonDecodingOption? jsonDecodingOption,
      bool? enableLogging}) {
    final httpConfig = XkHttpConfig(
      scheme: scheme ?? "https",
      host: host,
      port: port ?? 3000,
      contentType: contentType ?? "application/json",
      tokenType: tokenType ?? "Bearer ",
      jsonDecodingOption: jsonDecodingOption ?? JsonDecodingOption.noOption,
      enableLogging: enableLogging,
    );
    return XkHttp(
        config: httpConfig, client: XkHttpClient(httpConfig: httpConfig));
  }

  /// 1.1.0: builds an [XkHttp] from a single [baseUrl] string
  /// (scheme+host+port+path-prefix), plus the additive auth/envelope options.
  static XkHttp generateHttpFromBaseUrl({
    required String baseUrl,
    String? contentType,
    String? tokenType,
    String authHeaderName = 'Authorization',
    String? authHeaderScheme,
    bool unwrapDataEnvelope = false,
    JsonDecodingOption? jsonDecodingOption,
    Duration? networkTimeLimit,
    bool? enableLogging,
    List<String>? authEndpointSkipList,
  }) {
    final httpConfig = XkHttpConfig(
      baseUrl: baseUrl,
      contentType: contentType ?? "application/json",
      tokenType: tokenType ?? "Bearer ",
      authHeaderName: authHeaderName,
      authHeaderScheme: authHeaderScheme,
      unwrapDataEnvelope: unwrapDataEnvelope,
      jsonDecodingOption: jsonDecodingOption ?? JsonDecodingOption.noOption,
      networkTimeLimit:
          networkTimeLimit ?? const Duration(milliseconds: 20000),
      enableLogging: enableLogging,
      authEndpointSkipList:
          authEndpointSkipList ?? const <String>['/api/v1/auth/'],
    );
    return XkHttp(
        config: httpConfig, client: XkHttpClient(httpConfig: httpConfig));
  }
}
