# TACTILE v4.0.0 이관 — xerkonix-flutter-library

리포: Flutter 공개 패키지 모노레포. UI 이관 대상은 `xerkonix-design-system` 한 패키지. 제품 앱은 이 패키지에 런타임 의존하지 않는다.

## 0. 전수조사

| 항목 | 수량 · 위치 | 비고 |
|---|---|---|
| 스타일 소스 | Dart 토큰·테마·컴포넌트 (`xerkonix-design-system/lib`) | CSS 소비 표면 없음. 미러는 `test/fixtures/tokens.css` 한 곳 |
| `tokens.css` 미러 | `xerkonix-design-system/test/fixtures/tokens.css` | `tools/mirrors.json` 목록. 정본과 `cmp` 바이트 동일 |
| `--x-` | 0건 (테스트가 "정본에 `--x-` 없다"를 검사) | 게이트 스크립트 사본은 예외 |
| Dart `Color(0x…)` | 토큰 미러 `lib/src/palette/color.dart` 만 | 컴포넌트·테마는 `XkColor.*` |
| `Colors.white/black/grey` | 0건 (`lib/`) | `XkColor.mixWhite` / `XkColor.none` |
| `FontWeight.w700+` | 0건 (`lib/`) | `bold` 별칭도 w600 |
| `BorderRadius` 980/999 | 0건. `XkShape.radiusFull` 별칭 = `XkRadius.ctl` (12) | |
| `CircularProgressIndicator` | 0건 (`lib/`) | `XkLoader` LTR 바 |
| JS 클래스 의존 | 없음 | Flutter 패키지 |
| 테스트 | `cd xerkonix-design-system && flutter analyze && flutter test` | |

## 1. 변경 파일

### ① 계약 사본 · 게이트
- `xerkonix-design-system/test/fixtures/tokens.css` — v4.0.0 정본 바이트 사본
- `tools/tactile_gate.py` — 정본 바이트 사본 (`EXPECT_VERSION = v4.0.0`)
- `tools/tactile_gate.json` — `expect_version: v4.0.0`, `runtime_vars: []`, `aqua_fill_allow: []`

### ② 전역 토큰 · 타이포 · 테마
- `lib/src/palette/color.dart` — v4 이름 (`canvas groundHi ink ink2 ink3 rule aqua* glass* spec insetBg headGlass`) + v3 `@Deprecated` 별칭
- `lib/src/shape/xerkonix_shape.dart` — `XkRadius.panel/card/inset/ctl/tag` = 16/14/12/12/6, `--glass-shadow` `List<BoxShadow>`, v3 `sm/md/lg/pill` 별칭
- `lib/src/motion/xerkonix_motion.dart` — `state` .9s · `hover` .25s · `easeOut`/`easeSweep`, 로더 LTR 바, pulse 루프 제거
- `lib/src/typography/typo_constants.dart` · `xerkonix_typography.dart` — Pretendard only, `XkFontSize.label` 11, 굵기 ≤600, 헤드라인 500
- `lib/src/themes/*` — 캔버스 바탕, 헤더 투명+`--rule` 헤어라인, 포커스 `--aqua` 2px, 스위치/체크 켜짐 `--aqua-mid`

### ③ 컴포넌트
- `lib/src/components/xerkonix_glass.dart` — `XkGround` `XkGlass` `XkInset` `XkSelected` `XkTag` `XkGemSweep` `XkInsetShadowPainter`
- 버튼(원석+단방향 sweep) · 칩/배지(태그 6px) · 카드/뉴모픽(글래스) · 입력(글래스+rule 링) · 로더/스켈레톤 · 알림(좌측 스트라이프 제거) · 표/토스트/상태 페인
- `lib/src/pattern/xerkonix_pattern.dart` — 잉크 단계 + 아쿠아 1포인트, 무한 차트 루프 제거
- `example/lib/main.dart` — v4 토큰 이름
- 테스트: `token_canon_parity_test.dart` v4 이름, `xerkonix_design_system_test.dart`, `xerkonix_reduced_motion_test.dart`

### ④ 보고서
- 이 파일

## 2. 매핑 표 (v3 → v4)

| v3 | v4 |
|---|---|
| `--x-bg` `XkColor.bg` | `--canvas` `XkColor.canvas` |
| `--x-panel` `XkColor.panel` | `--ground-hi` `XkColor.groundHi` |
| `--x-ink` / `--x-muted` / `--x-hair` | `--ink` / `--ink-2` / `--rule` |
| `--x-tint*` | `--aqua-100` … `--aqua-ink` |
| `--x-r-lg/md` 28/18 · `--x-pill` 980 | `--r-panel` 16 · `--r-ctl` 12 · `--r-tag` 6 |
| `--x-t1/t2` 180/260ms · `--x-t3` 320ms | `--t-hover` 250ms · `--t-state` 900ms |
| 뉴모픽 2겹 그림자 | `--glass-shadow` + BackdropFilter 글래스 |
| 솔리드 잉크 CTA | `.gem-ctl` 135° `aquaHi→aqua→aquaMid` + 6s 단방향 sweep |
| `CircularProgressIndicator` | `.x-loader` `--rule` 트랙 위 `--aqua-mid` 바 1.4s LTR |
| 알약 칩 | `.tag` 11px · 6px · `--rule` |

v3 심볼 `XkColor.bg/panel/tintFill/…`, `XkRadius.sm/md/lg/pill`, `XkMotion.observe/resolve/settle` 는 `@Deprecated` 별칭으로 남겨 앱 컴파일이 깨지지 않게 했다. 값은 v4.

## 3. 제거한 장식

| 무엇 | 사유 |
|---|---|
| 뉴모픽 음수 오프셋 하이라이트 | 금지. 글래스 좌상단 specular + 1px inset 으로 대체 |
| 무한 pulse / breathing / ripple / 회전 로더 | 금지. gem sweep 만 단방향. 로더는 LTR 바 |
| 칩 컬러 점 · 알약 980 | 태그 아웃라인 |
| 알림 좌측 8px 액센트 바 | 헤어라인 + 시맨틱 잉크 글리프 |
| 아바타 다색 그라디언트 | inset + `--ink-2` 이니셜 |
| 스켈레톤 fade pulse | 정지 inset 블록 |
| `XkMetricTimeline` `repeat()` | 한 번 `forward()` |

## 4. 재작업 목록

- 패키지에 이미지·일러스트·3D 없음.
- `Pretendard-Bold.otf` (weight 700) 는 pubspec 에 남아 있다. 코드는 ≤600만 쓴다. 자산 삭제는 다음 메이저.
- 예제 푸터 문구 `Design System 4.1 · TACTILE 3.1` 은 카피 불변으로 그대로.

## 5. 남은 이슈

- `XkColor.themed` 는 Color 값 동등 비교라 v4에서 hex 가 겹치는 쌍(`ink2`↔`darkInk3`, `aquaDeep`↔`darkAquaShade`, `aquaHi`↔`darkAquaDeep`)을 구분하지 못한다. 새 코드는 `XkColor.ink2Of(brightness)` 를 쓴다.
- 화면당 아쿠아 예산(주 액션 1 + 선택 1)은 라이브러리가 위젯을 제공할 뿐, 소비 앱이 지켜야 한다. `XkButton.primary/action/accent/point` 가 모두 gem 이라 한 화면에 여러 개를 놓으면 초과한다.
- `flutter build web --release` · `shoot.js` 스크린샷 · 아쿠아 카운트는 이 세션에서 실행하지 않았다.
- 다른 패키지(`xerkonix-error-handler` 등) 예제 HTML 은 게이트가 "자체 스케일"로 통과. 디자인 시스템 위젯을 아직 v4 재질로 다시 그리지 않았다(이 워커 범위 밖).

## 6. 실행한 검사

```
cmp xerkonix-tactile-design/tokens.css \
    xerkonix-design-system/test/fixtures/tokens.css
# identical

python3 tools/tactile_gate.py --selftest   # selftest OK
python3 tools/tactile_gate.py --verbose    # 통과 — TACTILE 파리티 이상 없음

cd xerkonix-design-system
flutter analyze   # No issues found
flutter test      # 00:00 +61: All tests passed
```

파리티: `token_canon_parity_test.dart` 가 `--canvas/--ink/--aqua-* /--glass-* /--r-* /--sp-* /--fs-* /--t-state/--t-hover` 를 정본 CSS 와 대조. 커버리지 테스트가 라이트 블록의 모든 변수를 mirrored 또는 notMirrored 에 적게 한다. `--x-` 0건.

## 7. 배포 메모

- 브랜치: `main`. 푸시하지 않음(오케스트레이터).
- PR 불필요(직푸시 가능 리포).
- 패키지 버전은 4.1.0 유지(게시 별도).
- 캐시버스터: Flutter 패키지라 `?v=` 없음.
- 워치패턴: 없음.
