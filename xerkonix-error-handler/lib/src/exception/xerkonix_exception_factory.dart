// ignore_for_file: deprecated_member_use_from_same_package
import 'package:xerkonix_error_handler/src/error/xerkonix_error.dart';

import '../error/xerkonix_errors.dart';
import 'xerkonix_exception.dart';

// Each typed exception forwards the CALLER-SUPPLIED [xkError] to `super`, so the
// stored `xkError` (and the message-registry lookup + logs performed by the base
// [XkException] constructor) reflect the real error — its subtype, code,
// statusCode and metadata — instead of a freshly-built default that discards
// everything the caller passed. When no error is supplied, the type-appropriate
// default is used. Logging/message-handling happens exactly once, in the base
// constructor (the previous per-subclass duplication is removed).

class UserInputErrorException extends XkException {
  UserInputErrorException({XkError? xkError})
      : super(xkError ?? XkErrors.userInputError());
}

class InvalidFormatException extends XkException {
  InvalidFormatException({XkError? xkError})
      : super(xkError ?? XkErrors.invalidFormat());
}

class BadRequestException extends XkException {
  BadRequestException({XkError? xkError})
      : super(xkError ?? XkErrors.badRequest());
}

class UnauthorizedException extends XkException {
  UnauthorizedException({XkError? xkError})
      : super(xkError ?? XkErrors.unauthorized());
}

class ForbiddenException extends XkException {
  ForbiddenException({XkError? xkError})
      : super(xkError ?? XkErrors.forbidden());
}

class NotFoundException extends XkException {
  NotFoundException({XkError? xkError}) : super(xkError ?? XkErrors.notFound());
}

class ConflictException extends XkException {
  ConflictException({XkError? xkError}) : super(xkError ?? XkErrors.conflict());
}

class RequestTimeoutException extends XkException {
  RequestTimeoutException({XkError? xkError})
      : super(xkError ?? XkErrors.requestTimeout());
}

class InternalServerErrorException extends XkException {
  InternalServerErrorException({XkError? xkError})
      : super(xkError ?? XkErrors.internalServerError());
}

class ServiceUnavailableException extends XkException {
  ServiceUnavailableException({XkError? xkError})
      : super(xkError ?? XkErrors.serviceUnavailable());
}

class UnknownErrorException extends XkException {
  UnknownErrorException({XkError? xkError})
      : super(xkError ?? XkErrors.unknownError());
}

class UnstableNetworkException extends XkException {
  UnstableNetworkException({XkError? xkError})
      : super(xkError ?? XkErrors.unstableNetwork());
}
