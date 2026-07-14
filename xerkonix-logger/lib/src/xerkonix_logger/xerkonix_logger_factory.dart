import 'package:http/http.dart' as http;

import '../xerkonix_logger_util.dart';
import 'xerkonix_log_sanitizer.dart';
import 'xerkonix_logger.dart';

class DefaultLogger implements Logger {
  DefaultLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.log, message);
  }
}

class DebuggingLogger implements Logger {
  DebuggingLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.debug, message);
  }
}

class ErrorMessageLogger implements Logger {
  ErrorMessageLogger(dynamic message, {int? methodCount}) {
    LoggerUtil.createLogger(LoggerUtil.emojis.error, message);
  }
}

class ExceptionLogger implements Logger {
  ExceptionLogger(Exception exception, {int? errorMethodCount}) {
    LoggerUtil.createLogger(LoggerUtil.emojis.exception, exception,
        methodCount: errorMethodCount ??= 10);
  }
}

class ErrorLogger implements Logger {
  ErrorLogger(Error error, {int? methodCount}) {
    LoggerUtil.createLogger(LoggerUtil.emojis.error, error,
        methodCount: methodCount);
  }
}

class WarningLogger implements Logger {
  WarningLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.warning, message);
  }
}

class LogLogger implements Logger {
  LogLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.message, message);
  }
}

class InformationLogger implements Logger {
  InformationLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.info, message);
  }
}

class BuildLogger implements Logger {
  BuildLogger(dynamic message) {
    LoggerUtil.createLogger(LoggerUtil.emojis.build, message);
  }
}

class HttpRequestLogger implements Logger {
  HttpRequestLogger({
    required http.Request httpRequest,
    bool logBody = false,
    int maxBodyLength = XkLogSanitizer.defaultMaxBodyLength,
  }) {
    final String url = XkLogSanitizer.sanitizeUri(httpRequest.url);
    final Map<String, String> headers =
        XkLogSanitizer.sanitizeHeaders(httpRequest.headers);
    final String body = XkLogSanitizer.bodyForLog(
      httpRequest.body,
      logBody: logBody,
      maxLength: maxBodyLength,
    );
    String logMessage =
        "Http Request ${DateTime.now()}\nURI: $url\nMethod: ${httpRequest.method}\nheaders: $headers\nBody: $body";
    LoggerUtil.createLogger(LoggerUtil.emojis.send, logMessage);
  }
}

class MultipartRequestLogger implements Logger {
  MultipartRequestLogger({required http.MultipartRequest multipartRequest}) {
    final String url = XkLogSanitizer.sanitizeUri(multipartRequest.url);
    final Map<String, String> headers =
        XkLogSanitizer.sanitizeHeaders(multipartRequest.headers);
    // File contents are never logged; only field/filename/length metadata.
    final String files = multipartRequest.files
        .map((http.MultipartFile f) =>
            '{field: ${f.field}, filename: ${f.filename}, length: ${f.length}}')
        .join(', ');
    String logMessage =
        "Http Request ${DateTime.now()}\nURI: $url\nMethod: ${multipartRequest.method}\nheaders: $headers\nfiles: [$files]";
    LoggerUtil.createLogger(LoggerUtil.emojis.send, logMessage);
  }
}

class HttpResponseLogger implements Logger {
  HttpResponseLogger({
    required http.Response httpResponse,
    bool printHeaders = false,
    bool logBody = false,
    int maxBodyLength = XkLogSanitizer.defaultMaxBodyLength,
  }) {
    final String body = XkLogSanitizer.bodyForLog(
      httpResponse.body,
      logBody: logBody,
      maxLength: maxBodyLength,
    );
    late String logMessage;
    printHeaders == false
        ? logMessage =
            "Http Response ${DateTime.now()}\nStatus Code: ${httpResponse.statusCode}\nBody: $body"
        : logMessage =
            "Http Response ${DateTime.now()}\nStatus Code: ${httpResponse.statusCode}\nHeaders ${XkLogSanitizer.sanitizeHeaders(httpResponse.headers)}\nBody: $body";
    LoggerUtil.createLogger(LoggerUtil.emojis.receive, logMessage);
  }
}

class HtmlRequestLogger implements Logger {
  HtmlRequestLogger(
      {required String method,
      required Map<String, String> headers,
      required Uri uri,
      String? body,
      bool logBody = false,
      int maxBodyLength = XkLogSanitizer.defaultMaxBodyLength,
      int? methodCount}) {
    final String url = XkLogSanitizer.sanitizeUri(uri);
    final Map<String, String> safeHeaders =
        XkLogSanitizer.sanitizeHeaders(headers);
    final String safeBody = XkLogSanitizer.bodyForLog(
      body,
      logBody: logBody,
      maxLength: maxBodyLength,
    );
    late String logMessage =
        "Request ${DateTime.now()}\nURI: $url\nMethod: $method\nheaders: $safeHeaders\nBody: $safeBody";
    LoggerUtil.createLogger(LoggerUtil.emojis.send, logMessage);
  }
}

class HtmlResponseLogger implements Logger {
  HtmlResponseLogger(
      {Map<String, String>? printHeaders,
      required int statusCode,
      required String body,
      bool logBody = false,
      int maxBodyLength = XkLogSanitizer.defaultMaxBodyLength,
      int? methodCount}) {
    final String safeBody = XkLogSanitizer.bodyForLog(
      body,
      logBody: logBody,
      maxLength: maxBodyLength,
    );
    late String logMessage;
    printHeaders == null
        ? logMessage =
            "${DateTime.now()}\nResponse\nStatus Code: $statusCode\nBody: $safeBody"
        : logMessage =
            "${DateTime.now()}\nResponse\nStatus Code: $statusCode\nHeaders ${XkLogSanitizer.sanitizeHeaders(printHeaders)}\nBody: $safeBody";
    LoggerUtil.createLogger(LoggerUtil.emojis.receive, logMessage);
  }
}
