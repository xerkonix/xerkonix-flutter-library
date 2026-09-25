## 4.6.0 — 제품 화면 버전 6-B 역할

패키지 버전 4.6.0. 웹 TACTILE 토큰은 v3.1.0 그대로다. 앱 첫인상 자리의 잉크 면·브랜드 단어·사람 확인 칸·화면 전환과 Aquamarine 읽기 역할을 `XkTactileAppSurface`로 공급한다. 아래 「제품 화면 버전 6-B」 절 참고.

## 4.5.1 — 테마별 Aquamarine · 모노크롬 주 행동

패키지 버전 4.5.1. 웹 TACTILE 토큰은 v3.1.0이다. 배경은 `#F5F5F5` / `#111111`, Aquamarine은 `#269DB0` / `#65C9D9`. `XkTactilePrimaryButton`은 모노크롬 평면 버튼이다. 제품별 소비 사본은 공식 복사 도구로 갱신한다. 패키지 게시는 별도다.

## 4.4.0 — 아쿠아 색유리 주 액션 · 라이트 캔버스 #F5F5F5

패키지 버전 4.4.0. 디자인 계약 토큰 헤더는 v3.0.0. 두 번호는 별개다. 신규 공개 API는 `XkGlassRole`과 `XkListRow.surface`. 주 액션은 `--aqua-fill` + `--aqua-on`. 검정 역상 면(`--surface-inverse`)은 섹션·푸터 역할이다.

## 4.3.0 — 무채색 베이스 · 유리 역할

패키지 버전 4.3.0. 디자인 계약 토큰 헤더와 패키지 번호는 별개다.

## 4.2.0 — TACTILE v4.1.0 얇은 평면 유리

패키지 버전 4.2.0. 디자인 계약은 TACTILE v4.1.0. 두 번호는 별개다. 패키지 게시는 별도.

## 4.1.0 — 로컬 디자인 개정

주 행동을 무채 잉크로, 본문을 16–17px로, 캡션 바닥을 13px로 맞췄습니다. 정적 카드는 평면이며 버튼은 키보드 포커스와 기본 Flutter 조작 의미를 유지합니다. `primaryGradient` 등 기존 호출 이름은 보존하지만 기본 액션은 단색으로 표시합니다. TACTILE v3.1.0 토큰·타이포 파리티를 확인합니다. 패키지 게시는 별도입니다.

# xerkonix_design_system

XERKONIX Design System 의 Flutter 구현 패키지. 색·타이포·형태·모션 토큰과 라이트/다크 테마, 아이콘, 컴포넌트, 패턴/모션 위젯을 제공한다. 패키지 버전은 **4.6.0**, 웹 TACTILE 토큰은 **v3.1.0**이다. 구형 제품 루트 `tokens.css` 헤더는 v3.0.0이며, `test/token_canon_parity_test.dart`가 그 미러를 별도로 검사한다.

`XkButton.primary` 는 테마에 맞는 모노크롬 평면 버튼이다. `XkButton.point` 는 주 CTA 가 아닌 **보조 변형**이다.

## 설치

```yaml
dependencies:
  xerkonix_design_system: ^4.6.0
```

- Dart SDK: `>=3.9.0 <4.0.0`
- Flutter: `>=3.35.0`

폰트(Pretendard / MaruBuri / IBM Plex Sans KR / IBM Plex Mono)는 패키지에 번들돼 자동 로드된다. 각 폰트의 라이선스는 아래 [라이선스](#라이선스) 절 참고.

## 빠른 시작

```dart
import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

MaterialApp(
  theme: XkLightTheme.themeData,
  darkTheme: XkDarkTheme.themeData,
  home: Scaffold(
    body: Center(
      child: Text('TACTILE', style: TextStyle(color: XkColor.textStrong)),
    ),
  ),
);
```

## 제품 화면 버전 6-B — 앱 역할

DS `DESIGN-SYSTEM.md` §11과 `flutter/APP_SURFACE_MAPPING.md`를 따른다. 이름은 그 표에 있는 것만 쓴다. 값은 `XkTactileTokens`의 같은 이름 필드이고, `tools/build_tactile_theme_roles.py --check`가 DS `tactile/app-surface.css`와 대조한다.

```dart
MaterialApp(
  theme: XkTactileTheme.themeData(Brightness.light),
  darkTheme: XkTactileTheme.themeData(Brightness.dark),
  home: Builder(builder: (BuildContext context) {
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    return XkTactileRouteFade(
      child: Column(children: <Widget>[
        XkTactileAppIntro( // 로그인·빈 상태·대시보드 머리·결제 완료에만
          child: Column(children: <Widget>[
            const XkTactileBrandWord('골든셋'), // 화면당 한 곳
            XkTactilePrimaryButton(onPressed: () {}, child: const Text('시작')),
          ]),
        ),
        Text('128', style: TextStyle(color: s.keyMetric)),
        XkTactileHumanReview(
          child: Text('확인 필요 · 금액 차이',
              style: TextStyle(color: s.humanReviewLabel)),
        ),
      ]),
    );
  }),
);
```

- 잉크 면(`XkTactileAppIntro`)은 첫인상 네 자리에만 쓴다. 폼·표·카드·결제 중간 단계는 `XkTactileSurface`(정보 면)다. 결제 완료에는 `completion: true`로 완료 빛을 한 번 둔다.
- `currentLabel`·`keyMetric`·`humanReviewLabel`·`selectedCue`는 AA 대비의 읽기 글자다. 상태는 글자로도 쓴다. 라이트 원색 `accent`를 읽는 글자·필수 경계에 쓰지 않는다.
- 선택 컨트롤은 중립(`selectedFill`·`selectedBorder`·`ink`)이다. 탭 바·내비게이션 바·레일은 테마가 그렇게 칠한다. `selectedCue`는 선택된 이름 옆의 작은 보조 글자다.
- 모션은 `XkTactileRouteFade`(180ms)와 완료 빛(1400ms, 1회)뿐이다. 감속 모드에서는 둘 다 멈춘다. 스크롤 연동·반복 모션을 넣지 않는다.

## 토큰

### 색 — `XkColor`

TACTILE 팔레트. 무채색 12단계 그레이 스케일(`gray000` … `gray950`) 위에 시맨틱 토큰을 정의한다.

- 서피스/텍스트: `bg`, `surface`, `surface2`, `border`, `borderSoft`, `textStrong`, `textBody`, `textMuted`
- 강조: `accent`(근-흑색 액션, 화면당 1개), `accentDeep`, `accentSoft`, `accentText`, 무채 baseline `brand`
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

TACTILE HTML 레퍼런스 기반 48개 스트로크 아이콘(`XkIconName`).

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

패키지 코드는 **Apache License 2.0** — `LICENSE` 참고.

번들된 폰트는 Apache 2.0 이 아니라 **각자의 라이선스**로 재배포되며, 각 라이선스
전문은 폰트 파일 옆에 함께 담겨 있다(재배포 조건). 요약은 루트 `NOTICE`.

| 폰트 | 저작권 | 라이선스 | 전문 |
|---|---|---|---|
| Noto Sans CJK KR VF | Noto CJK / Adobe Source | SIL OFL 1.1 | `lib/fonts/noto_sans_cjk_kr/OFL.txt` |

예약 이름(Reserved Font Name)은 `Pretendard` · `Plex` 다 — 이 폰트를 수정해
재배포할 때 폰트 선택 이름 필드에 예약 이름을 쓰면 안 된다.
