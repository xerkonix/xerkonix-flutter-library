# xerkonix_error_handler

A comprehensive error and exception handling package for Flutter applications. Provides structured error types, custom exceptions, error message handlers, and UI components (dialogs, toasts) for consistent error management across applications.

## Features

- 🎯 Simple and intuitive API for error handling
- 🔧 Customizable error dialogs and toast messages
- 📱 Full platform support (Web, iOS, Android, Linux, macOS, Windows)
- 🚀 Perfect compatibility with Flutter 3.24+
- 🎨 Support for various error types (Bad Request, Unauthorized, Forbidden, Not Found, Conflict, etc.)
- 📝 Structured error definitions with code, type, message, title, and detail
- 🔗 Integration with xerkonix_logger for error logging

## Version

**Current version: v1.0.0**

## Getting Started

### Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  xerkonix_error_handler: ^1.0.0
  xerkonix_logger: ^1.0.0
```

Then install the package:

```bash
flutter pub get
```

## Usage

### Basic Error Handling

```dart
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

try {
  // Code that may throw an error
  throw XkException(XkErrors.conflict());
} on XkException catch (e) {
  XkErrorMessageHandler.setErrorMessage(
    title: e.error.title,
    detail: e.error.detail,
  );
  XkErrorMessageHandler.showError(
    context: context,
    widgetType: WidgetType.dialog,
  );
}
```

### Using Predefined Error Types

```dart
// Bad Request (400)
throw XkException(XkErrors.badRequest());

// Unauthorized (401)
throw XkException(XkErrors.unauthorized());

// Forbidden (403)
throw XkException(XkErrors.forbidden());

// Not Found (404)
throw XkException(XkErrors.notFound());

// Conflict (409)
throw XkException(XkErrors.conflict());

// Internal Server Error (500)
throw XkException(XkErrors.internalServerError());
```

### Custom Error

```dart
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

// Use custom error
throw XkException(CustomError("Something went wrong"));
```

### Custom Error Dialog

```dart
XkErrorMessageHandler.showError(
  context: context,
  widgetType: WidgetType.dialog,
  customErrorDialog: AlertDialog(
    title: Text('Custom Error'),
    content: Text('Error message'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK'),
      ),
    ],
  ),
);
```

### Error Toast

```dart
XkErrorMessageHandler.showError(
  context: context,
  widgetType: WidgetType.snackbar,
);
```

## Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`
- xerkonix_logger: `^1.0.0`

## Important Notes

### Default Logging and Error Message Handling

When you create an `XkException`, default behaviors are automatically applied:

1. **Default Error Logging**: If you don't manually call logging methods, the error is automatically logged using `xerkonix_logger` by default
2. **Default Exception Logging**: The exception stack trace is automatically logged by default
3. **Default Error Message Setting**: The error message is automatically set in `XkErrorMessageHandler` by default for UI display

This means you don't need to manually call logging or error message handling methods. Simply creating an `XkException` will apply all default behaviors:

```dart
// Creating an exception applies default logging and error message handling
throw XkException(XkErrors.badRequest());

// No need to manually call:
// - Logger.error(...)
// - XkErrorMessageHandler.setErrorMessage(...)
```

This default behavior provides convenience for package users by ensuring consistent error handling and logging without requiring additional boilerplate code.

## Additional Information

- Version: v1.0.0
- License: Apache License, Version 2.0 (see [LICENSE](LICENSE) file)
