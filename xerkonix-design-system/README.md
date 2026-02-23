# xerkonix_design_system

Flutter design system package for XERKONIX Weave.

## English

### Overview

`xerkonix_design_system` provides production-ready Weave UI foundations for Flutter:

- Tokens: color, typography, shape/layout, motion timing
- Icons: 48 stroke icon widgets from the Weave HTML reference
- Components: button, chip, card, form, alert, table
- Pattern widgets: KPI, meter, timeline, monitor, radar, matrix, flow, domain tabs
- Motion widgets: Status Breath, Signal Sweep, Wave Drift, Focus Ripple, Card Settle, Alert Beat

Defaults use company tokens, and each widget allows selective overrides (radius, padding, color, size, timing, and more) when needed.

### Version

Current version: **1.1.1**

### Installation

```yaml
dependencies:
  xerkonix_design_system: ^1.1.1
```

Requirements:

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

### Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: XkLightTheme.themeData,
      darkTheme: XkDarkTheme.themeData,
      home: const Scaffold(
        body: Center(
          child: Text('Weave', style: TextStyle(color: XkColor.text)),
        ),
      ),
    );
  }
}
```

### Typography

Font policy:

- Primary UI text: `IBM Plex Sans KR`
- Meta/monospace text: `IBM Plex Mono`

Both font families are bundled in this package and loaded automatically when the package is added.

```dart
Text('Display', style: XkTypo.display);
Text('Heading', style: XkTypo.h2);
Text('Body', style: XkTypo.body);
Text('Label', style: XkTypo.label);
Text('Meta', style: XkTypo.metaMono);
```

### Shape And Layout Tokens

```dart
Container(
  padding: const EdgeInsets.all(XkLayout.spacingMd),
  decoration: BoxDecoration(
    borderRadius: XkShape.mdBorderRadius,
  ),
)
```

Main token groups:

- Radius: `radiusXs`, `radiusSm`, `radiusMd`, `radiusLg`, `radiusXl`, `radiusFull`
- Spacing: `spacingXxs`, `spacingXs`, `spacingSm`, `spacingMd`, `spacingLg`, `spacingXl`, `spacing2xl`

### Iconography

`XkIconName` contains 48 icons from the Weave HTML reference.

```dart
const XkIcon(XkIconName.chevRight);
const XkIcon(XkIconName.alert, size: XkIconSize.large);
```

Icon options:

- `size`: `XkIconSize.inline/small/regular/large/display/hero`
- `color`
- `strokeWidth`
- `semanticLabel`

### Components

#### Button

```dart
Wrap(
  spacing: 8,
  children: [
    XkButton.primary(onPressed: () {}, child: const Text('Primary')),
    XkButton.brand(onPressed: () {}, child: const Text('Brand')),
    XkButton.accent(onPressed: () {}, child: const Text('Accent')),
    XkButton.tonal(onPressed: () {}, child: const Text('Tonal')),
    XkButton.outline(onPressed: () {}, child: const Text('Outline')),
  ],
)
```

Semantic variants:

```dart
XkButton.success(onPressed: () {}, child: const Text('Success'));
XkButton.warning(onPressed: () {}, child: const Text('Warning'));
XkButton.error(onPressed: () {}, child: const Text('Error'));
XkButton.info(onPressed: () {}, child: const Text('Info'));
```

#### Chip

```dart
const XkChip(label: 'default', variant: XkChipVariant.neutral);
const XkChip(label: 'trusted', variant: XkChipVariant.brand);
const XkChip(label: 'attention', variant: XkChipVariant.accent);
const XkChip(label: 'urgent', variant: XkChipVariant.signal);
```

Customization example:

```dart
XkChip(
  label: 'custom',
  variant: XkChipVariant.brand,
  borderRadius: BorderRadius.circular(22),
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
  textColor: Colors.black,
  dotColor: Colors.black,
)
```

#### Info Card

```dart
const XkInfoCard(
  metric: 'Metric Card',
  title: 'Primary Value',
  description: 'Core metric card',
)
```

Customization example:

```dart
XkInfoCard(
  metric: 'Status Card',
  title: 'State Delta',
  description: 'State transition card',
  borderRadius: BorderRadius.circular(18),
  padding: const EdgeInsets.all(20),
  backgroundColor: XkColor.surfaceSoft,
)
```

#### Form Fields

```dart
XkTextInputField(
  label: 'Company',
  hintText: 'Example: XERKONIX Inc.',
  helperText: 'Use legal entity name',
  controller: companyController,
)

XkSelectField<String>(
  label: 'Domain',
  value: selectedDomain,
  options: const [
    XkSelectOption(value: 'Input Layer', label: 'Input Layer'),
    XkSelectOption(value: 'Pattern Layer', label: 'Pattern Layer'),
    XkSelectOption(value: 'State Layer', label: 'State Layer'),
    XkSelectOption(value: 'Action Layer', label: 'Action Layer'),
  ],
  onChanged: (value) {},
)

XkTextAreaField(
  label: 'Brief',
  hintText: 'Write your core decision question.',
  maxLines: 4,
)
```

Shared field options:

- `borderRadius`
- `contentPadding`
- `enabled`

#### Alert

```dart
const XkAlert(
  title: 'Analysis Complete',
  message: 'Two recommended actions were generated.',
  variant: XkAlertVariant.success,
)
```

Variants:

- `XkAlertVariant.success`
- `XkAlertVariant.info`
- `XkAlertVariant.warning`
- `XkAlertVariant.danger`

#### Table

```dart
XkTable(
  columns: const ['Metric', 'Current', 'Baseline', 'Delta', 'Action'],
  rows: const [
    XkTableRowData([
      XkTableCell(text: 'Primary Score'),
      XkTableCell(text: '94.2'),
      XkTableCell(text: '88.7'),
      XkTableCell(text: '+5.5', textColor: XkColor.success),
      XkTableCell(text: 'Keep priority'),
    ]),
  ],
)
```

### Pattern Widgets

#### KPI Card

```dart
const XkKpiCard(label: 'Trust', value: '92', suffix: '%', delta: 'Maintained above 90%');
```

#### Confidence Meter

```dart
const XkConfidenceMeter(
  label: 'Role-fit confidence',
  value: 0.94,
  valueText: '94%',
  startColor: XkColor.identity,
  endColor: XkColor.identitySoft,
)
```

#### Signal Timeline

```dart
const XkSignalTimeline(
  items: [
    XkTimelineItem(
      time: '2026-01-14 09:23',
      title: 'Churn risk spike',
      description: 'Participation dropped 42%, 78% churn probability within 3 weeks',
      color: XkColor.error,
    ),
  ],
)
```

#### Signal Overview Monitor

```dart
const XkSignalOverviewMonitor(
  height: 220,
  animate: true,
)
```

Options:

- `height`
- `animate`
- `duration`
- `borderRadius`
- `backgroundColor`
- `borderColor`

#### Hexagon Radar

```dart
const XkHexagonRadar(
  values: [0.86, 0.78, 0.71, 0.84, 0.69, 0.76],
)
```

#### Cluster Matrix

```dart
const XkClusterMatrix(
  columns: 6,
  cellSize: 24,
  gap: 6,
)
```

#### Flow Compression

```dart
const XkFlowCompression(
  values: [0.92, 0.76, 0.58, 0.40, 0.24],
)
```

#### Domain Tabs

```dart
const XkDomainPatternTabs();
```

Custom layer input example:

```dart
const XkDomainPatternTabs(
  layers: [
    XkDomainLayer(
      key: 'input',
      title: 'Input Pattern',
      phase: 'Capture',
      description: 'Normalize incoming signals',
      metrics: [
        MapEntry('Input channels', '12'),
        MapEntry('Schema match', '98%'),
      ],
    ),
  ],
)
```

### Motion

Six public motion widgets:

```dart
const XkStatusBreath();
const XkSignalSweep();
const XkWaveDrift();
const XkFocusRipple();
const XkCardSettle();
const XkAlertBeat();
```

Option examples:

```dart
const XkStatusBreath(
  duration: XkMotionToken.statusBreath,
  size: 18,
  color: XkColor.identity,
  minScale: 0.8,
  maxScale: 1.22,
)

const XkSignalSweep(
  width: 220,
  trackHeight: 6,
  dotSize: 12,
  color: XkColor.identity,
)
```

Legacy wrapper API is still available:

```dart
XkMotion.breathingLight(child: const Icon(Icons.bolt));
XkMotion.pulse(child: const Icon(Icons.notifications));
```

All motion widgets respect accessibility reduced-motion settings by default.

### Platform Support

You can use this package in all Flutter targets:

- iOS
- Android
- Web
- Windows
- macOS
- Linux

### Example App

You can review all implemented sections in `example/lib/main.dart`.

- Iconography
- Components
- Pattern
- Motion

Run web example:

```bash
cd xerkonix-design-system/example
flutter run -d web-server --web-port=18080
```

### License

Apache License 2.0. See `LICENSE`.

## 한국어

### 개요

`xerkonix_design_system`은 Flutter에서 바로 사용할 수 있는 XERKONIX Weave 디자인 시스템 패키지입니다.

- 토큰: 색상, 타이포그래피, 형태/레이아웃, 모션 타이밍
- 아이콘: Weave HTML 레퍼런스 기반 48개 스트로크 아이콘
- 컴포넌트: 버튼, 칩, 카드, 폼, 알림, 테이블
- 패턴 위젯: KPI, 신뢰도 미터, 타임라인, 모니터, 레이더, 매트릭스, 플로우, 도메인 탭
- 모션 위젯: Status Breath, Signal Sweep, Wave Drift, Focus Ripple, Card Settle, Alert Beat

기본값은 회사 토큰을 사용하며, 필요 시 반지름/패딩/색상/크기/시간값을 속성으로 오버라이드할 수 있습니다.

### 버전

현재 버전: **1.1.1**

### 설치

```yaml
dependencies:
  xerkonix_design_system: ^1.1.1
```

요구 사항:

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

### 빠른 시작

기본 사용 코드는 위 English 섹션의 `Quick Start`와 동일합니다.

### 타이포그래피

폰트 정책:

- 기본 UI 텍스트: `IBM Plex Sans KR`
- 메타/모노스페이스 텍스트: `IBM Plex Mono`

두 폰트 패밀리는 패키지에 포함되어 있으며, 패키지를 추가하면 자동으로 로드됩니다.

텍스트 스타일 사용 예시는 위 English 섹션 `Typography` 코드와 동일합니다.

### Shape/Layout 토큰

`XkShape`, `XkLayout`으로 반지름과 간격 토큰을 사용합니다.

- 반지름: `radiusXs`, `radiusSm`, `radiusMd`, `radiusLg`, `radiusXl`, `radiusFull`
- 간격: `spacingXxs`, `spacingXs`, `spacingSm`, `spacingMd`, `spacingLg`, `spacingXl`, `spacing2xl`

코드 예시는 위 English 섹션 `Shape And Layout Tokens`를 참고하세요.

### 아이콘

`XkIconName`에 48개 아이콘이 정의되어 있으며, `XkIcon`으로 렌더링합니다.

- 주요 옵션: `size`, `color`, `strokeWidth`, `semanticLabel`

코드 예시는 위 English 섹션 `Iconography`와 동일합니다.

### 컴포넌트

구현된 위젯:

- `XkButton` (primary/brand/accent/tonal/outline + semantic variants)
- `XkChip`
- `XkInfoCard`
- `XkTextInputField`, `XkTextAreaField`, `XkSelectField`
- `XkAlert`
- `XkTable`

상세 코드 예시는 위 English 섹션 `Components`를 참고하세요.

### 패턴 위젯

구현된 위젯:

- `XkKpiCard`
- `XkConfidenceMeter`
- `XkSignalTimeline`
- `XkSignalOverviewMonitor`
- `XkHexagonRadar`
- `XkClusterMatrix`
- `XkFlowCompression`
- `XkDomainPatternTabs`

상세 코드 예시는 위 English 섹션 `Pattern Widgets`를 참고하세요.

### 모션

공개 모션 위젯 6종:

- `XkStatusBreath`
- `XkSignalSweep`
- `XkWaveDrift`
- `XkFocusRipple`
- `XkCardSettle`
- `XkAlertBeat`

기존 래퍼 API(`XkMotion.breathingLight`, `XkMotion.pulse`)도 유지됩니다.

모든 모션 위젯은 기본적으로 접근성의 `reduce motion` 설정을 존중합니다.

상세 코드 예시는 위 English 섹션 `Motion`을 참고하세요.

### 플랫폼 지원

Flutter가 지원하는 타깃에서 동일하게 사용할 수 있습니다.

- iOS
- Android
- Web
- Windows
- macOS
- Linux

### 예제 앱

`example/lib/main.dart`에서 구현된 전체 섹션을 확인할 수 있습니다.

웹 실행:

```bash
cd xerkonix-design-system/example
flutter run -d web-server --web-port=18080
```

### 라이선스

Apache License 2.0. `LICENSE`를 확인하세요.
