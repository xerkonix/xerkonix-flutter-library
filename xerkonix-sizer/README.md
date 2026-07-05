# xerkonix_sizer

Flutter 애플리케이션용 반응형 사이징 유틸리티. 논리 픽셀(logical pixel, lp) 기반으로 화면 크기에 맞춰 크기를 계산한다. 정적/컨텍스트 기반 사이징과 safe-area 패딩 계산을 지원한다. 현재 버전은 **1.1.0**.

## 설치

```yaml
dependencies:
  xerkonix_sizer: ^1.1.0
```

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## 사용

기준 해상도를 한 번 초기화한다.

```dart
import 'package:xerkonix_sizer/xerkonix_sizer.dart';

Sizer.init(standardLogicalWidth: 420, standardLogicalHeight: 920);
```

### 정적 사이징

```dart
Container(
  width: Sizer.unitWidth.lp16,
  height: Sizer.unitHeight.lp24,
);
```

### 컨텍스트 기반 사이징

`ResponsiveSizer` 는 `BuildContext` 로 실제 화면 크기를 반영하며 safe-area 패딩을 자동 계산한다.

```dart
final sizer = ResponsiveSizer(context: context);
Container(
  width: sizer.unitWidth.lp16,
  height: sizer.unitHeight.lp24,
);
```

## 논리 픽셀 값

`lp4` 부터 `lp500` 까지 4 단위로 125개 값이 정의돼 있다(`lp4, lp8, lp12, … lp500`).

## 라이선스

Apache License 2.0. `LICENSE` 참고.
