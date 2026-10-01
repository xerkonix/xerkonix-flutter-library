// XK Sans KR 번들 계약 — 글꼴 내부 이름(OFL 예약 이름), 로더 경로 ↔ 복사기 매니페스트,
// 소비 앱 모양(<app>/assets/fonts/xk_sans_kr + pubspec assets). 형제 소비 리포가 있으면
// 실제 사본·pubspec 까지 본다. 건너뜀은 없다 — 형제가 없으면 매니페스트가 적은 모양을 본다.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

/// `name` 테이블의 문자열을 모두 읽는다 (platform 0/3: UTF-16BE, 1: 바이트 그대로).
Map<int, List<String>> _nameTable(Uint8List bytes) {
  final ByteData d = ByteData.sublistView(bytes);
  final int numTables = d.getUint16(4);
  int nameOffset = -1;
  int nameLength = 0;
  for (int i = 0; i < numTables; i++) {
    final int rec = 12 + i * 16;
    final String tag = ascii.decode(bytes.sublist(rec, rec + 4));
    if (tag == 'name') {
      nameOffset = d.getUint32(rec + 8);
      nameLength = d.getUint32(rec + 12);
    }
  }
  expect(nameOffset, greaterThan(0), reason: 'name 테이블이 없다');
  final int count = d.getUint16(nameOffset + 2);
  final int stringOffset = nameOffset + d.getUint16(nameOffset + 4);
  final Map<int, List<String>> out = <int, List<String>>{};
  for (int i = 0; i < count; i++) {
    final int r = nameOffset + 6 + i * 12;
    final int platform = d.getUint16(r);
    final int id = d.getUint16(r + 6);
    final int len = d.getUint16(r + 8);
    final int off = stringOffset + d.getUint16(r + 10);
    final Uint8List raw = bytes.sublist(off, off + len);
    String s;
    if (platform == 0 || platform == 3) {
      final List<int> units = <int>[];
      for (int k = 0; k + 1 < raw.length; k += 2) {
        units.add((raw[k] << 8) | raw[k + 1]);
      }
      s = String.fromCharCodes(units);
    } else {
      s = latin1.decode(raw);
    }
    out.putIfAbsent(id, () => <String>[]).add(s);
  }
  expect(nameLength, greaterThan(0));
  return out;
}

void main() {
  final File fontFile = File(XkTactileFonts.packageFilePath);
  final Map<String, dynamic> manifest =
      jsonDecode(File('../tools/tactile_font_mirrors.json').readAsStringSync())
          as Map<String, dynamic>;

  test('글꼴 내부 이름은 XK Sans KR 이고 예약 이름 Pretendard 는 고지 항목에만 남는다', () {
    final Map<int, List<String>> names = _nameTable(fontFile.readAsBytesSync());
    for (final int id in <int>[1, 4, 16]) {
      expect(names[id], isNotNull, reason: 'name ID $id');
      for (final String s in names[id]!) {
        expect(s, 'XK Sans KR', reason: 'name ID $id');
      }
    }
    expect(names[6]!.toSet(), <String>{'XKSansKR'});
    // 0 저작권 · 7 상표 · 10 설명 · 13/14 라이선스 — OFL 이 유지하라는 고지. 그 밖에는 금지.
    const Set<int> notices = <int>{0, 7, 10, 13, 14};
    names.forEach((int id, List<String> values) {
      if (notices.contains(id)) return;
      for (final String s in values) {
        expect(s.toLowerCase(), isNot(contains('pretendard')), reason: 'name ID $id: $s');
      }
    });
    expect(names[0]!.join(' '), contains('Kil Hyung-jin'));
    expect(names[13]!.join(' '), contains('SIL Open Font License'));
    expect(XkTactileFonts.family, 'XK Sans KR');
  });

  test('로더 경로와 복사기 매니페스트는 한 문자열이다', () {
    expect(manifest['asset_dir'], XkTactileFonts.assetDir);
    expect(XkTactileFonts.assetDir, 'assets/fonts/xk_sans_kr');
    expect(XkTactileFonts.assetPath, '${XkTactileFonts.assetDir}/${XkTactileFonts.fileName}');
    expect((manifest['files'] as List<dynamic>).contains(XkTactileFonts.fileName), isTrue);
    expect(manifest['source'], 'xerkonix-design-system/lib/fonts/xk_sans_kr');
    expect(XkTactileFonts.packageFilePath, 'lib/fonts/xk_sans_kr/${XkTactileFonts.fileName}');
    expect(
      XkTactileFonts.packageAssetPath,
      'packages/xerkonix_design_system/${XkTactileFonts.packageFilePath}',
    );
    expect(fontFile.lengthSync(), lessThan(1000000));
  });

  group('소비 앱 모양 — <app>/assets/fonts/xk_sans_kr + pubspec assets', () {
    final Map<String, dynamic> consumers =
        manifest['consumers'] as Map<String, dynamic>;
    final String assetDir = XkTactileFonts.assetDir;

    bool pubspecDeclares(String text) {
      final RegExp item = RegExp(r'^\s*-\s*(\S+)\s*$', multiLine: true);
      return item.allMatches(text).any((RegExpMatch m) =>
          m.group(1) == '$assetDir/' || m.group(1) == XkTactileFonts.assetPath);
    }

    for (final String consumer in <String>['cotact', 'concierge']) {
      test('$consumer: 매니페스트 모양이 로더 경로와 맞고, 형제 리포가 있으면 사본·pubspec 도 맞다', () {
        final Map<String, dynamic> spec = consumers[consumer] as Map<String, dynamic>;
        final String app = spec['app'] as String;
        expect(app, isNotEmpty);
        // 모양: 사본 폴더 = <app>/<assetDir>, pubspec = <app>/pubspec.yaml — 둘 다 로더 문자열에서 나온다.
        final String copyDir = '$app/$assetDir';
        expect(copyDir.endsWith(assetDir), isTrue);
        expect(copyDir, isNot(contains('assets/$assetDir')), reason: 'assets 가 두 번 들어가면 키가 어긋난다');
        final Directory sibling = Directory('../../$consumer/$app');
        if (!sibling.existsSync()) {
          // 형제 없음(CI): 매니페스트 모양만 확인했다 — 사본 검사는 sync_tactile_fonts.py --check 가 한다.
          return;
        }
        final File pubspec = File('${sibling.path}/pubspec.yaml');
        expect(pubspec.existsSync(), isTrue, reason: pubspec.path);
        expect(pubspecDeclares(pubspec.readAsStringSync()), isTrue,
            reason: '$consumer pubspec 에 `$assetDir/` 가 없다');
        final File copy = File('${sibling.path}/$assetDir/${XkTactileFonts.fileName}');
        expect(copy.existsSync(), isTrue, reason: copy.path);
        expect(copy.readAsBytesSync(), fontFile.readAsBytesSync(), reason: '$consumer 사본이 원본과 다르다');
      });
    }
  });
}
