// TACTILE tokens.css ↔ 라이브러리 토큰 대조 (v4.0.0).
//
// 사람이 두 파일을 기억으로 맞추는 대신 이 테스트가 tokens.css 를 실제로 읽어
// 파싱·대조한다 — 값이 다시 어긋나면 어느 변수 쌍인지 즉시 나온다.
//
// 어느 tokens.css 를 읽는가 (둘 중 하나, skip 은 없다):
//   1. 워크스페이스 형제 리포의 tokens.css
//   2. test/fixtures/tokens.css — CI 스냅샷
// 형제 리포가 있으면 스냅샷이 그것과 바이트 단위로 같은지도 확인한다.

// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:xerkonix_design_system/src/typography/typo_constants.dart';

const String _siblingPath = '../../xerkonix-tactile-design/tokens.css';
const String _fixturePath = 'test/fixtures/tokens.css';

String _stripComments(String css) =>
    css.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), ' ');

String _lightBlock(String css) {
  final String c = _stripComments(css);
  final int start = c.indexOf(':root');
  return c.substring(start, c.indexOf('}', start));
}

String _darkBlock(String css) {
  final String c = _stripComments(css);
  final int start = c.indexOf(':root[data-theme="dark"]');
  return c.substring(start, c.indexOf('}', start));
}

Map<String, String> _rawVars(String block) {
  final RegExp pattern = RegExp(r'(--[a-z0-9-]+)\s*:\s*([^;]+);');
  return <String, String>{
    for (final RegExpMatch m in pattern.allMatches(block))
      m.group(1)!: m.group(2)!.trim(),
  };
}

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

double _cssPx(String value) => double.parse(value.trim().replaceAll('px', ''));

Duration _cssDuration(String value) {
  final String v = value.trim();
  if (v.endsWith('ms')) {
    return Duration(milliseconds: int.parse(v.replaceAll('ms', '')));
  }
  if (v.endsWith('s')) {
    final double sec = double.parse(v.substring(0, v.length - 1));
    return Duration(milliseconds: (sec * 1000).round());
  }
  fail('duration 을 해석할 수 없다: $v');
}

String _hex(Color c) =>
    '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

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
        return;
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
  late final Map<String, String> darkAll = <String, String>{...light, ...dark};

  test('role typography matches shared tokens', () {
    final Map<String, double> pairs = <String, double>{
      '--fs-display': TypoConst.fontSize.displayMax,
      '--fs-display-mobile': TypoConst.fontSize.displayMin,
      '--fs-section': TypoConst.fontSize.h1Max,
      '--fs-page': TypoConst.fontSize.pageTitle,
      '--fs-title': TypoConst.fontSize.h3,
      '--fs-body': TypoConst.fontSize.bodyLarge,
      '--fs-body-mobile': TypoConst.fontSize.body,
      '--fs-small': TypoConst.fontSize.label,
      '--fs-caption': TypoConst.fontSize.meta,
      '--fs-label': XkFontSize.label,
    };
    for (final MapEntry<String, double> pair in pairs.entries) {
      expect(pair.value, _cssPx(light[pair.key]!), reason: pair.key);
    }
  });

  group('표면 · 잉크', () {
    test('라이트 표면·잉크가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--canvas': XkColor.canvas,
        '--ground-hi': XkColor.groundHi,
        '--ink': XkColor.ink,
        '--ink-2': XkColor.ink2,
        '--ink-3': XkColor.ink3,
        '--rule': XkColor.rule,
        '--inset-bg': XkColor.insetBg,
        '--head-glass': XkColor.headGlass,
      }, 'XkColor 표면을 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 표면·잉크가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--canvas': XkColor.darkCanvas,
        '--ground-hi': XkColor.darkGroundHi,
        '--ink': XkColor.darkInk,
        '--ink-2': XkColor.darkInk2,
        '--ink-3': XkColor.darkInk3,
        '--rule': XkColor.darkRule,
        '--inset-bg': XkColor.darkInsetBg,
        '--head-glass': XkColor.darkHeadGlass,
      }, 'XkColor 표면을 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('아쿠아마린', () {
    test('라이트 아쿠아가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--aqua-100': XkColor.aqua100,
        '--aqua-tint': XkColor.aquaTint,
        '--aqua-hi': XkColor.aquaHi,
        '--aqua': XkColor.aqua,
        '--aqua-mid': XkColor.aquaMid,
        '--aqua-shade': XkColor.aquaShade,
        '--aqua-deep': XkColor.aquaDeep,
        '--aqua-ink': XkColor.aquaInk,
      }, 'XkColor 아쿠아를 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 아쿠아가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--aqua-100': XkColor.darkAqua100,
        '--aqua-tint': XkColor.darkAquaTint,
        '--aqua-hi': XkColor.darkAquaHi,
        '--aqua': XkColor.darkAqua,
        '--aqua-mid': XkColor.darkAquaMid,
        '--aqua-shade': XkColor.darkAquaShade,
        '--aqua-deep': XkColor.darkAquaDeep,
        '--aqua-ink': XkColor.darkAquaInk,
      }, 'XkColor 아쿠아를 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('글래스', () {
    test('라이트 글래스가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--glass': XkColor.glass,
        '--glass-strong': XkColor.glassStrong,
        '--glass-edge': XkColor.glassEdge,
        '--glass-edge-2': XkColor.glassEdge2,
        '--spec': XkColor.spec,
      }, 'XkColor 글래스를 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 글래스가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--glass': XkColor.darkGlass,
        '--glass-strong': XkColor.darkGlassStrong,
        '--glass-edge': XkColor.darkGlassEdge,
        '--glass-edge-2': XkColor.darkGlassEdge2,
        '--spec': XkColor.darkSpec,
      }, 'XkColor 글래스를 tokens.css 다크 값으로 맞춰라.');
    });
    test('glass-shadow 레이어가 정본과 같다', () {
      expect(XkShadow.glassLight.length, 2);
      expect(XkShadow.glassLight.first.offset, const Offset(0, 24));
      expect(XkShadow.glassLight.first.blurRadius, 60);
      expect(XkShadow.glassLight.first.spreadRadius, -36);
      expect(XkShadow.glassLight.last.offset, const Offset(0, 1));
      expect(XkShadow.glassLight.last.blurRadius, 3);
      expect(XkShadow.glassLight.last.spreadRadius, -1);
      expect(XkShadow.glassLight.first.offset.dx >= 0, isTrue);
      expect(XkShadow.glassLight.first.offset.dy >= 0, isTrue);
    });
  });

  group('상태 · 온도', () {
    test('라이트 상태·온도가 출처(tokens.css)와 같다', () {
      _expectColorParity(light, <String, Color>{
        '--ok': XkColor.ok,
        '--warn': XkColor.warn,
        '--bad': XkColor.bad,
        '--warm': XkColor.warm,
        '--cool': XkColor.cool,
      }, 'XkColor 상태·온도를 tokens.css 라이트 값으로 맞춰라.');
    });
    test('다크 상태·온도가 출처(tokens.css)와 같다', () {
      _expectColorParity(darkAll, <String, Color>{
        '--ok': XkColor.darkOk,
        '--warn': XkColor.darkWarn,
        '--bad': XkColor.darkBad,
        '--warm': XkColor.darkWarm,
        '--cool': XkColor.darkCool,
      }, 'XkColor 상태·온도를 tokens.css 다크 값으로 맞춰라.');
    });
  });

  group('곡률 · 간격 · 모션', () {
    test('radius 사다리가 출처(tokens.css)와 같다', () {
      final Map<String, double> pairs = <String, double>{
        '--r-panel': XkRadius.panel,
        '--r-card': XkRadius.card,
        '--r-inset': XkRadius.inset,
        '--r-ctl': XkRadius.ctl,
        '--r-tag': XkRadius.tag,
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
      expect(mismatched, isEmpty, reason: 'XkRadius 를 tokens.css 값으로 맞춰라.');
    });
    test('v3 radius 별칭이 v4 값과 같다', () {
      expect(XkRadius.sm, XkRadius.inset);
      expect(XkRadius.md, XkRadius.panel);
      expect(XkRadius.lg, XkRadius.panel);
      expect(XkRadius.pill, XkRadius.ctl);
    });
    test('spacing 사다리가 출처(tokens.css)와 같다', () {
      final Map<String, double> pairs = <String, double>{
        '--sp-1': XkLayout.spacingXxs,
        '--sp-2': XkLayout.spacingXs,
        '--sp-3': XkLayout.spacingSm,
        '--sp-4': XkLayout.spacingMd,
        '--sp-5': XkLayout.spacingLg,
        '--sp-6': XkLayout.spacing2xl,
        '--sp-7': XkLayout.spacing3xl,
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
    test('motion 이 출처(tokens.css)와 같다', () {
      expect(XkMotion.state, _cssDuration(light['--t-state']!));
      expect(XkMotion.hover, _cssDuration(light['--t-hover']!));
      expect(XkMotion.observe, XkMotion.hover);
      expect(XkMotion.resolve, XkMotion.hover);
      expect(XkMotion.settle, XkMotion.state);
    });
  });

  group('서체', () {
    test('XkFont sans/serif/mono 는 전부 Pretendard', () {
      expect(XkFont.sans, 'Pretendard');
      expect(XkFont.serif, 'Pretendard');
      expect(XkFont.mono, 'Pretendard');
    });
    test('헤드라인 굵기는 500, 소제목 600, 본문 400 — 700 없음', () {
      expect(XkTypo.display.fontWeight, FontWeight.w500);
      expect(XkTypo.h1.fontWeight, FontWeight.w500);
      expect(XkTypo.h3.fontWeight, FontWeight.w600);
      expect(XkTypo.body.fontWeight, FontWeight.w400);
      expect(
        XkTypo.display.fontWeight!.value <= FontWeight.w600.value,
        isTrue,
      );
    });
  });

  group('커버리지', () {
    const Set<String> mirrored = <String>{
      '--fs-display',
      '--fs-display-mobile',
      '--fs-section',
      '--fs-page',
      '--fs-title',
      '--fs-body',
      '--fs-body-mobile',
      '--fs-small',
      '--fs-caption',
      '--fs-label',
      '--canvas',
      '--ground-hi',
      '--ink',
      '--ink-2',
      '--ink-3',
      '--rule',
      '--aqua-100',
      '--aqua-tint',
      '--aqua-hi',
      '--aqua',
      '--aqua-mid',
      '--aqua-shade',
      '--aqua-deep',
      '--aqua-ink',
      '--glass',
      '--glass-strong',
      '--glass-edge',
      '--glass-edge-2',
      '--spec',
      '--inset-bg',
      '--head-glass',
      '--ok',
      '--warn',
      '--bad',
      '--warm',
      '--cool',
      '--r-panel',
      '--r-card',
      '--r-inset',
      '--r-ctl',
      '--r-tag',
      '--sp-1',
      '--sp-2',
      '--sp-3',
      '--sp-4',
      '--sp-5',
      '--sp-6',
      '--sp-7',
      '--t-state',
      '--t-hover',
    };
    const Map<String, String> notMirrored = <String, String>{
      '--font': 'XkFont.sans = Pretendard',
      '--fs-section-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--fs-page-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--fs-title-mobile': 'Flutter 앱의 반응형 테마와 레이아웃에서 대응',
      '--leading-body': 'XkLayout.leadingBody',
      '--leading-heading': 'XkLayout.leadingHeading',
      '--content-width': 'XkLayout.contentWidth',
      '--reading-width': 'XkLayout.readingWidth',
      '--section-space': 'XkLayout.sectionSpace',
      '--section-space-mobile': 'XkLayout.sectionSpaceMobile',
      '--gutter': 'XkLayout.gutter',
      '--gutter-mobile': 'XkLayout.gutterMobile',
      '--control-height': 'XkLayout.controlHeight',
      '--ease-out': 'XkMotionToken.easeOut Cubic 근사',
      '--ease-sweep': 'XkMotionToken.easeSweep Cubic 근사',
      '--glass-shadow': 'XkShadow.glass List<BoxShadow> 로 미러 (색·offset 별도 대조)',
    };
    test('출처 라이트 블록의 모든 토큰이 미러링되거나 이유가 적혀 있다', () {
      final Set<String> unaccounted = light.keys
          .where(
            (String n) => !mirrored.contains(n) && !notMirrored.containsKey(n),
          )
          .toSet();
      expect(
        unaccounted,
        isEmpty,
        reason: '정본에 새 토큰이 생겼다. 미러하거나 notMirrored 에 이유를 적어라.',
      );
    });
    test('mirrored 에 적힌 이름이 출처 tokens.css 에 실제로 있다', () {
      final Set<String> stale =
          mirrored.where((String n) => !light.containsKey(n)).toSet();
      expect(stale, isEmpty, reason: '정본에서 사라진 토큰이 mirrored 에 남아 있다.');
    });
    test('v3 --x- 이름이 정본 라이트 블록에 없다', () {
      final Set<String> leftover = light.keys
          .where((String n) => n.startsWith('--x-'))
          .toSet();
      expect(leftover, isEmpty, reason: 'v4 정본에 --x- 잔재가 있다.');
    });
  });
}
