# xerkonix_logger

A feature-rich logging package for Flutter applications with multiple log levels (log, debug, info, warning, error, exception), emoji-based visual indicators, and fun logger support. Integrates seamlessly with HTTP requests and provides structured logging capabilities.

## Features

- 🪵 Simple and intuitive logging API
- 💬 Multiple log levels (log, debug, info, warning, error, exception)
- 🎨 Emoji-enhanced log messages for better readability
- 🌐 HTTP request/response logging support
- 🏗️ Build process logging
- ❤️ Fun logger options (heart, robot, poop)

## Version

**Current version: v1.0.1**

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  xerkonix_logger: ^1.0.1
  logger: ^2.4.0
  http: ^1.2.2
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Logging

```dart
import 'package:xerkonix_logger/xerkonix_logger.dart';

// Default logger
Logger("Default Logger");

// Debug logging
Logger.debug("Debugging message");

// Info logging
Logger.info("Information message");

// Warning logging
Logger.warning("Warning message");

// Error logging
Logger.error(Error("Error occurred"));

// Exception logging
Logger.exception(Exception("Exception occurred"));
```

### HTTP Request/Response Logging

```dart
import 'package:http/http.dart' as http;

// Log HTTP request
http.Request request = http.Request("GET", Uri.parse("https://api.example.com"));
Logger.httpRequest(httpRequest: request);

// Log HTTP response
http.Response response = await http.get(Uri.parse("https://api.example.com"));
Logger.httpResponse(httpResponse: response);

// Log HTTP response with headers
Logger.httpResponse(httpResponse: response, printHeaders: true);
```

### Multipart Request Logging

```dart
var request = http.MultipartRequest('POST', Uri.parse('https://api.example.com'));
Logger.multipartRequest(multipartRequest: request);
```

### Fun Loggers

```dart
FunLogger.heart("I Love You.");
FunLogger.robot("Robot message");
FunLogger.poop("Shit Code");
```

### Build Process Logging

```dart
Logger.build("build start\nbuilding...\nbuild done");
```

## Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`
- logger: `^2.4.0`
- http: `^1.2.2`

## Additional Information

- Version: v1.0.1
- License: Apache License, Version 2.0 (see [LICENSE](LICENSE) file)
