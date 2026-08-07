// 정본(xerkonix-tactile-design/tokens.css) ↔ 라이브러리 토큰 대조.
//
// 2026-07-27 정본의 라이트 기능색 WCAG AA 승급, 2026-08 v2.1(다크 error 보정 ·
// on-soft · radius-ctl · sp-4h 편입) 때 미러가 늦게 따라오는 사고가 반복됐다.
// 사람이 두 파일을 기억으로 맞추는 대신 이 테스트가 정본 CSS 를 실제로 읽어
// 파싱·대조한다 — 값이 다시 어긋나면 어느 변수 쌍인지 즉시 나온다.
//
// 정본 파일이 없는 환경(리포 하나만 클론한 CI 등)에서는 skip 한다 — 워크스페이스
// 레이아웃에 의존하는 검사라 없다고 실패시키면 관계없는 빌드를 깨뜨린다.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:xerkonix_design_system/xerkonix_design_system.dart';

/// 워크스페이스 루트(…/xerkonix)에 리포들이 나란히 있다는 전제.
/// 테스트 실행 위치는 xerkonix-flutter-library/xerkonix-design-system.
const String _canonPath = '../../xerkonix-tactile-design/tokens.css';

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
class _ShadowSpec {
  const _ShadowSpec(this.offset, this.blur, this.color);

  final Offset offset;
  final double blur;
  final Color color;
}

/// 괄호 안 콤마(rgba)를 건너뛰는 최상위 콤마 분리.
List<String> _splitTopLevel(String raw) {
  final List<String> parts = <String>[];
  int depth = 0;
  int start = 0;
  for (int i = 0; i < raw.length; i++) {
    final String c = raw[i];
    if (c == '(') {
      depth++;
    } else if (c == ')') {
      depth--;
    } else if (c == ',' && depth == 0) {
      parts.add(raw.substring(start, i));
      start = i + 1;
    }
  }
  parts.add(raw.substring(start));
  return parts;
}

/// `8px 8px 18px var(--neu-shadow), -5px -5px 12px var(--neu-light)` 류의
/// box-shadow 목록 → [_ShadowSpec] 목록.
List<_ShadowSpec> _cssShadows(String raw, Map<String, String> vars) {
  return _splitTopLevel(raw).map((String part) {
    final String p = part.trim();
    expect(p.startsWith('inset'), isFalse, reason: 'inset 은 대조 대상이 아니다: $p');
    // 색 부분(var()/rgba()/#hex)을 먼저 떼어내고 남은 숫자를 기하로 읽는다.
    final RegExpMatch? colorMatch = RegExp(
      r'var\(--[a-z0-9-]+\)|rgba?\([^)]*\)|#[0-9a-fA-F]{6}',
    ).firstMatch(p);
    if (colorMatch == null) {
      fail('box-shadow 에서 색을 찾을 수 없다: $p');
    }
    final Color color = _cssColor(colorMatch.group(0)!, vars);
    final List<double> nums = p
        .replaceRange(colorMatch.start, colorMatch.end, '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((String t) => t.isNotEmpty)
        .map(_cssPx)
        .toList();
    expect(nums.length, 3, reason: 'x/y/blur 3값을 기대: $p');
    return _ShadowSpec(Offset(nums[0], nums[1]), nums[2], color);
  }).toList();
}

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

/// BoxShadow 목록을 offset / blur / color 단위로 대조.
void _expectShadowParity(
  String name,
  List<BoxShadow> actual,
  List<_ShadowSpec> expected,
) {
  expect(actual.length, expected.length, reason: '$name: 그림자 겹 수가 다르다');
  for (int i = 0; i < expected.length; i++) {
    expect(actual[i].offset, expected[i].offset, reason: '$name[$i] offset');
    expect(actual[i].blurRadius, expected[i].blur, reason: '$name[$i] blur');
    expect(
      actual[i].color,
      expected[i].color,
      reason:
          '$name[$i] color — 정본 ${_hex(expected[i].color)} '
          '≠ 라이브러리 ${_hex(actual[i].color)}',
    );
  }
}

void main() {
  final File canon = File(_canonPath);

  // 정본 리포가 옆에 없는 환경(리포 하나만 클론한 CI)에서는 건너뛴다.
  final String? skip = canon.existsSync()
      ? null
      : '정본 리포(xerkonix-tactile-design)가 워크스페이스에 없다';

  late final String css = canon.readAsStringSync();
  late final Map<String, String> light = _rawVars(_lightBlock(css));
  late final Map<String, String> dark = _rawVars(_darkBlock(css));

  group('무채 12단', () {
    test('gray-000…950 이 TACTILE 정본과 같다', skip: skip, () {
      _expectColorParity(light, <String, Color>{
        '--gray-000': XkColor.gray000,
        '--gray-050': XkColor.gray050,
        '--gray-100': XkColor.gray100,
        '--gray-200': XkColor.gray200,
        '--gray-300': XkColor.gray300,
        '--gray-400': XkColor.gray400,
        '--gray-500': XkColor.gray500,
        '--gray-600': XkColor.gray600,
        '--gray-700': XkColor.gray700,
        '--gray-800': XkColor.gray800,
        '--gray-900': XkColor.gray900,
        '--gray-950': XkColor.gray950,
      }, 'XkColor 의 gray 단을 tokens.css 값으로 맞춰라.');
    });
  });

  group('기능색', () {
    test('라이트 기능색 6종 + on-soft 가 정본과 같다', skip: skip, () {
      _expectColorParity(light, <String, Color>{
        '--success': XkColor.success,
        '--warning': XkColor.warning,
        '--error': XkColor.error,
        '--temp-warm': XkColor.tempWarm,
        '--temp-cool': XkColor.tempCool,
        '--text-muted': XkColor.textMuted,
        // [v2.1] on-soft — soft 틴트 위 텍스트 전용 (라이트만 별도 hex).
        '--success-on-soft': XkColor.successOnSoft,
        '--warning-on-soft': XkColor.warningOnSoft,
        '--error-on-soft': XkColor.errorOnSoft,
      }, 'XkColor 라이트 기능색을 tokens.css 값으로 맞춰라.');
    });

    test('다크 기능색 6종이 정본과 같다', skip: skip, () {
      _expectColorParity(dark, <String, Color>{
        '--success': XkColor.darkSuccess,
        '--warning': XkColor.darkWarning,
        '--error': XkColor.darkError, // [v2.1] #E4696B → #E67274
        '--temp-warm': XkColor.darkTempWarm,
        '--temp-cool': XkColor.darkTempCool,
        '--text-muted': XkColor.darkTextMuted,
      }, 'XkColor 다크 기능색을 tokens.css 다크 블록 값으로 맞춰라.');
    });

    // 정본 v2.1: 다크 soft 는 반투명이라 본색이 그대로 통과 — on-soft 는 본색
    // 별칭(var(--success) 등)이다. 별칭 규칙 자체를 대조한다 (정본 불필요).
    test('다크 on-soft 는 본색 별칭이다', () {
      expect(XkColor.darkSuccessOnSoft, XkColor.darkSuccess);
      expect(XkColor.darkWarningOnSoft, XkColor.darkWarning);
      expect(XkColor.darkErrorOnSoft, XkColor.darkError);
    });
  });

  group('다크 뉴모픽', () {
    // 정본 규칙: 다크는 어두운 표면 위 하이라이트 그림자를 금지 — --neu-light 는
    // rgba(255,255,255,0), 즉 "거의 투명"이 아니라 정확히 0 이다.
    test('darkHighlight 는 알파 정확히 0 이다', skip: skip, () {
      expect(_cssColor(dark['--neu-light']!, dark), XkShadow.darkHighlight);
      expect(XkShadow.darkHighlight.a, 0.0);
    });

    test('darkLowlight 가 정본 --neu-shadow 와 같다', skip: skip, () {
      expect(
        XkShadow.darkLowlight,
        _cssColor(dark['--neu-shadow']!, dark),
        reason: '정본 다크 --neu-shadow(rgba(0,0,0,.62)) 와 어긋났다.',
      );
    });

    test('raisedDark 기하가 정본 다크 --neu-raise(8/8/18 · -5/-5/12) 와 같다',
        skip: skip, () {
      _expectShadowParity(
        '--neu-raise(dark)',
        XkShadow.raisedDark,
        _cssShadows(dark['--neu-raise']!, dark),
      );
    });

    // 라이트 짝(7/7/16 · -6/-6/14)도 같은 파서로 잡아둔다 — 광원 기하가 한쪽만
    // 바뀌는 드리프트 방지.
    test('raisedLight 기하가 정본 라이트 --neu-raise 와 같다', skip: skip, () {
      _expectShadowParity(
        '--neu-raise(light)',
        XkShadow.raisedLight,
        _cssShadows(light['--neu-raise']!, light),
      );
    });
  });

  group('스크림', () {
    // 다크 --bg 가 거의 검정이라 배경색 계열 스크림은 암전이 0 — 정본은 테마별로
    // 값이 다르다(라이트 rgba(26,27,34,.45) · 다크 rgba(0,0,0,.66)).
    test('라이트/다크 scrim 이 정본과 같다', skip: skip, () {
      expect(
        XkLightTheme.themeData.colorScheme.scrim,
        _cssColor(light['--scrim']!, light),
        reason: '라이트 scrim 이 정본과 어긋났다.',
      );
      expect(
        XkDarkTheme.themeData.colorScheme.scrim,
        _cssColor(dark['--scrim']!, dark),
        reason: '다크 scrim 이 정본과 어긋났다.',
      );
    });
  });

  group('드롭 섀도우 (--shadow / --shadow-lg)', () {
    // 라이브러리는 이 토큰을 색으로만 보유한다(XkColor.shadow*) — 색 단위 대조.
    test('라이트 shadow/shadowLg 색이 정본(gray-900 틴트)과 같다', skip: skip, () {
      final Color shadow = _cssShadows(light['--shadow']!, light).single.color;
      final Color shadowLg =
          _cssShadows(light['--shadow-lg']!, light).single.color;
      expect(XkColor.shadow, shadow);
      expect(XkColor.shadowLg, shadowLg);
      // 틴트 확인: RGB 성분이 gray-900(#2A2B35) 그대로다.
      final int gray900 = XkColor.gray900.toARGB32() & 0xFFFFFF;
      expect(shadow.toARGB32() & 0xFFFFFF, gray900,
          reason: '라이트 --shadow 는 gray-900 틴트가 정본이다.');
      expect(shadowLg.toARGB32() & 0xFFFFFF, gray900,
          reason: '라이트 --shadow-lg 는 gray-900 틴트가 정본이다.');
    });

    test('다크 shadow/shadowLg 색이 정본(.32/.42 순검정)과 같다', skip: skip, () {
      expect(
        XkColor.darkShadow,
        _cssShadows(dark['--shadow']!, dark).single.color,
      );
      expect(
        XkColor.darkShadowLg,
        _cssShadows(dark['--shadow-lg']!, dark).single.color,
      );
    });
  });

  group('떠 있는 층 (--float)', () {
    // [v2.1] 단방향 드롭 — 만지는 층의 --neu-raise 와 다르다.
    test('liftedLight 가 정본 라이트 --float 와 같다', skip: skip, () {
      _expectShadowParity(
        '--float(light)',
        XkShadow.liftedLight,
        _cssShadows(light['--float']!, light),
      );
    });

    test('liftedDark 가 정본 다크 --float 와 같다', skip: skip, () {
      _expectShadowParity(
        '--float(dark)',
        XkShadow.liftedDark,
        _cssShadows(dark['--float']!, dark),
      );
    });
  });

  group('곡률 · 간격 사다리', () {
    test('radius 사다리(ctl 포함)가 정본과 같다', skip: skip, () {
      final Map<String, double> pairs = <String, double>{
        '--radius-xs': XkShape.radiusXs,
        '--radius-sm': XkShape.radiusSm,
        '--radius-ctl': XkShape.radiusCtl, // [v2.1] 컨트롤 전용 단
        '--radius-md': XkShape.radiusMd,
        '--radius-lg': XkShape.radiusLg,
        '--radius-xl': XkShape.radiusXl,
        '--radius-pill': XkShape.radiusFull,
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
      expect(mismatched, isEmpty,
          reason: 'XkShape 의 radius 단을 tokens.css 값으로 맞춰라.');
    });

    test('spacing 사다리(12/20/48/64 포함)가 정본과 같다', skip: skip, () {
      final Map<String, double> pairs = <String, double>{
        '--sp-1': XkLayout.spacingXxs,
        '--sp-2': XkLayout.spacingXs,
        '--sp-3': XkLayout.spacingSm, // 12 — 옛 10 은 사다리 밖이었다
        '--sp-4': XkLayout.spacingMd,
        '--sp-4h': XkLayout.spacingLg, // [v2.1] 공식 반단 20
        '--sp-5': XkLayout.spacingXl,
        '--sp-6': XkLayout.spacing2xl,
        '--sp-7': XkLayout.spacing3xl, // 48
        '--sp-8': XkLayout.spacing4xl, // 64
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
      expect(mismatched, isEmpty,
          reason: 'XkLayout 의 spacing 단을 tokens.css 값으로 맞춰라.');
    });
  });
}
