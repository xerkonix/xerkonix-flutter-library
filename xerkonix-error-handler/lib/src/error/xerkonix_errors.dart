import 'xerkonix_error.dart';
import 'xerkonix_error_factory.dart';
import 'xerkonix_error_normalizer.dart';

class XkErrors implements XkError {
  XkErrors({
    this.code,
    this.type,
    this.message,
    this.title,
    this.detail,
    this.statusCode,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  @override
  final String? code;
  @override
  final String? type;
  @override
  final String? message;
  @override
  final String? title;
  @override
  final String? detail;
  @override
  final int? statusCode;
  @override
  final Map<String, dynamic> metadata;

  @override
  String toString() {
    return "${code != null
        ? "code: $code\n"
        : ""}$type\n$message\n$title\n$detail";
  }

  @override
  StackTrace? get stackTrace => StackTrace.current;

  factory XkErrors.userInputError({String? type, String? message, String? title, String? detail}) = UserInputError;

  factory XkErrors.invalidFormat({String? type, String? message, String? title, String? detail}) = InvalidFormat;

  factory XkErrors.badRequest({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = BadRequest;

  factory XkErrors.unauthorized({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = Unauthorized;

  factory XkErrors.forbidden({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = Forbidden;

  factory XkErrors.notFound({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = NotFound;

  factory XkErrors.conflict({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = Conflict;

  factory XkErrors.unprocessableEntity({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = UnprocessableEntity;

  factory XkErrors.requestTimeout({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = RequestTimeout;

  factory XkErrors.internalServerError({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = InternalServerError;

  factory XkErrors.serviceUnavailable({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = ServiceUnavailable;

  factory XkErrors.unknownError({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = UnknownError;

  factory XkErrors.unstableNetwork({String? type, String? message, String? title, String? detail}) = UnstableNetwork;

  // --- 1.1.0 additive subtypes -------------------------------------------

  /// 402 Payment Required / quota-exceeded.
  factory XkErrors.paymentRequired({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = PaymentRequired;

  /// 429 Too Many Requests / rate-limited.
  factory XkErrors.tooManyRequests({String? code, String? type, String? message, String? title, String? detail, int? statusCode, Map<String, dynamic>? metadata}) = TooManyRequests;

  /// Synthetic network-timeout error (no HTTP status). Carries code
  /// [XkErrorCodes.networkTimeout].
  factory XkErrors.networkTimeout({String? type, String? message, String? title, String? detail}) = NetworkTimeout;

  /// Synthetic network-unknown error (connectivity/socket failure). Carries code
  /// [XkErrorCodes.networkUnknown].
  factory XkErrors.networkUnknown({String? type, String? message, String? title, String? detail}) = NetworkUnknown;

  /// Maps an HTTP [statusCode] to the most specific known [XkErrors] subtype,
  /// falling back to [UnknownError] for unmapped codes.
  ///
  /// See [XkErrorNormalizer.fromStatusCode].
  static XkError fromStatusCode(
    int statusCode, {
    String? code,
    String? message,
    String? title,
    String? detail,
    Map<String, dynamic>? metadata,
  }) =>
      XkErrorNormalizer.fromStatusCode(
        statusCode,
        code: code,
        message: message,
        title: title,
        detail: detail,
        metadata: metadata,
      );
}
