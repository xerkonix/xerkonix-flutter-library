import 'package:flutter/material.dart';

import '../component/error_dialog.dart';
import '../component/error_toast.dart';
import '../constant/constant.dart';
import '../error/xerkonix_error.dart';
import 'xerkonix_message.dart';

/// Legacy static, single-slot error-message handler.
///
/// Deprecated in 1.1.0 in favour of the instance-based [XkMessageRegistry]
/// (`code`-keyed, per-lookup) — a single global mutable slot loses errors when
/// two arrive close together and cannot carry per-tenant tables. Kept working
/// unchanged for existing callers; the previously-dead `toast`/`snackBar`
/// [WidgetType] branches are now implemented.
@Deprecated(
  'Use XkMessageRegistry (instance/per-lookup) instead of the global single-slot '
  'handler. Retained for backwards compatibility.',
)
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
    final XkErrorMessage message = _errorMessage ??
        XkErrorMessage(
          title: "Unknown Error",
          detail: "Unknown Error Occurred. Please try again later.",
        );
    switch (widgetType) {
      case WidgetType.toast:
        showXkToast(context, message.detail);
        return;

      case WidgetType.snackBar:
        showXkSnackBar(context, message.detail);
        return;

      case WidgetType.dialog:
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return customErrorDialog ??
                XkErrorDialog(context: context, errorMessage: message);
          },
        );
        return;
    }
  }

  static void flushErrorMessage() {
    _errorMessage = null;
  }
}
