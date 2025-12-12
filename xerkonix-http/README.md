# xerkonix_http

A robust HTTP client package for Flutter applications with built-in error handling, logging, and request/response utilities. Supports all HTTP methods (GET, POST, PUT, DELETE, PATCH, MULTIPART, CUSTOM) with configurable logging and automatic error parsing.

## Features

- ✅ Full HTTP method support (GET, POST, PUT, DELETE, PATCH)
- ✅ Custom HTTP requests with flexible configuration
- ✅ Multipart file uploads
- ✅ Automatic error handling with `xerkonix_error_handler`
- ✅ Request/response logging with `xerkonix_logger`
- ✅ Custom headers and authentication tokens
- ✅ Query parameters support
- ✅ UTF-8 JSON decoding option
- ✅ Configurable timeout settings
- ✅ Logging control (enabled by default in debug mode, disabled in production)
- ✅ Flutter 3.24+ & Dart 3.5+ compatible

## Version

**Current version: v1.0.0**

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  xerkonix_http: ^1.0.0
  xerkonix_error_handler: ^1.0.0
  xerkonix_logger: ^1.0.0
  http: ^1.2.2
```

### Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## Usage

### Basic Setup

```dart
import 'package:xerkonix_http/xerkonix_http.dart';

// Generate HTTP client with configuration
final XkHttp http = XkHttpUtils.generateHttp(
  scheme: "https",
  host: "api.example.com",
  port: 443,
);
```

### GET Request

```dart
// Simple GET request
final response = await http.client.get(path: '/posts/1');

// GET with query parameters
final response = await http.client.get(
  path: '/posts',
  queryParameters: {
    "page": "1",
    "limit": "10"
  },
);

// GET with custom headers
final response = await http.client.get(
  path: '/posts/1',
  headerList: [
    {"X-Custom-Header": "value"}
  ],
);

// GET with authentication token
final response = await http.client.get(
  path: '/posts/1',
  token: "your-auth-token",
);
```

### POST Request

```dart
final response = await http.client.post(
  path: '/posts',
  body: {
    "title": "New Post",
    "body": "Post content",
    "userId": 1
  },
);
```

### PUT Request

```dart
final response = await http.client.put(
  path: '/posts/1',
  body: {
    "id": 1,
    "title": "Updated Post",
    "body": "Updated content",
    "userId": 1
  },
);
```

### DELETE Request

```dart
final response = await http.client.delete(
  path: '/posts/1',
  body: {},
);
```

### PATCH Request

```dart
final response = await http.client.patch(
  path: '/posts/1',
  body: {
    "title": "Patched Post"
  },
);
```

### Custom Request

```dart
final response = await http.client.custom(
  uriAddress: 'https://api.example.com/custom-endpoint',
  method: "GET",
  queryParameters: {"param": "value"},
  body: {"key": "value"},
);
```

### Multipart File Upload

```dart
import 'dart:io';

final response = await http.client.multipart(
  uriAddress: 'https://api.example.com/upload',
  method: "POST",
  file: File('/path/to/file.jpg'),
  token: "your-auth-token",
);
```

### Advanced Configuration

```dart
final XkHttp http = XkHttpUtils.generateHttp(
  scheme: "https",
  host: "api.example.com",
  port: 443,
  contentType: "application/json",
  tokenType: "Bearer ",
  jsonDecodingOption: JsonDecodingOption.utf8, // or JsonDecodingOption.noOption
  enableLogging: false, // Optional: control logging (default: kDebugMode)
);

// Custom timeout (default: 20 seconds)
final httpConfig = XkHttpConfig(
  scheme: "https",
  host: "api.example.com",
  port: 443,
  networkTimeLimit: Duration(seconds: 30),
  enableLogging: false, // Optional: control logging
);
final httpClient = XkHttpClient(httpConfig: httpConfig);
```

## Error Handling

This package integrates with `xerkonix_error_handler` for automatic error handling. HTTP errors are automatically converted to `XkException` with appropriate error types:

- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 408: Request Timeout
- 409: Conflict
- 422: Unprocessable Entity
- 500: Internal Server Error
- 503: Service Unavailable

## Logging

Request and response logging is automatically handled by `xerkonix_logger`. By default, logging is enabled only in debug mode (`kDebugMode`), which means:

- **Development/Debug builds**: Logging is automatically enabled
- **Production/Release builds**: Logging is automatically disabled for security

### Custom Logging Control

You can explicitly control logging behavior:

```dart
// Disable logging (recommended for production)
final http = XkHttpUtils.generateHttp(
  host: 'api.example.com',
  enableLogging: false,
);

// Always enable logging (for debugging)
final http = XkHttpUtils.generateHttp(
  host: 'api.example.com',
  enableLogging: true,
);

// Use default behavior (enabled in debug, disabled in release)
final http = XkHttpUtils.generateHttp(
  host: 'api.example.com',
  // enableLogging is null by default, uses kDebugMode
);
```

**Security Note**: In production builds, sensitive information (tokens, headers, request/response bodies) will not be logged by default.

## Additional Information

- Version: v1.0.0
- License: Apache License, Version 2.0 (see [LICENSE](LICENSE) file)
