// ignore: depend_on_referenced_packages
import '../error/xerkonix_error.dart';
import '../error_message_handler/xerkonix_message_handler.dart';
import 'xerkonix_exception_factory.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';

class XkException implements Exception {
  XkException(this.xkError){
   printErrorLog();
   printExceptionLog(this);
   XkErrorMessageHandler.setErrorMessage(xkError: xkError);
  }

  XkError xkError;

  @override
  String toString() {
    return "${"${xkError.runtimeType}Exception"}: ${xkError.message ?? ""}";
  }

  void printErrorLog(){
     Logger.error(xkError);
  }

  void printExceptionLog(Exception xkException) {
    Logger.exception(errorMethodCount: 10, xkException);
  }

  factory XkException.userInputError({XkError? xkError}) = UserInputErrorException;

  factory XkException.invalidFormat({XkError? xkError}) = InvalidFormatException;

  factory XkException.badRequest({XkError? xkError}) = BadRequestException;

  factory XkException.unauthorized({XkError? xkError}) = UnauthorizedException;

  factory XkException.forbidden({XkError? xkError}) = ForbiddenException;

  factory XkException.notFound({XkError? xkError}) = NotFoundException;

  factory XkException.conflict({XkError? xkError}) = ConflictException;

  factory XkException.requestTimeout({XkError? xkError}) = RequestTimeoutException;

  factory XkException.internalServerError({XkError? xkError}) = InternalServerErrorException;

  factory XkException.serviceUnavailable({XkError? xkError}) = ServiceUnavailableException;

  factory XkException.unknownError({XkError? xkError}) = UnknownErrorException;

  factory XkException.unstableNetwork({XkError? xkError}) = UnstableNetworkException;

}
