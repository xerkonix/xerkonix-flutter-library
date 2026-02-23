# xerkonix_design_system

Flutter design system package for XERKONIX Weave.

이 패키지는 Weave HTML 레퍼런스 기준으로 아래를 제공합니다.

- 토큰: color, typography, shape/layout, motion timing
- 아이콘: 48개 아이콘 셋
- 컴포넌트: button, chip, card, form, alert, table
- 패턴 위젯: KPI, meter, timeline, monitor, radar, matrix, flow, domain tabs
- 모션 위젯: Status Breath, Signal Sweep, Wave Drift, Focus Ripple, Card Settle, Alert Beat

기본값은 회사 토큰을 사용하고, 필요한 경우 속성으로 반지름/패딩/색/크기 등을 오버라이드할 수 있습니다.

## Version

Current version: **1.1.0**

## Installation

```yaml
dependencies:
  xerkonix_design_system: ^1.1.0
```

Requirements:

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## Quick Start

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

## Typography

기본 폰트 정책:

- 기본(UI 본문/제목): `IBM Plex Sans KR`
- 메타/코드형 텍스트: `IBM Plex Mono`

```dart
Text('Display', style: XkTypo.display);
Text('Heading', style: XkTypo.h2);
Text('Body', style: XkTypo.body);
Text('Label', style: XkTypo.label);
Text('Meta', style: XkTypo.metaMono);
```

## Shape And Layout Tokens

```dart
Container(
  padding: const EdgeInsets.all(XkLayout.spacingMd),
  decoration: BoxDecoration(
    borderRadius: XkShape.mdBorderRadius,
  ),
)
```

주요 토큰:

- 반지름: `radiusXs`, `radiusSm`, `radiusMd`, `radiusLg`, `radiusXl`, `radiusFull`
- 간격: `spacingXxs`, `spacingXs`, `spacingSm`, `spacingMd`, `spacingLg`, `spacingXl`, `spacing2xl`

## Iconography

`XkIconName`에 HTML 레퍼런스 아이콘 48개가 포함되어 있습니다.

```dart
const XkIcon(XkIconName.chevRight);
const XkIcon(XkIconName.alert, size: XkIconSize.large);
```

아이콘 옵션:

- `size`: `XkIconSize.inline/small/regular/large/display/hero`
- `color`
- `strokeWidth`
- `semanticLabel`

## Components

### Button

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

Semantic variant:

```dart
XkButton.success(onPressed: () {}, child: const Text('Success'));
XkButton.warning(onPressed: () {}, child: const Text('Warning'));
XkButton.error(onPressed: () {}, child: const Text('Error'));
XkButton.info(onPressed: () {}, child: const Text('Info'));
```

### Chip

```dart
const XkChip(label: 'default', variant: XkChipVariant.neutral);
const XkChip(label: 'trusted', variant: XkChipVariant.brand);
const XkChip(label: 'attention', variant: XkChipVariant.accent);
const XkChip(label: 'urgent', variant: XkChipVariant.signal);
```

커스터마이징 예시:

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

### Info Card

```dart
const XkInfoCard(
  metric: 'Metric Card',
  title: 'Primary Value',
  description: '핵심 수치 카드',
)
```

커스터마이징 예시:

```dart
XkInfoCard(
  metric: 'Status Card',
  title: 'State Delta',
  description: '상태 변화 카드',
  borderRadius: BorderRadius.circular(18),
  padding: const EdgeInsets.all(20),
  backgroundColor: XkColor.surfaceSoft,
)
```

### Form Fields

```dart
XkTextInputField(
  label: 'Company',
  hintText: '예: 주식회사 제르코닉스',
  helperText: '법인명 기준 입력',
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
  hintText: '핵심 의사결정 질문을 입력하세요.',
  maxLines: 4,
)
```

각 필드 공통 옵션:

- `borderRadius`
- `contentPadding`
- `enabled`

### Alert

```dart
const XkAlert(
  title: '분석 완료',
  message: '핵심 지표와 권장 액션 2건이 생성되었습니다.',
  variant: XkAlertVariant.success,
)
```

variant:

- `XkAlertVariant.success`
- `XkAlertVariant.info`
- `XkAlertVariant.warning`
- `XkAlertVariant.danger`

### Table

```dart
XkTable(
  columns: const ['Metric', 'Current', 'Baseline', 'Delta', 'Action'],
  rows: const [
    XkTableRowData([
      XkTableCell(text: 'Primary Score'),
      XkTableCell(text: '94.2'),
      XkTableCell(text: '88.7'),
      XkTableCell(text: '+5.5', textColor: XkColor.success),
      XkTableCell(text: '우선순위 유지'),
    ]),
  ],
)
```

## Pattern Widgets

### KPI Card

```dart
const XkKpiCard(label: '신뢰도', value: '92', suffix: '%', delta: '평균 90% 이상 유지');
```

### Confidence Meter

```dart
const XkConfidenceMeter(
  label: '역할 적합도 신뢰도',
  value: 0.94,
  valueText: '94%',
  startColor: XkColor.identity,
  endColor: XkColor.identitySoft,
)
```

### Signal Timeline

```dart
const XkSignalTimeline(
  items: [
    XkTimelineItem(
      time: '2026-01-14 09:23',
      title: '이탈 위험 급상승',
      description: '참여율 42% 하락, 3주 내 이탈 확률 78%',
      color: XkColor.error,
    ),
  ],
)
```

### Signal Overview Monitor

```dart
const XkSignalOverviewMonitor(
  height: 220,
  animate: true,
)
```

옵션:

- `height`
- `animate`
- `duration`
- `borderRadius`
- `backgroundColor`
- `borderColor`

### Hexagon Radar

```dart
const XkHexagonRadar(
  values: [0.86, 0.78, 0.71, 0.84, 0.69, 0.76],
)
```

### Cluster Matrix

```dart
const XkClusterMatrix(
  columns: 6,
  cellSize: 24,
  gap: 6,
)
```

### Flow Compression

```dart
const XkFlowCompression(
  values: [0.92, 0.76, 0.58, 0.40, 0.24],
)
```

### Domain Tabs

```dart
const XkDomainPatternTabs();
```

커스텀 레이어 전달 예시:

```dart
const XkDomainPatternTabs(
  layers: [
    XkDomainLayer(
      key: 'input',
      title: 'Input Pattern',
      phase: 'Capture',
      description: '입력 신호 정규화',
      metrics: [
        MapEntry('Input channels', '12'),
        MapEntry('Schema match', '98%'),
      ],
    ),
  ],
)
```

## Motion

HTML 모션 6종 공개 위젯:

```dart
const XkStatusBreath();
const XkSignalSweep();
const XkWaveDrift();
const XkFocusRipple();
const XkCardSettle();
const XkAlertBeat();
```

옵션 예시:

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

기존 래퍼 API도 유지:

```dart
XkMotion.breathingLight(child: const Icon(Icons.bolt));
XkMotion.pulse(child: const Icon(Icons.notifications));
```

모든 모션 위젯은 기본적으로 `reduce motion` 접근성 설정을 존중합니다.

## Example

`example/lib/main.dart`에서 아래 섹션을 한 화면에서 확인할 수 있습니다.

- Iconography
- Components
- Pattern
- Motion

웹 실행:

```bash
cd xerkonix-design-system/example
flutter run -d web-server --web-port=18080
```

## License

Apache License 2.0. See `LICENSE`.
