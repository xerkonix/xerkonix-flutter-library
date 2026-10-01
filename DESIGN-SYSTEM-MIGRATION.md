# Design System Migration

## 2026-10-02 — 제품 화면 버전 v4 · 라이트 고정 · 잉크 면 폐기 (패키지 4.7.0)

- 전후: 앱 첫인상 자리(로그인·빈 상태·대시보드 머리·결제 완료)가 잉크 면에서 다른 카드와 같은 밝은 정보 면으로 돌아간다. 브랜드 단어 그라데이션·완료 빛은 없다. 검정 면은 강조 다크 구간 두 곳(coSchema 캔버스 집중 패널·푸터)뿐이고 그 안에서만 다크 토큰을 읽는다. 제품 화면은 라이트 고정이라 `darkTheme`·테마 전환을 두지 않는다.
- 변경: `XkTactileAppIntro`·`XkTactileBrandWord`·완료 빛과 잉크 면 역할 11개 삭제, `XkTactileEmphasisDark(kind: canvasFocus|footer)` 추가, 버튼의 잉크 면 분기 제거, 생성기 `build_tactile_theme_roles.py`를 DS v4.1 `app-surface.css`(다크 범위 `.app-surface[data-theme="dark"]`, `emphasisDark` 절, `routeFade`만)에 맞춤, `tactile_theme_roles.json`·`test/fixtures/tokens.css`(DS v4.1) 재생성. 새 토큰·새 hex는 없다.
- 소비처: coTact·Concierge·frontend-boilerplate는 `sync_tactile_dart.py --write`로 사본을 받는다(파일 목록은 11개 그대로). 앱 쪽 `AppIntro`·`appIntro*` getter·테마 전환 제거는 각 소비 리포 PR에서 한다.
- 검사: `flutter analyze` 이상 없음 · `flutter test` 145 통과 · 예제 릴리스 웹 빌드 통과 · `build_tactile_theme_roles.py --check`·`sync_tactile_dart.py --selftest`·`tactile_gate.py` 통과 · DS `sync_consumers.py --check --consumer xerkonix-flutter-library` 차이 0.
- 상태: 라이브러리 PR이다. 앱 반영과 라이브 확인은 소비처 PR에서 한다. 패키지 게시는 별도다.

## 2026-10-02 — CanvasKit 글꼴 XK Sans KR (Pretendard KS X 1001 서브셋, 패키지 4.7.0 에 포함)

- 전후: Flutter 웹 면의 글꼴이 엔진 기본(원격 Noto Sans KR 폴백)에서 번들한 XK Sans KR(Pretendard Variable 의 수정판 서브셋)로 바뀐다. 토큰 `--font` 첫 항목과 같은 글꼴이다.
- 변경: `tools/build_pretendard_subset.py`(KS X 1001 2,350자 + 라틴·숫자·기호, wght 400–600, 힌팅 제거, name 테이블을 XK Sans KR 로 — OFL 예약 이름, 794,212 bytes < 1MB), `XkTactileFonts`(family `XK Sans KR`, `assetDir` 한 문자열로 앱 사본·pubspec·로더 키 통일, 패키지 번들 경로), Noto 10.4MB 삭제, 폰트 복사기(사본 폴더 모양·pubspec 검사)·소비 앱 모양 테스트·name 테이블 테스트·CI `--check`.
- 측정: 첫 로드 전송량 전후는 PR 본문. 서브셋 밖 글자(KS X 1001 밖 한글 8,822자·한자·이모지)는 엔진 폴백으로 그려진다.
- 소비처: coTact·Concierge·frontend-boilerplate 는 `sync_tactile_fonts.py --write --consumer …` 로 `<app>/assets/fonts/xk_sans_kr/` 사본을 받고 pubspec `assets` 에 `assets/fonts/xk_sans_kr/` 를 적는다(별도 PR).
- 상태: 라이브러리 PR. 패키지 게시·앱 반영·라이브 확인은 하지 않았다.

## 2026-09-25 — 제품 화면 버전 6-B 역할 (패키지 4.6.0)

- 전후: 앱 첫인상 자리(로그인·빈 상태·대시보드 머리·결제 완료)가 밝은 정보 면에서 잉크 면으로 바뀐다. 현재 위치·핵심 숫자·사람 확인 문구는 짙은 파생 Aquamarine 글자로 쓴다. 탭·내비게이션의 선택 표시는 잉크 채움·옅은 밑줄에서 중립 선택 면으로 바뀐다. 주 버튼·체크박스·포커스는 모노크롬 그대로다.
- 변경: `XkTactileAppSurface` ThemeExtension, `XkTactileAppIntro`·`XkTactileBrandWord`·`XkTactileHumanReview`·`XkTactileRouteFade`, 역할 생성기의 `app-surface.css` 계산. 새 토큰·새 hex는 없다.
- 소비처: coTact·Concierge·frontend-boilerplate는 `sync_tactile_dart.py --write`로 사본을 받는다. `tactile_app_surface.dart`가 새로 들어오므로 `PROVENANCE.json` 파일 목록이 11개로 는다. 각 리포 `check_tactile_dart.py`의 `REQUIRED`는 기존 8개의 부분집합 검사라 그대로 통과한다. 새 파일을 필수로 두려면 소비처 PR에서 추가한다.
- 상태: 라이브러리 PR이다. 앱 반영과 라이브 확인은 소비처 PR에서 한다. 패키지 게시는 별도다.

## 2026-09-23 — 모노크롬과 테마별 Aquamarine

- 전후: 이전 파란색 계열의 큰 주 액션과 장식을 줄이고, 배경은 라이트 `#F5F5F5`·다크 `#111111`로 고정했다. Aquamarine은 라이트 `#269DB0`·다크 `#65C9D9`를 작은 브랜드 포인트에 쓴다. 주 액션과 포커스는 모노크롬이다.
- 변경: TACTILE 토큰과 평면 주 버튼·중립 포커스·Material 역할을 웹 컬러 결정에 맞추고 Dart 소비 사본을 동기화했다.
- 검사: 디자인 시스템 패키지 123 테스트·analyze·예제 릴리스 웹 빌드 통과, Dart 소비 사본 3곳 일치. 앱 실화면은 아직 확인하지 않았다.
- 상태: 로컬 변경이다. 운영 배포와 라이브 검증은 아직 하지 않았다.
