
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';


class CustomException implements XkException {
  CustomException(this.xkError) {
    printExceptionLog(this);
  }

  @override
  XkError xkError;

  @override
  String toString() {
    return "Custom Exception: ${xkError.message}";
  }

  @override
  void printExceptionLog(Exception xkException) {
    Logger.exception(xkException);
  }

  @override
  String printErrorLog(){
    return "[${xkError.runtimeType}Exception]}\n${xkError.toString()}";
  }
}