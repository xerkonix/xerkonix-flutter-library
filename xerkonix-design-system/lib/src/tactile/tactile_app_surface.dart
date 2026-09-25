import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tactile_theme.dart';
import 'tactile_tokens.dart';

// Product screen version 6-B widgets (DS `tactile/app-surface.css`,
// `flutter/APP_SURFACE_MAPPING.md`). Colours come from
// [XkTactileAppSurface]; motion constants are checked by
// `tools/build_tactile_theme_roles.py` against the CSS.

/// CSS `linear-gradient(100deg, …)`: 90° (to the right) plus 10° clockwise.
const GradientRotation _cssGradient100deg = GradientRotation(
  10 * math.pi / 180,
);

class _XkAppIntroScope extends InheritedWidget {
  const _XkAppIntroScope({required this.roles, required super.child});

  final XkTactileAppSurface roles;

  @override
  bool updateShouldNotify(_XkAppIntroScope oldWidget) =>
      roles != oldWidget.roles;
}

/// Ink first-impression plane — web `.app-intro`.
///
/// Use only at **login, an empty state, a dashboard head, or payment
/// completion**, once per screen. Ordinary forms, tables, cards, and
/// checkout steps stay on [XkTactileSurface] (`.panel`).
///
/// Inside the plane, text and icons read [XkTactileAppSurface.onAppIntro],
/// [XkTactilePrimaryButton] and Material filled/elevated buttons invert to
/// `appIntroPrimary*`, Material text buttons and [XkTactileButton] `text`
/// use `appIntroLink`, [XkTactileButton] `quiet` uses `onAppIntro` with the
/// [borderOf] edge, [XkTactileButton] `secondary` keeps its light face, and
/// keyboard focus on all of them uses `appIntroFocusRing`. Use `appIntroBody` for secondary copy and
/// `onAppIntroAccent` for a short label. [XkTactileBrandWord] may add one
/// brand word.
///
/// No scroll hook, no loop. [completion] adds the single Aquamarine light
/// pass (`.app-completion`, 1400 ms ease-in-out, once) when the completed
/// state first appears; with `MediaQuery.disableAnimations` it is not
/// painted.
class XkTactileAppIntro extends StatelessWidget {
  const XkTactileAppIntro({
    super.key,
    required this.child,
    this.padding,
    this.completion = false,
  });

  final Widget child;

  /// Defaults to CSS `clamp(24px, 5vw, 56px)` on every side.
  final EdgeInsetsGeometry? padding;

  /// Payment completion or another completed first impression. The light
  /// plays once when this becomes true.
  final bool completion;

  /// `.app-completion::after` animation length.
  static const Duration completionSheenDuration = Duration(milliseconds: 1400);

  /// `--radius-md`.
  static const double radius = 16;

  /// Ink-plane roles when [context] is inside an [XkTactileAppIntro].
  static XkTactileAppSurface? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_XkAppIntroScope>()
        ?.roles;
  }

  /// `.app-intro` border — `color-mix(in srgb, --app-ink-text 14%, --app-ink)`.
  /// A formula inside the `appIntroSurface` row, not a separate role.
  static Color borderOf(XkTactileAppSurface roles) {
    return Color.lerp(roles.appIntroSurface, roles.onAppIntro, 0.14)!;
  }

  static ThemeData _inkTheme(ThemeData base, XkTactileAppSurface s) {
    const Color clear = XkTactileTokens.clear;
    final ButtonStyle primary = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> st) {
        if (st.contains(WidgetState.disabled)) {
          return s.appIntroPrimaryFill.withValues(
            alpha: XkTactileTokens.disabledOpacity,
          );
        }
        return st.contains(WidgetState.hovered)
            ? s.appIntroPrimaryHover
            : s.appIntroPrimaryFill;
      }),
      foregroundColor: WidgetStatePropertyAll<Color>(s.appIntroPrimaryText),
      overlayColor: const WidgetStatePropertyAll<Color>(clear),
      elevation: const WidgetStatePropertyAll<double>(0),
      shadowColor: const WidgetStatePropertyAll<Color>(clear),
      side: WidgetStateProperty.resolveWith((Set<WidgetState> st) {
        if (st.contains(WidgetState.focused)) {
          return BorderSide(
            color: s.appIntroFocusRing,
            width: XkTactileTokens.focusOutlineWidth,
          );
        }
        return BorderSide(
          color: st.contains(WidgetState.hovered)
              ? s.appIntroPrimaryHover
              : s.appIntroPrimaryFill,
        );
      }),
      minimumSize: const WidgetStatePropertyAll<Size>(
        Size(48, XkTactileTokens.controlHeight),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XkTactileTokens.controlRadius),
        ),
      ),
    );
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: s.appIntroPrimaryFill,
        onPrimary: s.appIntroPrimaryText,
        secondary: s.onAppIntro,
        onSecondary: s.appIntroSurface,
        surface: s.appIntroSurface,
        onSurface: s.onAppIntro,
        outline: borderOf(s),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: s.onAppIntro,
        displayColor: s.onAppIntro,
      ),
      iconTheme: base.iconTheme.copyWith(color: s.onAppIntro),
      focusColor: clear,
      filledButtonTheme: FilledButtonThemeData(style: primary),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primary),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(s.appIntroLink),
          overlayColor: const WidgetStatePropertyAll<Color>(clear),
          side: WidgetStateProperty.resolveWith(
            (Set<WidgetState> st) => st.contains(WidgetState.focused)
                ? BorderSide(
                    color: s.appIntroFocusRing,
                    width: XkTactileTokens.focusOutlineWidth,
                  )
                : BorderSide.none,
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            (base.textTheme.labelLarge ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: s.appIntroLink,
            ),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(44, XkTactileTokens.controlHeight),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(s.onAppIntro),
          overlayColor: const WidgetStatePropertyAll<Color>(clear),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final XkTactileAppSurface s = XkTactileAppSurface.of(context);
    final ThemeData base = Theme.of(context);
    final double width = MediaQuery.maybeSizeOf(context)?.width ?? 480;
    final EdgeInsetsGeometry pad =
        padding ?? EdgeInsets.all((width * 0.05).clamp(24.0, 56.0));
    final BorderRadius r = BorderRadius.circular(radius);

    Widget body = Padding(
      padding: pad,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: s.onAppIntro),
        child: IconTheme.merge(
          data: IconThemeData(color: s.onAppIntro),
          child: child,
        ),
      ),
    );
    // Always a Stack, so flipping [completion] only adds or removes the
    // light layer and never remounts [child] (its state survives).
    // passthrough keeps the parent constraints on [child].
    body = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        body,
        if (completion)
          Positioned.fill(
            child: IgnorePointer(
              child: _CompletionSheen(tint: s.completionSheen),
            ),
          ),
      ],
    );

    return _XkAppIntroScope(
      roles: s,
      child: Theme(
        data: _inkTheme(base, s),
        child: DecoratedBox(
          key: const ValueKey<String>('xk-tactile-app-intro'),
          decoration: BoxDecoration(
            color: s.appIntroSurface,
            borderRadius: r,
            border: Border.all(color: borderOf(s)),
          ),
          child: ClipRRect(borderRadius: r, child: body),
        ),
      ),
    );
  }
}

/// One pass of the Aquamarine completion light. Matches the CSS keyframes:
/// translateX −100% → 100% over the whole run, opacity 0 → 1 (25%) → 1
/// (70%) → 0, ease-in-out per keyframe segment, `fill-mode: both`.
class _CompletionSheen extends StatefulWidget {
  const _CompletionSheen({required this.tint});

  final Color tint;

  @override
  State<_CompletionSheen> createState() => _CompletionSheenState();
}

class _CompletionSheenState extends State<_CompletionSheen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: XkTactileAppIntro.completionSheenDuration,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      // Reduced motion: no light at all, stopped at the end state.
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

  static double _opacity(double v) {
    const Curve ease = Curves.easeInOut;
    if (v < 0.25) {
      return ease.transform(v / 0.25);
    }
    if (v < 0.70) {
      return 1;
    }
    return 1 - ease.transform((v - 0.70) / 0.30);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? _) {
        final double v = _c.value;
        if (v <= 0 || v >= 1) {
          return const SizedBox.expand();
        }
        final double x = -1 + 2 * Curves.easeInOut.transform(v);
        return FractionalTranslation(
          key: const ValueKey<String>('xk-tactile-completion-sheen'),
          translation: Offset(x, 0),
          child: Opacity(
            opacity: _opacity(v).clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  transform: _cssGradient100deg,
                  // Transparent stops keep the tint hue (CSS interpolates
                  // premultiplied; transparent black would grey the edge).
                  colors: <Color>[
                    widget.tint.withValues(alpha: 0),
                    widget.tint,
                    widget.tint.withValues(alpha: 0),
                  ],
                  stops: const <double>[0.28, 0.50, 0.72],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}

/// Single-hue brand word — web `.app-brand-gradient`.
///
/// **One place per screen**, a short word inside [XkTactileAppIntro] only.
/// One Aquamarine hue (`appIntroBrandWord` stops); no multi-colour or
/// background gradient. Both stops keep AA contrast on the ink plane.
/// Outside the ink plane this asserts in debug builds.
class XkTactileBrandWord extends StatelessWidget {
  const XkTactileBrandWord(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final XkTactileAppSurface? roles = XkTactileAppIntro.maybeOf(context);
    assert(() {
      if (roles == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('XkTactileBrandWord must sit inside XkTactileAppIntro.'),
          ErrorDescription(
            'The brand word gradient is for the ink first-impression plane '
            'only (login, empty state, dashboard head, payment completion).',
          ),
        ]);
      }
      return true;
    }());
    final XkTactileAppSurface s = roles ?? XkTactileAppSurface.of(context);
    return ShaderMask(
      key: const ValueKey<String>('xk-tactile-brand-word'),
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
        transform: _cssGradient100deg,
        colors: s.appIntroBrandWord,
      ).createShader(bounds),
      child: Text(
        text,
        // Solid fallback is the first stop (CSS `color: --app-ink-accent`).
        style: (style ?? const TextStyle()).copyWith(color: s.onAppIntroAccent),
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
