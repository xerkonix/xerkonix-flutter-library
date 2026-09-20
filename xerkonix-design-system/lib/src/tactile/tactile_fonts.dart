import 'dart:ui' show FontVariation;

import 'package:flutter/services.dart';

/// Loadable face from tactile `tokens.css` `--font`.
///
/// Stack: Inter, -apple-system, BlinkMacSystemFont, Segoe UI,
/// Apple SD Gothic Neo, **Noto Sans CJK KR**, Malgun Gothic, sans-serif.
/// Live Mac Chrome paints `.SF NS` + `Apple SD Gothic Neo` and loads no
/// `@font-face`. CanvasKit cannot use those system names — measured
/// 2026-09-20: declaration-only rasters match the engine default.
///
/// Allowed load: official notofonts/noto-cjk Subset Variable Korean
/// (`lib/fonts/noto_sans_cjk_kr/`, SIL OFL 1.1). Not Inter CDN. Not an
/// extracted Apple face. Not Pretendard (that name is absent from the
/// current stack).
///
/// 450 / 550 are CSS weights. Flutter [FontWeight] has no those values.
/// The actual method is [FontVariation.weight] on this variable font.
class XkTactileFonts {
  XkTactileFonts._();

  /// Family name as written in `tokens.css` `--font`.
  static const String family = 'Noto Sans CJK KR';

  static const String fileName = 'NotoSansKR-VF.ttf';

  /// First existing bundle path wins. Package path is for the library
  /// example; the others are app copies. Not listed in FontManifest —
  /// a 10MB VF in the manifest delays the first frame (same class of
  /// miss as the old 16MB Pretendard set).
  static const List<String> assetCandidates = <String>[
    'packages/xerkonix_design_system/lib/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf',
    'lib/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf',
    'fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf',
    'assets/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf',
  ];

  static const String packageFilePath =
      'lib/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf';

  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static List<FontVariation> variations(double wght) {
    return <FontVariation>[FontVariation.weight(wght)];
  }

  static Future<bool> ensureLoaded() async {
    if (_loaded) {
      return true;
    }
    for (final String asset in assetCandidates) {
      try {
        final ByteData data = await rootBundle.load(asset);
        if (data.lengthInBytes < 100 * 1024) {
          continue;
        }
        final FontLoader loader = FontLoader(family);
        loader.addFont(Future<ByteData>.value(data));
        await loader.load();
        _loaded = true;
        return true;
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  /// Test / tool path: load official bytes without the asset bundle.
  /// Callers that have a [File] pass `ByteData.sublistView(file.readAsBytesSync())`.
  static Future<bool> loadFromBytes(ByteData data) async {
    if (data.lengthInBytes < 100 * 1024) {
      return false;
    }
    final FontLoader loader = FontLoader(family);
    loader.addFont(Future<ByteData>.value(data));
    await loader.load();
    _loaded = true;
    return true;
  }
}
