# xerkonix_http

Flutter 애플리케이션용 HTTP 클라이언트 패키지. 전 HTTP 메서드(GET/POST/PUT/DELETE/PATCH/MULTIPART/CUSTOM)를 지원하며, `xerkonix_error_handler` 로 자동 에러 파싱, `xerkonix_logger` 로 요청/응답 로깅이 통합돼 있다. 현재 버전은 **1.1.0**.

## 설치

```yaml
dependencies:
  xerkonix_http: ^1.1.0
  xerkonix_error_handler: ^1.1.0
  xerkonix_logger: ^1.1.0
  http: ^1.2.2
```

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## 사용

```dart
import 'package:xerkonix_http/xerkonix_http.dart';

final XkHttp http = XkHttpUtils.generateHttp(
  scheme: 'https',
  host: 'api.example.com',
  port: 443,
);

// GET (+ 쿼리/헤더/토큰)
await http.client.get(path: '/posts', queryParameters: {'page': '1'});
await http.client.get(path: '/posts/1', token: 'your-auth-token');

// POST / PUT / PATCH / DELETE
await http.client.post(path: '/posts', body: {'title': 'New'});

// Custom / Multipart
await http.client.custom(uriAddress: '...', method: 'GET');
await http.client.multipart(uriAddress: '...', method: 'POST', file: file);
```

### 설정

```dart
final http = XkHttpUtils.generateHttp(
  host: 'api.example.com',
  contentType: 'application/json',
  tokenType: 'Bearer ',
  jsonDecodingOption: JsonDecodingOption.utf8,   // 또는 noOption
  enableLogging: false,                          // null(기본) → kDebugMode 따름
);

// 타임아웃 커스터마이즈 (기본 20초)
final client = XkHttpClient(
  httpConfig: XkHttpConfig(
    host: 'api.example.com',
    networkTimeLimit: const Duration(seconds: 30),
  ),
);
```

## 에러 처리

HTTP 에러는 `XkException` 으로 자동 변환된다: 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 408 Request Timeout, 409 Conflict, 422 Unprocessable Entity, 500 Internal Server Error, 503 Service Unavailable.

## 로깅

요청/응답 로깅은 `xerkonix_logger` 가 처리한다. `enableLogging` 이 `null`(기본)이면 `kDebugMode` 를 따라, 디버그 빌드에서만 활성화된다. 릴리스 빌드에서는 토큰·헤더·바디 등 민감 정보가 로깅되지 않는다. `enableLogging: true/false` 로 명시 제어 가능.

## 라이선스

Apache License 2.0. `LICENSE` 참고.
