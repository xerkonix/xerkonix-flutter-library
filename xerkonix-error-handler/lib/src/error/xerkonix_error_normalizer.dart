import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'xerkonix_error.dart';
import 'xerkonix_errors.dart';

/// Maps raw failures (HTTP status codes, thrown exceptions, response envelopes)
/// into the typed [XkError] hierarchy.
///
/// This is additive: it complements the existing `XkErrors` factories rather
/// than replacing them.
class XkErrorNormalizer {
  const XkErrorNormalizer._();

  /// Returns the most specific [XkError] subtype for an HTTP [statusCode].
  ///
  /// Any of [code]/[message]/[title]/[detail]/[metadata] supplied override the
  /// subtype defaults. Unmapped 4xx/5xx (and 3xx) fall back to [UnknownError],
  /// but the real [statusCode]/[metadata] are still preserved on the result.
  static XkError fromStatusCode(
    int statusCode, {
    String? code,
    String? message,
    String? title,
    String? detail,
    Map<String, dynamic>? metadata,
  }) {
    // Returns the concrete subtype directly, preserving both its runtime type
    // (so `isA<PaymentRequired>()` / `isA<TooManyRequests>()` etc. hold at the
    // call site) AND the real statusCode + metadata + business code. The subtype
    // factories accept statusCode/metadata, so no lossy re-wrap into base
    // XkError is needed.
    switch (statusCode) {
      case 400:
        return XkErrors.badRequest(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 401:
        return XkErrors.unauthorized(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 402:
        return XkErrors.paymentRequired(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 403:
        return XkErrors.forbidden(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 404:
        return XkErrors.notFound(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 408:
        return XkErrors.requestTimeout(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 409:
        return XkErrors.conflict(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 422:
        return XkErrors.unprocessableEntity(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 429:
        return XkErrors.tooManyRequests(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 500:
        return XkErrors.internalServerError(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      case 503:
        return XkErrors.serviceUnavailable(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
      default:
        return XkErrors.unknownError(
            code: code, message: message, title: title, detail: detail, statusCode: statusCode, metadata: metadata);
    }
  }

  /// Normalizes a caught [error] (typically from an `http` call) into an
  /// [XkError]:
  ///  * [TimeoutException] → [NetworkTimeout]
  ///  * [SocketException] / [http.ClientException] → [NetworkUnknown]
  ///  * [FormatException] → [InvalidFormat]
  ///  * an existing [XkError] is returned unchanged
  ///  * anything else → [UnknownError]
  static XkError normalizeException(Object error) {
    if (error is XkError) {
      return error;
    }
    if (error is TimeoutException) {
      return XkErrors.networkTimeout();
    }
    if (error is SocketException) {
      return XkErrors.networkUnknown(detail: error.message);
    }
    if (error is http.ClientException) {
      return XkErrors.networkUnknown(detail: error.message);
    }
    if (error is FormatException) {
      return XkErrors.invalidFormat(detail: error.message);
    }
    return XkErrors.unknownError(message: error.toString());
  }

  /// Parses an HTTP response [body] (already-decoded JSON or a raw string) plus
  /// its [statusCode] into an [XkError] following the product envelope contract:
  ///
  /// ```json
  /// { "error": { "code": "...", "title": "...", "detail": "...",
  ///              "message": "...", "metadata": { ... } } }
  /// ```
  /// or a bare `{ "detail": "..." }`. Only applied when [statusCode] >= 400;
  /// for < 400 this returns `null` (there is no error to build).
  static XkError? fromEnvelope(Object? body, int statusCode) {
    if (statusCode < 400) {
      return null;
    }
    String? code;
    String? title;
    String? detail;
    String? message;
    Map<String, dynamic> metadata = const <String, dynamic>{};

    if (body is Map) {
      final Object? error = body['error'];
      if (error is Map) {
        code = _string(error['code']);
        title = _string(error['title']);
        detail = _string(error['detail']);
        message = _string(error['message']);
        final Object? meta = error['metadata'];
        if (meta is Map) {
          metadata = meta.map(
            (Object? k, Object? v) => MapEntry('$k', v),
          );
        }
      }
      // Bare {detail:...} envelope.
      detail ??= _string(body['detail']);
      message ??= _string(body['message']);
    } else if (body is String) {
      detail = _string(body);
    }

    return fromStatusCode(
      statusCode,
      code: code,
      // Prefer detail as the human-facing message, then message, then title.
      message: message ?? detail ?? title,
      title: title,
      detail: detail ?? message,
      metadata: metadata,
    );
  }

  static String? _string(Object? value) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
