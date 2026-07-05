# xerkonix_error_handler

Flutter 애플리케이션용 에러/예외 처리 패키지. 구조화된 에러 타입, 커스텀 예외, 메시지 핸들러, 그리고 다이얼로그/토스트 UI 컴포넌트를 제공한다. 현재 버전은 **1.1.0**.

## 설치

```yaml
dependencies:
  xerkonix_error_handler: ^1.1.0
  xerkonix_logger: ^1.1.0
```

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`
- 의존: `xerkonix_logger`

## 사용

`XkException` 을 던지면 기본 동작이 자동 적용된다 — `xerkonix_logger` 로 에러/스택트레이스 로깅, `XkErrorMessageHandler` 에 메시지 설정. 별도 boilerplate 없이 일관된 처리가 이루어진다.

```dart
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

try {
  throw XkException(XkErrors.conflict());
} on XkException catch (e) {
  XkErrorMessageHandler.showError(
    context: context,
    widgetType: WidgetType.dialog,   // 또는 WidgetType.snackbar
  );
}
```

### 사전 정의 에러 (`XkErrors`)

`badRequest()`(400), `unauthorized()`(401), `forbidden()`(403), `notFound()`(404), `conflict()`(409), `internalServerError()`(500) 등.

### 커스텀 에러

`XkError` 를 구현해 `code`/`type`/`message`/`title`/`detail`/`stackTrace` 를 채운 뒤 `XkException` 으로 감싼다.

```dart
class CustomError implements XkError { /* ... */ }
throw XkException(CustomError('Something went wrong'));
```

### 커스텀 UI

`XkErrorMessageHandler.showError(..., customErrorDialog: ...)` 로 다이얼로그를 직접 지정할 수 있다.

## 공개 API

에러: `XkError`, `XkErrors`, `XkErrorCodes`, `XkErrorFactory`, `XkErrorNormalizer`. 예외: `XkException`, `XkExceptionFactory`. 메시지: `XkErrorMessageHandler`, 메시지 레지스트리·훅. UI: `error_dialog`, `error_toast`.

## 라이선스

Apache License 2.0. `LICENSE` 참고.
