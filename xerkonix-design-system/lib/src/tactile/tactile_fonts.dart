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

  /// Default Flutter asset key from pubspec.yaml. Apps with a different
  /// pubspec path pass that key to [ensureLoaded]. On web this default is
  /// requested as `assets/fonts/...`. Keep the 10MB face out of FontManifest
  /// so it loads after first frame.
  static const String assetPath = 'fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf';

  static const String packageFilePath =
      'lib/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf';

  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static List<FontVariation> variations(double wght) {
    return <FontVariation>[FontVariation.weight(wght)];
  }

  static Future<bool> ensureLoaded({String? assetPathOverride}) async {
    if (_loaded) {
      return true;
    }
    try {
      final ByteData data = await rootBundle.load(assetPathOverride ?? assetPath);
      if (data.lengthInBytes < 100 * 1024) {
        return false;
      }
      final FontLoader loader = FontLoader(family);
      loader.addFont(Future<ByteData>.value(data));
      await loader.load();
      _loaded = true;
      return true;
    } catch (_) {
      return false;
    }
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
