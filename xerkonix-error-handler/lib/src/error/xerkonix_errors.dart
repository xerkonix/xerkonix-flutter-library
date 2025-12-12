import 'xerkonix_error.dart';
import 'xerkonix_error_factory.dart';

class XkErrors implements XkError {
  XkErrors({this.code, this.type, this.message, this.title, this.detail});

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
  String toString() {
    return "${code != null
        ? "code: $code\n"
        : ""}$type\n$message\n$title\n$detail";
  }

  @override
  StackTrace? get stackTrace => StackTrace.current;

  factory XkErrors.userInputError({String? type, String? message, String? title, String? detail}) = UserInputError;

  factory XkErrors.invalidFormat({String? type, String? message, String? title, String? detail}) = InvalidFormat;

  factory XkErrors.badRequest({String? type, String? message, String? title, String? detail}) = BadRequest;

  factory XkErrors.unauthorized({String? type, String? message, String? title, String? detail}) = Unauthorized;

  factory XkErrors.forbidden({String? type, String? message, String? title, String? detail}) = Forbidden;

  factory XkErrors.notFound({String? type, String? message, String? title, String? detail}) = NotFound;

  factory XkErrors.conflict({String? type, String? message, String? title, String? detail}) = Conflict;

  factory XkErrors.unprocessableEntity({String? type, String? message, String? title, String? detail}) = UnprocessableEntity;

  factory XkErrors.requestTimeout({String? type, String? message, String? title, String? detail}) = RequestTimeout;

  factory XkErrors.internalServerError({String? type, String? message, String? title, String? detail}) = InternalServerError;

  factory XkErrors.serviceUnavailable({String? type, String? message, String? title, String? detail}) = ServiceUnavailable;

  factory XkErrors.unknownError({String? type, String? message, String? title, String? detail}) = UnknownError;

  factory XkErrors.unstableNetwork({String? type, String? message, String? title, String? detail}) = UnstableNetwork;
}
