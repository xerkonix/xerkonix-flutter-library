// TACTILE tokens.css ↔ 라이브러리 토큰 대조.
//
// 2026-07-27 라이트 기능색 WCAG AA 승급, 2026-08 v2.1(다크 error 보정 ·
// on-soft · radius-ctl · sp-4h 편입) 때 미러가 늦게 따라오는 사고가 반복됐다.
// 사람이 두 파일을 기억으로 맞추는 대신 이 테스트가 tokens.css 를 실제로 읽어
// 파싱·대조한다 — 값이 다시 어긋나면 어느 변수 쌍인지 즉시 나온다.
//
// 어느 tokens.css 를 읽는가 (둘 중 하나, skip 은 없다):
//   1. 워크스페이스 형제 리포의 tokens.css — 두 리포가 나란히 클론된 개발 환경
//   2. test/fixtures/tokens.css — 이 패키지에 동봉한 스냅샷. 리포 하나만 클론한
//      CI 에서 쓴다. 예전에는 형제가 없으면 skip 했는데, 그러면 CI 가 이 스위트를
//      한 번도 돌리지 않은 채 초록이 된다(2026-09-02 감사 F-07).
// 형제 리포가 있으면 스냅샷이 그것과 바이트 단위로 같은지도 확인한다 — 스냅샷이
// 낡은 채 CI 만 통과하는 상태를 막는다. tokens.css 를 승급하면 스냅샷도 같은
// 커밋에서 갱신한다.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:xerkonix_design_system/src/typography/typo_constants.dart';

/// 워크스페이스 루트에 리포들이 나란히 있을 때의 형제 경로.
/// 테스트 실행 위치는 이 패키지 루트(xerkonix-design-system).
const String _siblingPath = '../../xerkonix-tactile-design/tokens.css';

/// 형제 리포가 없는 환경(CI)에서 대조하는 동봉 스냅샷.
const String _fixturePath = 'test/fixtures/tokens.css';

// ---------------------------------------------------------------------------
// 정본 CSS 파싱
// ---------------------------------------------------------------------------

/// 주석부터 걷어낸다. 정본 주석은 설명을 위해 `--radius-ctl:12px` 같은 선언을
/// 그대로 인용하는데, 남겨두면 파서가 인용문을 진짜 선언으로 읽고 뒤따르는 실제
/// 선언 하나를 통째로 삼킨다(실제로 --radius-xs 가 사라졌다).
String _stripComments(String css) => css.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), ' ');

/// `:root { … }`(라이트) 블록. 다크는 별도 셀렉터로 분리돼 있어 첫 블록만
/// 읽으면 라이트 값이다.
String _lightBlock(String css) {
  final String c = _stripComments(css);
  final int start = c.indexOf(':root');
  return c.substring(start, c.indexOf('}', start));
}

/// 다크 오버라이드 블록(`:root[data-theme="dark"] { … }`).
/// 주석 안에도 `[data-theme="dark"]` 문구가 나오므로 셀렉터 전체로 앵커한다.
String _darkBlock(String css) {
  final String c = _stripComments(css);
  final int start = c.indexOf(':root[data-theme="dark"]');
  return c.substring(start, c.indexOf('}', start));
}

/// 블록 안의 모든 `--변수: 값;` 선언 (값은 원문 그대로).
Map<String, String> _rawVars(String block) {
  final RegExp pattern = RegExp(r'(--[a-z0-9-]+)\s*:\s*([^;]+);');
  return <String, String>{
    for (final RegExpMatch m in pattern.allMatches(block))
      m.group(1)!: m.group(2)!.trim(),
  };
}

/// CSS 색 표기(#RRGGBB · rgba(r,g,b,a) · var(--이름)) → [Color].
/// var() 는 같은 블록의 [vars] 안에서 재귀 해석한다.
Color _cssColor(String value, Map<String, String> vars) {
  final String v = value.trim();
  if (v.startsWith('var(')) {
    final String name = v.substring(4, v.indexOf(')')).trim();
    final String? resolved = vars[name];
    if (resolved == null) {
      fail('var($name) 를 블록 안에서 해석할 수 없다');
    }
    return _cssColor(resolved, vars);
  }
  if (v.startsWith('#')) {
    expect(v.length, 7, reason: '6자리 hex 만 지원: $v');
    return Color(0xFF000000 | int.parse(v.substring(1), radix: 16));
  }
  final RegExpMatch? m = RegExp(
    r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([0-9.]+))?\s*\)',
  ).firstMatch(v);
  if (m == null) {
    fail('색 표기를 해석할 수 없다: $v');
  }
  final double alpha = m.group(4) == null ? 1.0 : double.parse(m.group(4)!);
  return Color.fromARGB(
    (alpha * 255).round(),
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
  );
}

/// `6px` · `999px` → 6.0 · 999.0.
double _cssPx(String value) => double.parse(value.trim().replaceAll('px', ''));

/// box-shadow 한 겹의 기대값 (offset / blur / color 단위 대조용).
// ---------------------------------------------------------------------------
// 대조 헬퍼
// ---------------------------------------------------------------------------

String _hex(Color c) =>
    '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

/// 정본 변수 → 라이브러리 색 쌍을 일괄 대조. 어긋난 쌍 전부를 한 번에 보고한다.
void _expectColorParity(
  Map<String, String> vars,
  Map<String, Color> pairs,
  String hint,
) {
  final Map<String, String> mismatched = <String, String>{};
  pairs.forEach((String name, Color actual) {
    final String? raw = vars[name];
    if (raw == null) {
      mismatched[name] = '정본에서 변수가 사라졌다 — 매핑도 함께 고쳐라';
      return;
    }
    final Color expected = _cssColor(raw, vars);
    if (expected != actual) {
      mismatched[name] = '정본 ${_hex(expected)} ≠ 라이브러리 ${_hex(actual)}';
    }
  });
  expect(mismatched, isEmpty, reason: hint);
}

void main() {
  final File sibling = File(_siblingPath);
  final File fixture = File(_fixturePath);
  final File canon = sibling.existsSync() ? sibling : fixture;

  // skip 은 두지 않는다 — 형제 리포가 없으면 동봉 스냅샷과 대조한다.

  group('tokens.css 출처', () {
    test('읽을 tokens.css 가 존재한다 (형제 리포 또는 동봉 스냅샷)', () {
      expect(
        fixture.existsSync(),
        isTrue,
        reason: '$_fixturePath 스냅샷이 없다 — CI 는 이 파일로 대조한다.',
      );
      expect(canon.existsSync(), isTrue);
    });

    test('형제 리포가 있으면 동봉 스냅샷과 바이트 단위로 같다', () {
      if (!sibling.existsSync()) {
        return; // CI: 형제가 없으니 스냅샷 자체가 대조 대상이다.
      }
      expect(
        fixture.readAsStringSync(),
        sibling.readAsStringSync(),
        reason:
            '$_fixturePath 가 형제 리포의 tokens.css 보다 낡았다 — '
            'tokens.css 를 승급했으면 스냅샷도 같은 커밋에서 갱신한다.',
      );
    });
  });

  late final String css = canon.readAsStringSync();
  late final Map<String, String> light = _rawVars(_lightBlock(css));
  late final Map<String, String> dark = _rawVars(_darkBlock(css));
  // 다크 블록은 **오버라이드만** 적는다 — 무채 12단 같은 :root 선언은 없다.
  // 그래서 다크의 var(--gray-000) 처럼 :root 를 가리키는 참조는 다크 맵만으로는
  // 풀리지 않는다. CSS 캐스케이드대로 :root 위에 다크를 얹어 해석한다.
  late final Map<String, String> darkAll = <String, String>{...light, ...dark};


  test('role typography matches shared tokens', () {
    final Map<String, double> pairs = <String, double>{
      '--x-fs-display': TypoConst.fontSize.displayMax,
      '--x-fs-display-mobile': TypoConst.fontSize.displayMin,
      '--x-fs-section': TypoConst.fontSize.h1Max,
      '--x-fs-page': TypoConst.fontSize.pageTitle,
      '--x-fs-title': TypoConst.fontSize.h3,
      '--x-fs-body': TypoConst.fontSize.bodyLarge,
      '--x-fs-body-mobile': TypoConst.fontSize.body,
      '--x-fs-small': TypoConst.fontSize.label,
      '--x-fs-caption': TypoConst.fontSize.meta,
    };
    for (final MapEntry<String, double> pair in pairs.entries) {
      expect(pair.value, _cssPx(light[pair.key]!), reason: pair.key);
    }
  });

  group('표면 · 잉크', () {
    test('라이트 표면·잉크가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--x-bg': XkColor.bg,
        '--x-panel': XkColor.panel,
        '--x-black': XkColor.black,
        '--x-ink': XkColor.ink,
        '--x-muted': XkColor.muted,
        '--x-hair': XkColor.hair,
        '--x-hair-soft': XkColor.hairSoft,
        '--x-well': XkColor.well,
      }, 'XkColor 표면을 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 표면·잉크가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--x-bg': XkColor.darkBg,
        '--x-panel': XkColor.darkPanel,
        '--x-ink': XkColor.darkInk,
        '--x-muted': XkColor.darkMuted,
        '--x-hair': XkColor.darkHair,
        '--x-hair-soft': XkColor.darkHairSoft,
        '--x-well': XkColor.darkWell,
      }, 'XkColor 표면을 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('물빛', () {
    test('라이트 물빛이 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--x-tint-text': XkColor.tintText,
        '--x-tint-text-hover': XkColor.tintTextHover,
        '--x-tint-fill': XkColor.tintFill,
        '--x-tint-on-fill': XkColor.tintOnFill,
        '--x-tint': XkColor.tint,
        '--x-tint-light': XkColor.tintLight,
        '--x-tint-gem': XkColor.tintGem,
        '--x-tint-soft': XkColor.tintSoft,
        '--x-tint-dark': XkColor.tintDark,
      }, 'XkColor 물빛을 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 물빛이 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--x-tint-text': XkColor.darkTintText,
        '--x-tint-text-hover': XkColor.darkTintTextHover,
        '--x-tint-fill': XkColor.darkTintFill,
        '--x-tint-on-fill': XkColor.darkTintOnFill,
        '--x-tint': XkColor.darkTint,
        '--x-tint-light': XkColor.darkTintLight,
        '--x-tint-gem': XkColor.darkTintGem,
        '--x-tint-soft': XkColor.darkTintSoft,
      }, 'XkColor 물빛을 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('상태 · 온도', () {
    test('라이트 상태·온도가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--x-ok': XkColor.ok,
        '--x-warn': XkColor.warn,
        '--x-bad': XkColor.bad,
        '--x-ok-on': XkColor.okOn,
        '--x-warn-on': XkColor.warnOn,
        '--x-bad-on': XkColor.badOn,
        '--x-warm': XkColor.warm,
        '--x-cool': XkColor.cool,
      }, 'XkColor 상태·온도를 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 상태·온도가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--x-ok': XkColor.darkOk,
        '--x-warn': XkColor.darkWarn,
        '--x-bad': XkColor.darkBad,
        '--x-warm': XkColor.darkWarm,
        '--x-cool': XkColor.darkCool,
      }, 'XkColor 상태·온도를 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('빛 층 그림자', () {
    test('raisedLight xy 오프셋이 양수다 (30° · --x-sx/--x-sy)', () {
      for (final BoxShadow s in XkShadow.raisedLight) {
        expect(s.offset.dx >= 0, isTrue, reason: '${s.offset}');
        expect(s.offset.dy >= 0, isTrue, reason: '${s.offset}');
      }
    });
    test('raisedDark xy 오프셋이 양수다', () {
      for (final BoxShadow s in XkShadow.raisedDark) {
        expect(s.offset.dx >= 0, isTrue);
        expect(s.offset.dy >= 0, isTrue);
      }
    });
  });

  group('곡률 · 간격', () {
    test('radius 사다리가 출처(tokens.css)와 같다', () {
      final Map<String, double> pairs = <String, double>{
        '--x-r-lg': XkShape.radiusLg,
        '--x-r-md': XkShape.radiusMd,
        '--x-r-card': XkShape.radiusCard,
        '--x-r-sm': XkShape.radiusSm,
        '--x-pill': XkShape.radiusFull,
      };
      final Map<String, String> mismatched = <String, String>{};
      pairs.forEach((String name, double actual) {
        final String? raw = light[name];
        if (raw == null) {
          mismatched[name] = '정본에서 변수가 사라졌다';
        } else if (_cssPx(raw) != actual) {
          mismatched[name] = '정본 ${_cssPx(raw)} ≠ 라이브러리 $actual';
        }
      });
      expect(mismatched, isEmpty, reason: 'XkShape radius 를 tokens.css 값으로 맞춰라.');
    });
    test('spacing 사다리가 출처(tokens.css)와 같다', () {
      final Map<String, double> pairs = <String, double>{
        '--x-sp-1': XkLayout.spacingXxs,
        '--x-sp-2': XkLayout.spacingXs,
        '--x-sp-3': XkLayout.spacingSm,
        '--x-sp-4': XkLayout.spacingMd,
        '--x-sp-5': XkLayout.spacingLg,
        '--x-sp-6': XkLayout.spacing2xl,
        '--x-sp-7': XkLayout.spacing3xl,
      };
      final Map<String, String> mismatched = <String, String>{};
      pairs.forEach((String name, double actual) {
        final String? raw = light[name];
        if (raw == null) {
          mismatched[name] = '정본에서 변수가 사라졌다';
        } else if (_cssPx(raw) != actual) {
          mismatched[name] = '정본 ${_cssPx(raw)} ≠ 라이브러리 $actual';
        }
      });
      expect(mismatched, isEmpty, reason: 'XkLayout spacing 을 tokens.css 값으로 맞춰라.');
    });
  });

  group('커버리지', () {
    const Set<String> mirrored = <String>{
      '--x-fs-display','--x-fs-display-mobile','--x-fs-section','--x-fs-page','--x-fs-title','--x-fs-body','--x-fs-body-mobile','--x-fs-small','--x-fs-caption',
      '--x-bg', '--x-panel', '--x-black', '--x-ink', '--x-muted',
      '--x-hair', '--x-hair-soft', '--x-well',
      '--x-tint-text', '--x-tint-text-hover', '--x-tint-fill', '--x-tint-on-fill',
      '--x-tint', '--x-tint-light', '--x-tint-gem', '--x-tint-soft', '--x-tint-dark',
      '--x-warm', '--x-cool', '--x-ok', '--x-warn', '--x-bad',
      '--x-ok-on', '--x-warn-on', '--x-bad-on',
      '--x-r-lg', '--x-r-md', '--x-r-card', '--x-r-sm', '--x-pill',
      '--x-sp-1', '--x-sp-2', '--x-sp-3', '--x-sp-4', '--x-sp-5', '--x-sp-6', '--x-sp-7',
    };
    const Map<String, String> notMirrored = <String, String>{
      '--x-fs-section-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-fs-page-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-fs-title-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-leading-body': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-leading-heading': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-content-width': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-reading-width': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-section-space': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-section-space-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-gutter': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-gutter-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-control-height': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--x-sans': '폰트 패밀리 — 패키지가 Pretendard 로 지정',
      '--x-mono': '폰트 패밀리 — Pretendard + tabular-nums',
      '--x-t1': 'XkMotion 소관',
      '--x-t2': 'XkMotion 소관',
      '--x-t3': 'XkMotion 소관',
      '--x-ease': 'CSS 베지어 — Curves 로 근사',
      '--x-lx': '웹 무대 광원 좌표',
      '--x-ly': '웹 무대 광원 좌표',
      '--x-sx': '그림자 계수 — XkShadow 기하로 대표',
      '--x-sy': '그림자 계수 — XkShadow 기하로 대표',
      '--x-wash': '웹 무대 그라데이션',
      '--x-far': '웹 무대 그라데이션',
      '--x-far-p': '웹 무대 그라데이션',
      '--x-glow': '웹 무대 글로우',
      '--x-glow-p': '웹 무대 글로우',
      '--x-hi': 'inset 하이라이트 — Flutter BoxShadow 로 1:1 불가',
      '--x-sh': 'XkShadow.raised 색',
      '--x-sh-far': 'XkShadow.raised 색',
      '--x-nav': '웹 내비 스크림',
    };
    test('출처 라이트 블록의 모든 토큰이 미러링되거나 이유가 적혀 있다', () {
      final Set<String> unaccounted = light.keys
          .where((String n) =>
              !mirrored.contains(n) && !notMirrored.containsKey(n))
          .toSet();
      expect(unaccounted, isEmpty,
          reason: '정본에 새 토큰이 생겼다. 미러하거나 notMirrored 에 이유를 적어라.');
    });
    test('mirrored 에 적힌 이름이 출처 tokens.css 에 실제로 있다', () {
      final Set<String> stale =
          mirrored.where((String n) => !light.containsKey(n)).toSet();
      expect(stale, isEmpty, reason: '정본에서 사라진 토큰이 mirrored 에 남아 있다.');
    });
  });
}
