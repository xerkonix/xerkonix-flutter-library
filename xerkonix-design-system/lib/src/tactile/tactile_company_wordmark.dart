import 'package:flutter/material.dart';

/// Public-page company chrome. One approved wordmark, home is XERKONIX.
///
/// Consumes DS `assets/brand/wordmark-ink.png` / `wordmark-paper.png`
/// (no new art). Product names stay on the product surface.
class XkCompanyWordmark extends StatelessWidget {
  const XkCompanyWordmark({
    super.key,
    required this.onOpenHome,
    this.height = 14,
  });

  static const String homeUrl = 'https://xerkonix.com/';
  static const String assetInk = 'assets/brand/wordmark-ink.png';
  static const String assetPaper = 'assets/brand/wordmark-paper.png';

  /// Gap so a fixed footer hairline does not sit on the last scroll line.
  static const double foldClearance = 12;

  static const String semanticsLabel = 'XERKONIX 홈';

  final VoidCallback onOpenHome;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: TextButton(
        onPressed: onOpenHome,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          minimumSize: Size(88, height + 8),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Image.asset(
          dark ? assetPaper : assetInk,
          height: height,
          filterQuality: FilterQuality.medium,
          errorBuilder: (BuildContext context, Object error, StackTrace? st) {
            return Image.asset(
              dark ? assetPaper : assetInk,
              package: 'xerkonix_design_system',
              height: height,
              filterQuality: FilterQuality.medium,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? st) {
                return Text(
                  'XERKONIX',
                  style: TextStyle(
                    fontSize: height,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.35,
                    height: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
