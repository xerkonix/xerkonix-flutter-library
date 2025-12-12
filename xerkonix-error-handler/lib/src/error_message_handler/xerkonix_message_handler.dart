import 'package:flutter/material.dart';

import '../component/error_dialog.dart';
import '../constant/constant.dart';
import '../error/xerkonix_error.dart';
import 'xerkonix_message.dart';

class XkErrorMessageHandler {
  static XkErrorMessage? _errorMessage;

  XkErrorMessageHandler._();

  static bool checkErrorMessageExist() => _errorMessage != null ? true : false;

  static void setErrorMessage({required XkError xkError}) {
    _errorMessage =
        XkErrorMessage(title: xkError.title ?? 'Error', detail: xkError.detail ?? 'An error occurred');
  }

  static XkErrorMessage getErrorMessage() {
    if (checkErrorMessageExist()) {
      return _errorMessage!;
    } else {
      return XkErrorMessage(title: '', detail: '');
    }
  }

  static void showError(
      {required BuildContext context, required WidgetType widgetType, Widget? customErrorDialog}) {
    switch (widgetType) {
      case WidgetType.dialog:
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return customErrorDialog ??
                XkErrorDialog(
                  context: context,
                  errorMessage: _errorMessage ??
                      XkErrorMessage(
                          title: "Unknown Error",
                          detail: "Unknown Error Occurred. Please try again later."),
                );
          },
        );
        return;

      default:
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return XkErrorDialog(
                context: context,
                errorMessage: _errorMessage ??
                    XkErrorMessage(title: "Unknown Error",
                        detail: "Unknown Error Occurred. Please try again later."));
          },
        );
        return;
    }
  }

  static void flushErrorMessage() {
    _errorMessage = null;
  }
}
