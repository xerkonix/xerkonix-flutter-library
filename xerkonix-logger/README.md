# xerkonix_logger

Flutter 애플리케이션용 로깅 패키지. 레벨별 로그(log/debug/info/warning/error/exception), HTTP 요청/응답 로깅, 이모지 기반 시각 표시를 제공한다. 현재 버전은 **1.1.0**.

## 설치

```yaml
dependencies:
  xerkonix_logger: ^1.1.0
  logger: ^2.7.0
  http: ^1.6.0
```

- Dart SDK: `>=3.9.0 <4.0.0`
- Flutter: `>=3.35.0`

## 사용

```dart
import 'package:xerkonix_logger/xerkonix_logger.dart';

Logger.debug('Debugging message');
Logger.info('Information message');
Logger.warning('Warning message');
Logger.error(Error('Error occurred'));
Logger.exception(Exception('Exception occurred'));
```

### HTTP 로깅

```dart
Logger.httpRequest(httpRequest: request);
Logger.httpResponse(httpResponse: response, printHeaders: true);
Logger.multipartRequest(multipartRequest: request);
```

### 기타

```dart
Logger.build('build start\nbuilding...\nbuild done');   // 빌드 과정 로깅

FunLogger.heart('...');   // 부가 로거 (heart / robot / poop)
```

## 라이선스

Apache License 2.0. `LICENSE` 참고.
