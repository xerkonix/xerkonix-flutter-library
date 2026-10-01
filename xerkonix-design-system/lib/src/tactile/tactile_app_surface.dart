import 'package:flutter/material.dart';

import 'tactile_theme.dart';
import 'tactile_tokens.dart';

// Product screen v4 widgets (DS `tactile/app-surface.css`,
// `flutter/APP_SURFACE_MAPPING.md`). Colours come from
// [XkTactileAppSurface] and [XkTactileTokens]; motion constants are checked
// by `tools/build_tactile_theme_roles.py` against the CSS.
//
// The ink first-impression plane (`.app-intro`), the brand-word gradient and
// the completion light were retired on 2026-10-01 (DS §5 · §11). The only
// dark faces are the two emphasis-dark bands below.

/// Which of the two emphasis-dark bands (DS §5) a [XkTactileEmphasisDark] is.
enum XkTactileEmphasisDarkKind {
  /// The coSchema canvas focus panel — web `.app-canvas-focus[data-theme=dark]`
  /// (`emphasisDarkCanvas`). Only the working surface is dark; the panels,
  /// navigation and results around it stay light.
  canvasFocus,

  /// The page footer — web `.app-footer[data-theme=dark]`
  /// (`emphasisDarkFooter`).
  footer,
}

/// Emphasis-dark band — web `[data-theme="dark"]` scoped to one element.
///
/// **Two places only**: the coSchema canvas focus panel and the footer
/// (`emphasisDarkCanvas` / `emphasisDarkFooter` in the mapping table). No
/// other dark face: not a hero, a card, a login or a dashboard head.
///
/// Inside, the subtree sees [XkTactileTheme.themeData] for
/// [Brightness.dark], so every TACTILE widget reads the
/// `[data-theme="dark"]` token block of `tactile/tokens.css` — `--canvas`
/// `#111111`, `--ink` `#F5F5F5`, `--accent` `#65C9D9`, `--muted` `#AEB4BD` —
/// and the primary button inverts to the dark monochrome pair. Nothing is
/// painted that the token block does not name.
class XkTactileEmphasisDark extends StatelessWidget {
  const XkTactileEmphasisDark({
    super.key,
    required this.kind,
    required this.child,
    this.padding,
  });

  final XkTactileEmphasisDarkKind kind;
  final Widget child;

  /// Defaults: canvas focus 24 on every side (CSS `padding: 24px`); footer
  /// CSS `clamp(32px, 5vw, 56px) clamp(24px, 5vw, 56px)` resolved from the
  /// layout width.
  final EdgeInsetsGeometry? padding;

  static EdgeInsets _defaultPadding(XkTactileEmphasisDarkKind kind, double w) {
    switch (kind) {
      case XkTactileEmphasisDarkKind.canvasFocus:
        return const EdgeInsets.all(24);
      case XkTactileEmphasisDarkKind.footer:
        final double vw = w * 0.05;
        return EdgeInsets.symmetric(
          vertical: vw.clamp(32.0, 56.0),
          horizontal: vw.clamp(24.0, 56.0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.dark;
    final ThemeData dark = XkTactileTheme.themeData(Brightness.dark);
    final BorderRadius radius = kind == XkTactileEmphasisDarkKind.canvasFocus
        ? BorderRadius.circular(XkTactileTokens.panelRadius)
        : BorderRadius.zero;
    return Theme(
      data: dark,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          final double w = box.hasBoundedWidth
              ? box.maxWidth
              : MediaQuery.sizeOf(context).width;
          return ClipRRect(
            borderRadius: radius,
            child: DecoratedBox(
              key: ValueKey<String>('xk-tactile-emphasis-dark-${kind.name}'),
              decoration: BoxDecoration(color: t.canvas, borderRadius: radius),
              child: Material(
                type: MaterialType.transparency,
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: t.ink),
                  child: IconTheme.merge(
                    data: IconThemeData(color: t.ink),
                    child: Padding(
                      padding: padding ?? _defaultPadding(kind, w),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Human review plane — web `.app-review`.
///
/// For information a person must confirm. Put the reason in words with a
/// label painted in [XkTactileAppSurface.humanReviewLabel] (e.g.
/// `확인 필요 · 금액 차이`). Not an error or danger state.
class XkTactileHumanReview extends StatelessWidget {
  const XkTactileHumanReview({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    return DecoratedBox(
      key: const ValueKey<String>('xk-tactile-human-review'),
      decoration: BoxDecoration(
        color: s.humanReviewSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: s.humanReviewBorder),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// One quiet opacity entrance after a real screen change — web
/// `.app-view[data-enter]`.
///
/// Wrap the new screen's body. Plays once when first built: 180 ms
/// `cubic-bezier(.2,0,0,1)`, opacity only. Not tied to scroll or timers.
/// With `MediaQuery.disableAnimations` the child shows at once (0 ms).
class XkTactileRouteFade extends StatefulWidget {
  const XkTactileRouteFade({super.key, required this.child});

  final Widget child;

  /// `--app-view-duration`.
  static const Duration routeFadeDuration = Duration(milliseconds: 180);

  /// `--app-view-ease`.
  static const Cubic routeFadeCurve = Cubic(0.2, 0, 0, 1);

  @override
  State<XkTactileRouteFade> createState() => _XkTactileRouteFadeState();
}

class _XkTactileRouteFadeState extends State<XkTactileRouteFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: XkTactileRouteFade.routeFadeDuration,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _c,
    curve: XkTactileRouteFade.routeFadeCurve,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      _c.value = 1;
      _started = true;
    } else if (!_started) {
      _started = true;
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}
