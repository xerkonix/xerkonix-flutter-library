import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Neumorphic surface treatment.
///
/// - [raised]: extruded from the canvas (paired highlight + lowlight drop).
/// - [inset]: pressed into the canvas (paired inner shadow, drawn by
///   [XkInsetShadowPainter] because Flutter cannot express an inset [BoxShadow]).
/// - [flat]: filled surface with a hairline border and no shadow.
enum XkNeumorphicStyle { raised, inset, flat }

/// A neumorphic container — the core TACTILE primitive.
///
/// Material's `CardTheme` / `ButtonStyle` can only express a single outward
/// drop shadow, so they cannot render the dual (highlight + lowlight) or inset
/// treatments TACTILE relies on. [XkNeumorphic] fills that gap: a rounded,
/// theme-aware surface that can be [XkNeumorphicStyle.raised],
/// [XkNeumorphicStyle.inset], or [XkNeumorphicStyle.flat].
///
/// When [onTap] is provided (and [pressable] is true) a resting `raised`
/// surface momentarily presses to `inset` while held, giving physical
/// button-press feedback. For a static surface just omit [onTap].
///
/// The raised decoration alone is also available without a widget via
/// [XkNeumorphic.decoration], for callers that already build their own
/// [BoxDecoration].
class XkNeumorphic extends StatefulWidget {
  const XkNeumorphic({
    super.key,
    required this.child,
    this.style = XkNeumorphicStyle.raised,
    this.borderRadius,
    this.padding = const EdgeInsets.all(XkLayout.spacingMd),
    this.color,
    this.onTap,
    this.pressable = true,
    this.intensity = 1.0,
    this.width,
    this.height,
  });

  final Widget child;
  final XkNeumorphicStyle style;

  /// Corner radius. Defaults to [XkShape.mdBorderRadius].
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  /// Surface fill. Defaults to the theme surface token.
  final Color? color;

  final VoidCallback? onTap;

  /// When true and [onTap] is set, a resting `raised` surface presses to
  /// `inset` while held.
  final bool pressable;

  /// Scales the strength (alpha + offset) of the elevation, `0`..`~1.5`.
  final double intensity;

  final double? width;
  final double? height;

  /// The raised paired-shadow [BoxDecoration] for the given [brightness].
  ///
  /// Only covers the raised treatment — the inset treatment needs an inner
  /// shadow and must go through the [XkNeumorphic] widget / [XkInsetShadowPainter].
  static BoxDecoration decoration({
    required Brightness brightness,
    BorderRadius? borderRadius,
    Color? color,
    double intensity = 1.0,
  }) {
    final bool isDark = brightness == Brightness.dark;
    return BoxDecoration(
      color: color ?? (isDark ? XkColor.darkSurface : XkColor.surface),
      borderRadius: borderRadius ?? XkShape.mdBorderRadius,
      boxShadow: _scaleShadows(XkShadow.raised(brightness), intensity),
    );
  }

  @override
  State<XkNeumorphic> createState() => _XkNeumorphicState();
}

class _XkNeumorphicState extends State<XkNeumorphic> {
  bool _pressed = false;

  bool get _interactive => widget.onTap != null;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final BorderRadius radius = widget.borderRadius ?? XkShape.mdBorderRadius;
    final Color surface =
        widget.color ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final Color hairline = isDark ? XkColor.darkBorder : XkColor.border;

    // A held raised+tappable surface renders as inset for tactile feedback.
    final XkNeumorphicStyle style =
        (_pressed &&
            widget.pressable &&
            _interactive &&
            widget.style == XkNeumorphicStyle.raised)
        ? XkNeumorphicStyle.inset
        : widget.style;

    final Widget content = Padding(
      padding: widget.padding,
      child: widget.child,
    );

    Widget surfaceWidget;
    switch (style) {
      case XkNeumorphicStyle.raised:
        surfaceWidget = DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            boxShadow: _scaleShadows(
              XkShadow.raised(brightness),
              widget.intensity,
            ),
          ),
          child: content,
        );
        break;
      case XkNeumorphicStyle.inset:
        surfaceWidget = DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(color: hairline.withValues(alpha: 0.6)),
          ),
          child: CustomPaint(
            foregroundPainter: XkInsetShadowPainter(
              borderRadius: radius,
              lowlight: isDark ? XkShadow.darkLowlight : XkShadow.lightLowlight,
              highlight: isDark
                  ? XkColor.darkTextStrong.withValues(alpha: 0.05)
                  : XkShadow.lightHighlight,
              intensity: widget.intensity,
            ),
            child: content,
          ),
        );
        break;
      case XkNeumorphicStyle.flat:
        surfaceWidget = DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(color: hairline),
          ),
          child: content,
        );
        break;
    }

    Widget result = SizedBox(
      width: widget.width,
      height: widget.height,
      child: surfaceWidget,
    );

    if (!_interactive) {
      return result;
    }

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
      ),
    );
  }
}

/// Scales the alpha and offset of a paired shadow list by [intensity].
List<BoxShadow> _scaleShadows(List<BoxShadow> shadows, double intensity) {
  if (intensity == 1.0) {
    return shadows;
  }
  final double k = intensity.clamp(0.0, 2.0);
  return <BoxShadow>[
    for (final BoxShadow s in shadows)
      BoxShadow(
        color: s.color.withValues(
          alpha: (s.color.a * k).clamp(0.0, 1.0).toDouble(),
        ),
        offset: s.offset * k,
        blurRadius: s.blurRadius * k,
        spreadRadius: s.spreadRadius,
      ),
  ];
}

/// Paints a neumorphic **inset** (inner) shadow clipped to a rounded rect.
///
/// Flutter's [BoxShadow] only casts outward, so an inset surface — a control
/// pressed *into* the canvas — is emulated here: a lowlight inner shadow along
/// the top-left edge and a highlight along the bottom-right edge, matching the
/// single top-left light source used by [XkShadow].
///
/// Intended as a `foregroundPainter` over a filled, rounded child (see
/// [XkNeumorphic] with [XkNeumorphicStyle.inset], and the TACTILE inputs).
class XkInsetShadowPainter extends CustomPainter {
  const XkInsetShadowPainter({
    required this.borderRadius,
    required this.lowlight,
    required this.highlight,
    this.distance = 4.0,
    this.blur = 9.0,
    this.intensity = 1.0,
  });

  /// Must match the child's clip radius.
  final BorderRadius borderRadius;

  /// Top-left inner shadow color.
  final Color lowlight;

  /// Bottom-right inner highlight color.
  final Color highlight;

  /// Offset magnitude of the inner shadow.
  final double distance;

  /// Blur of the inner shadow.
  final double blur;

  /// Scales [distance] / [blur].
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final double k = intensity.clamp(0.0, 2.0);
    final double d = distance * k;
    final double b = blur * k;
    if (size.isEmpty || d <= 0) {
      return;
    }

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // Filled region = a big rect with the rrect punched out (even-odd). When
    // translated it slides its edge into the clip, leaving a soft crescent.
    final Path punched = Path()
      ..addRect(rect.inflate(d + b + 4))
      ..addRRect(rrect)
      ..fillType = ui.PathFillType.evenOdd;

    // Lowlight along the top-left edge (slide fill toward bottom-right).
    final Paint low = Paint()
      ..color = lowlight
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, b);
    canvas.save();
    canvas.translate(d, d);
    canvas.drawPath(punched, low);
    canvas.restore();

    // Highlight along the bottom-right edge (slide fill toward top-left).
    final Paint high = Paint()
      ..color = highlight
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, b);
    canvas.save();
    canvas.translate(-d, -d);
    canvas.drawPath(punched, high);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant XkInsetShadowPainter old) {
    return old.borderRadius != borderRadius ||
        old.lowlight != lowlight ||
        old.highlight != highlight ||
        old.distance != distance ||
        old.blur != blur ||
        old.intensity != intensity;
  }
}
