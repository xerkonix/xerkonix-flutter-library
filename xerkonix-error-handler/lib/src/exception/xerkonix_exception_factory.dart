import 'package:xerkonix_error_handler/src/error/xerkonix_error.dart';

import '../error/xerkonix_errors.dart';
import '../error_message_handler/xerkonix_message_handler.dart';
import 'xerkonix_exception.dart';

class UserInputErrorException extends XkException {
  @override
  UserInputErrorException({XkError? xkError}) : super(XkErrors.userInputError()) {
    xkError ??= XkErrors.userInputError();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class InvalidFormatException extends XkException {
  @override
  InvalidFormatException({XkError? xkError}) : super(XkErrors.invalidFormat()) {
    xkError ??= XkErrors.invalidFormat();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class BadRequestException extends XkException {
  @override
  BadRequestException({XkError? xkError}) : super(XkErrors.badRequest()) {
    xkError ??= XkErrors.badRequest();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class UnauthorizedException extends XkException {
  @override
  UnauthorizedException({XkError? xkError}) : super(XkErrors.unauthorized()) {
    xkError ??= XkErrors.unauthorized();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class ForbiddenException extends XkException {
  @override
  ForbiddenException({XkError? xkError}) : super(XkErrors.forbidden()) {
    xkError ??= XkErrors.forbidden();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class NotFoundException extends XkException {
  @override
  NotFoundException({XkError? xkError}) : super(XkErrors.notFound()) {
    xkError ??= XkErrors.notFound();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class ConflictException extends XkException {
  @override
  ConflictException({XkError? xkError}) : super(XkErrors.conflict()) {
    xkError ??= XkErrors.conflict();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class RequestTimeoutException extends XkException {
  @override
  RequestTimeoutException({XkError? xkError}) : super(XkErrors.requestTimeout()) {
    xkError ??= XkErrors.requestTimeout();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class InternalServerErrorException extends XkException {
  @override
  InternalServerErrorException({XkError? xkError}) : super(XkErrors.internalServerError()) {
    xkError ??= XkErrors.internalServerError();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class ServiceUnavailableException extends XkException {
  @override
  ServiceUnavailableException({XkError? xkError}) : super(XkErrors.serviceUnavailable()) {
    xkError ??= XkErrors.serviceUnavailable();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class UnknownErrorException extends XkException {
  @override
  UnknownErrorException({XkError? xkError}) : super(XkErrors.unknownError()) {
    xkError ??= XkErrors.unknownError();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}

class UnstableNetworkException extends XkException {
  @override
  UnstableNetworkException({XkError? xkError}) : super(XkErrors.unstableNetwork()) {
    xkError ??= XkErrors.unstableNetwork();
    printExceptionLog(this);
    printErrorLog();
    XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }
}
