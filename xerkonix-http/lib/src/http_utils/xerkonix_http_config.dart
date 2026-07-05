import 'package:flutter/foundation.dart';

import '../constant/http_constant.dart';

class XkHttpConfig {
  const XkHttpConfig({
    this.scheme = "https",
    this.host = "localhost",
    this.port = 443,
    this.contentType = "application/json",
    this.tokenType = "Bearer ",
    this.networkTimeLimit = const Duration(milliseconds: 20000),
    this.jsonDecodingOption = JsonDecodingOption.noOption,
    this.enableLogging,
    // --- 1.1.0 additive options ------------------------------------------
    this.baseUrl,
    this.authHeaderName = 'Authorization',
    this.authHeaderScheme,
    this.unwrapDataEnvelope = false,
    this.authEndpointSkipList = const <String>['/api/v1/auth/'],
  });

  final String scheme;
  final String host;
  final int port;
  final String contentType;
  final String tokenType;
  final Duration networkTimeLimit;
  final JsonDecodingOption jsonDecodingOption;
  final bool? enableLogging;

  /// A single base-URL string (scheme + host + port + path-prefix), e.g.
  /// `https://api.cosentio.com/api/v1`. When set, it takes precedence over the
  /// discrete [scheme]/[host]/[port] for URL construction (see
  /// [XkInterceptedClient]).
  final String? baseUrl;

  /// The header NAME to carry the auth token. Defaults to `Authorization`, but
  /// can be a custom header like `x-cosentio-account-session`.
  final String authHeaderName;

  /// The scheme/prefix placed before the token in [authHeaderName]. When `null`
  /// it falls back to [tokenType] for the standard `Authorization` header, and
  /// to an empty string for custom headers (which usually carry a bare token).
  final String? authHeaderScheme;

  /// When `true`, a successful `{statusCode, data}` envelope is unwrapped to its
  /// `data` map (parity with the product `_decode` behaviour).
  final bool unwrapDataEnvelope;

  /// Request path fragments that identify auth endpoints; the 401 refresh-retry
  /// interceptor skips these to avoid recursive refresh loops.
  final List<String> authEndpointSkipList;

  /// 로깅이 활성화되어 있는지 확인
  /// enableLogging이 null이면 kDebugMode를 반환 (기본값: 개발 환경에서만 활성화)
  bool get isLoggingEnabled => enableLogging ?? kDebugMode;

  /// The effective scheme prepended to the auth token in [authHeaderName].
  String get effectiveAuthHeaderScheme =>
      authHeaderScheme ??
      (authHeaderName.toLowerCase() == 'authorization' ? tokenType : '');

  /// Returns a copy with the given overrides. Additive helper; all existing
  /// fields are preserved when not specified.
  XkHttpConfig copyWith({
    String? scheme,
    String? host,
    int? port,
    String? contentType,
    String? tokenType,
    Duration? networkTimeLimit,
    JsonDecodingOption? jsonDecodingOption,
    bool? enableLogging,
    String? baseUrl,
    String? authHeaderName,
    String? authHeaderScheme,
    bool? unwrapDataEnvelope,
    List<String>? authEndpointSkipList,
  }) {
    return XkHttpConfig(
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      port: port ?? this.port,
      contentType: contentType ?? this.contentType,
      tokenType: tokenType ?? this.tokenType,
      networkTimeLimit: networkTimeLimit ?? this.networkTimeLimit,
      jsonDecodingOption: jsonDecodingOption ?? this.jsonDecodingOption,
      enableLogging: enableLogging ?? this.enableLogging,
      baseUrl: baseUrl ?? this.baseUrl,
      authHeaderName: authHeaderName ?? this.authHeaderName,
      authHeaderScheme: authHeaderScheme ?? this.authHeaderScheme,
      unwrapDataEnvelope: unwrapDataEnvelope ?? this.unwrapDataEnvelope,
      authEndpointSkipList: authEndpointSkipList ?? this.authEndpointSkipList,
    );
  }
}
