# xerkonix_design_system

XERKONIX TACTILE 디자인 시스템의 Flutter 구현 패키지. 색·타이포·형태·모션 토큰과 라이트/다크 테마, 아이콘, 컴포넌트, 패턴/모션 위젯을 제공한다. 현재 버전은 **2.1.1**(TACTILE v2.0 토큰 기준)이다.

## 설치

```yaml
dependencies:
  xerkonix_design_system: ^2.1.1
```

- Dart SDK: `>=3.9.0 <4.0.0`
- Flutter: `>=3.35.0`

폰트(Pretendard / MaruBuri / IBM Plex Sans KR / IBM Plex Mono)는 패키지에 번들돼 자동 로드된다.

## 빠른 시작

```dart
import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

MaterialApp(
  theme: XkLightTheme.themeData,
  darkTheme: XkDarkTheme.themeData,
  home: Scaffold(
    body: Center(
      child: Text('Weave', style: TextStyle(color: XkColor.textStrong)),
    ),
  ),
);
```

## 토큰

### 색 — `XkColor`

TACTILE v2.0 팔레트. 12단계 그레이블루 스케일(`gray000` … `gray950`) 위에 시맨틱 토큰을 정의한다.

- 서피스/텍스트: `bg`, `surface`, `surface2`, `border`, `borderSoft`, `textStrong`, `textBody`, `textMuted`
- 강조: `accent`(인디고, 화면당 1개), `accentDeep`, `accentSoft`, `accentText`, 무채 baseline `brand`
- 상태: `success`/`successSoft`, `warning`/`warningSoft`, `error`/`errorSoft`
- 다크 대응 필드는 `dark` 접두사(`darkBg`, `darkSurface`, `darkTextStrong` …)

### 타이포 — `XkTypo`

본문/UI 는 Pretendard, 28px+ 디스플레이는 MaruBuri 세리프, 데이터/메타는 IBM Plex Mono.

```dart
Text('Display', style: XkTypo.display);   // MaruBuri 세리프 (28px+)
Text('Heading', style: XkTypo.h2);
Text('Body',    style: XkTypo.body);
Text('Label',   style: XkTypo.label);
Text('Meta',    style: XkTypo.metaMono);  // IBM Plex Mono
```

기타 스타일: `h1/h3`, `bodyLarge/bodySmall`, `cardTitle/cardBody`, `buttonLabel`, `chipLabel`, `fieldLabel`, `hint`, `metricMono`, `tableHeader/tableCode`.

### 형태/레이아웃 — `XkShape`, `XkLayout`

- radius: `radiusXs/Sm/Md/Lg/Xl/Full` (+ `mdBorderRadius` 등 `BorderRadius` 헬퍼)
- spacing: `spacingXxs/Xs/Sm/Md/Lg/Xl/2xl`

### 모션 — `XkMotionToken`

`observe`(180ms) / `resolve`(260ms) / `settle`(320ms) 기반 Duration.

## 컴포넌트

```dart
XkButton.primary(onPressed: () {}, child: const Text('Primary'));
// 변형: brand, accent, tonal, outline, primaryGradient, cta,
//       success / warning / error / info

const XkChip(label: 'trusted', variant: XkChipVariant.brand);
const XkInfoCard(metric: 'Metric', title: 'Value', description: '...');
const XkAlert(title: '...', message: '...', variant: XkAlertVariant.success);

XkTextInputField(label: 'Company', controller: c);
XkSelectField<String>(label: 'Domain', value: v, options: [...], onChanged: (x) {});
XkTextAreaField(label: 'Brief', maxLines: 4);

XkTable(columns: [...], rows: [XkTableRowData([XkTableCell(text: '...')])]);
```

각 위젯은 기본값에 회사 토큰을 쓰고, `borderRadius`/`padding`/`color`/`size` 등을 선택적으로 오버라이드할 수 있다.

**v2.1 제품 프리미티브 추가**(additive, 기존 API 비파괴): `XkBrandMark`, `XkBadge`(+ `XkBadge.beta()`), `XkAvatar`, `XkCard`, `XkSkeleton`, `XkLoadingOverlay`, `XkToast`, `XkSectionLabel`, `XkBackButton`, `XkProgressBar`, `XkLoadingPane`/`XkEmptyPane`/`XkErrorPane`.

## 아이콘 — `XkIcon`

Weave HTML 레퍼런스 기반 48개 스트로크 아이콘(`XkIconName`).

```dart
const XkIcon(XkIconName.chevRight);
const XkIcon(XkIconName.alert, size: XkIconSize.large);
```

옵션: `size`(`inline/small/regular/large/display/hero`), `color`, `strokeWidth`, `semanticLabel`.

## 패턴 위젯

`XkKpiCard`, `XkConfidenceMeter`, `XkSignalTimeline`, `XkMetricTimeline`, `XkHexagonRadar`, `XkDistributionHeatmap`, `XkPriorityFunnel`, `XkDomainPatternTabs`.

## 모션 위젯

공개 6종: `XkStatusPulse`, `XkSignalSweep`, `XkRhythmLine`, `XkFocusRipple`, `XkCardSettle`, `XkAlertPulse`. 래퍼 API(`XkMotion.breathingLight`, `XkMotion.pulse`)도 유지된다. 모든 모션 위젯은 접근성 reduce-motion 설정을 기본 존중한다.

## 예제

```bash
cd example
flutter run -d web-server --web-port=18080
```

`example/lib/main.dart` 에 Iconography / Components / Pattern / Motion 섹션이 구현돼 있다.

## 라이선스

Apache License 2.0. `LICENSE` 참고.
