import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

class CustomError implements XkError {
  CustomError(this.message);

  @override
  String? code;

  @override
  String? type;

  @override
  String message;

  @override
  String title = "Custom Error Title";

  @override
  String? detail = "Custom Error Message";

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
