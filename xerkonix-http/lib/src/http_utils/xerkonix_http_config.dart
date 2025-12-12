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
  });

  final String scheme;
  final String host;
  final int port;
  final String contentType;
  final String tokenType;
  final Duration networkTimeLimit;
  final JsonDecodingOption jsonDecodingOption;
  final bool? enableLogging;

  /// 로깅이 활성화되어 있는지 확인
  /// enableLogging이 null이면 kDebugMode를 반환 (기본값: 개발 환경에서만 활성화)
  bool get isLoggingEnabled => enableLogging ?? kDebugMode;
}
