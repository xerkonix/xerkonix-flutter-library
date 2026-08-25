import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_neumorphic.dart';

/// XERKONIX TACTILE button component.
///
/// Every variant renders as a neumorphic surface: extruded (paired
/// highlight + lowlight) at rest and pressed *into* the canvas (inner shadow)
/// while held, so the press reads physically.
///
/// Variants:
/// - primary   (strong ink fill)
/// - action    (default CTA · ink accent · `cta` alias)
/// - brand     (softer ink, brand-identity moments)
/// - support   (recommended / stable · success)
/// - accent    (editorial emphasis · ink accent)
/// - tonal     (raised neutral surface)
/// - outline   (flat, bordered)
///
/// TACTILE policy: the default CTA is `action`. In TACTILE the accent is a
/// monochrome ink, so emphasis is carried by elevation, not hue.
class XkButton extends StatelessWidget {
  const XkButton._({
    super.key,
    required this.onPressed,
    required this.buttonType,
    this.semanticColor,
    this.expanded = false,
    this.gradient = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonType buttonType;
  final Color? semanticColor;

  /// When true, the button stretches to fill the available width.
  final bool expanded;

  /// When true, a gradient accent fill is used (see [XkButton.primaryGradient]).
  final bool gradient;

  factory XkButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.primary,
      expanded: expanded,
      child: child,
    );
  }

  /// Gradient-filled accent CTA. Full-width by default.
  factory XkButton.primaryGradient({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = true,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      gradient: true,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.action({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.cta({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.action(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.brand({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.brand,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.support({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.support,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.accent({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.accent,
      expanded: expanded,
      child: child,
    );
  }

  /// [v2.4] 포인트 필드 — 아쿠아마린 필 + 표면색 글자(두 테마 AA).
  factory XkButton.point({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.point,
      expanded: expanded,
      child: child,
    );
  }

  /// [v2.4] 포인트 아웃라인 — 1.5px 포인트 테두리 + 포인트 잉크.
  factory XkButton.pointOutline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointOutline,
      expanded: expanded,
      child: child,
    );
  }

  /// [v2.4] 포인트 텍스트 버튼 — 포인트 잉크만, 면·그림자 없음.
  factory XkButton.pointText({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointText,
      expanded: expanded,
      child: child,
    );
  }

  /// [v2.4] 포인트 엘리베이티드 — 뉴모픽 융기 면 + 포인트 잉크.
  factory XkButton.pointElevated({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointElevated,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.tonal({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.tonal,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.outline,
      expanded: expanded,
      child: child,
    );
  }

  // Backward-compatible alias
  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.outline(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.success({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.success,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.warning({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.warning,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.error,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.info({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.gray600,
      expanded: expanded,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _XkButtonSpec spec = _resolveSpec(isDark);

    Widget button = _NeumorphicButton(
      onPressed: onPressed,
      fill: spec.fill,
      gradient: gradient ? spec.gradient : null,
      textColor: spec.textColor,
      border: spec.border,
      elevated: spec.elevated,
      disabledFill: isDark ? XkColor.darkSurface2 : XkColor.gray400,
      disabledTextColor: isDark ? XkColor.darkTextMuted : XkColor.textMuted,
      child: child,
    );
    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  _XkButtonSpec _resolveSpec(bool isDark) {
    switch (buttonType) {
      case ButtonType.primary:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkTextStrong : XkColor.textStrong,
          textColor: isDark ? XkColor.darkBg : XkColor.bg,
        );
      case ButtonType.action:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkAccent : XkColor.accent,
          textColor: isDark ? XkColor.darkAccentText : XkColor.accentText,
          gradient: LinearGradient(
            colors: isDark
                ? const <Color>[XkColor.darkAccent, XkColor.darkAccentDeep]
                : const <Color>[XkColor.accent, XkColor.accentDeep],
          ),
        );
      case ButtonType.brand:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
          textColor: isDark ? XkColor.darkAccentText : XkColor.accentText,
        );
      case ButtonType.support:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkSuccess : XkColor.success,
          textColor: isDark ? XkColor.darkBg : XkColor.accentText,
        );
      case ButtonType.accent:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkAccent : XkColor.accent,
          textColor: isDark ? XkColor.darkAccentText : XkColor.accentText,
        );
      case ButtonType.tonal:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkSurface2 : XkColor.surface,
          textColor: isDark ? XkColor.darkTextStrong : XkColor.textStrong,
        );
      case ButtonType.point:
        // [v2.4] 필드 글자는 표면색 — 라이트 순백(5.96:1) · 다크 어두운 면(6.21:1).
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkPoint : XkColor.point,
          textColor: isDark ? XkColor.darkSurface : XkColor.surface,
        );
      case ButtonType.pointOutline:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkPoint : XkColor.point,
          border: Border.all(
            width: 1.5,
            color: isDark ? XkColor.darkPoint : XkColor.point,
          ),
          elevated: false,
        );
      case ButtonType.pointText:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkPoint : XkColor.point,
          elevated: false,
        );
      case ButtonType.pointElevated:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkSurface : XkColor.surface,
          textColor: isDark ? XkColor.darkPoint : XkColor.point,
        );
      case ButtonType.outline:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkTextBody : XkColor.textBody,
          border: Border.all(
            color: isDark ? XkColor.darkBorder : XkColor.border,
          ),
          elevated: false,
        );
      case ButtonType.semantic:
        final Color base = XkColor.themed(
          semanticColor!,
          isDark ? Brightness.dark : Brightness.light,
        );
        return _XkButtonSpec(fill: base, textColor: _onColor(base, isDark));
    }
  }

  static Color _onColor(Color color, bool isDark) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? XkColor.accentText
        : (isDark ? XkColor.darkBg : XkColor.textStrong);
  }
}

class _XkButtonSpec {
  const _XkButtonSpec({
    required this.fill,
    required this.textColor,
    this.gradient,
    this.border,
    this.elevated = true,
  });

  final Color fill;
  final Color textColor;
  final Gradient? gradient;
  final BoxBorder? border;

  /// Whether the resting surface casts a raised (extruded) shadow.
  final bool elevated;
}

/// A neumorphic pressable surface used to render every [XkButton] variant.
class _NeumorphicButton extends StatefulWidget {
  const _NeumorphicButton({
    required this.onPressed,
    required this.child,
    required this.fill,
    required this.textColor,
    required this.disabledFill,
    required this.disabledTextColor,
    this.gradient,
    this.border,
    this.elevated = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color fill;
  final Color textColor;
  final Color disabledFill;
  final Color disabledTextColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final bool elevated;

  static const BorderRadius _radius = XkShape.smBorderRadius;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 11,
  );

  @override
  State<_NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _pressed = false;
  bool _hovered = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  void _setHovered(bool value) {
    if (_hovered != value) {
      setState(() => _hovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    final Color fill = _enabled ? widget.fill : widget.disabledFill;
    final Color textColor = _enabled
        ? widget.textColor
        : widget.disabledTextColor;
    final Gradient? gradient = _enabled ? widget.gradient : null;

    final Widget label = DefaultTextStyle.merge(
      textAlign: TextAlign.center,
      style: XkTypo.buttonLabel.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: textColor, size: 18),
        child: Center(widthFactor: 1, child: widget.child),
      ),
    );

    final Widget content = Padding(
      padding: _NeumorphicButton._padding,
      child: label,
    );

    Widget surface;
    if (!_enabled) {
      surface = DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          gradient: gradient,
          borderRadius: _NeumorphicButton._radius,
          border: widget.border,
        ),
        child: content,
      );
    } else if (_pressed) {
      // Pressed → inset. Base fill + inner shadow.
      surface = DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          gradient: gradient,
          borderRadius: _NeumorphicButton._radius,
          border: widget.border,
        ),
        child: CustomPaint(
          foregroundPainter: XkInsetShadowPainter(
            borderRadius: _NeumorphicButton._radius,
            lowlight: isDark
                ? XkShadow.darkLowlight
                : XkColor.textStrong.withValues(alpha: 0.28),
            highlight: isDark
                ? XkColor.darkTextStrong.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.35),
            distance: 3,
            blur: 6,
          ),
          child: content,
        ),
      );
    } else {
      // Resting (and hovered) → raised.
      surface = DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          gradient: gradient,
          borderRadius: _NeumorphicButton._radius,
          border: widget.border,
          boxShadow: widget.elevated
              ? (_hovered
                    ? XkShadow.lifted(brightness)
                    : XkShadow.raised(brightness))
              : null,
        ),
        child: content,
      );
    }

    // FocusableActionDetector: 포커스 노드 + Enter/Space 활성화 + 호버 추적.
    // 예전에는 GestureDetector 뿐이라 웹/데스크톱에서 Tab 이 이 버튼에 닿지
    // 않았고 Enter/Space 로도 눌리지 않았다 — 마우스 없이는 어떤 주요 액션도
    // 실행할 수 없었다(WCAG 2.1.1). 포커스 링은 기존 hover 융기를 재사용한다.
    return Semantics(
      button: true,
      enabled: _enabled,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setHovered,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              widget.onPressed?.call();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 90),
            child: surface,
          ),
        ),
      ),
    );
  }
}

enum ButtonType {
  primary,
  action,
  brand,
  support,
  accent,
  tonal,
  outline,
  semantic,
  // [v2.4] 포인트(아쿠아마린) 4형 — 보조 액션·인터랙티브 강조용.
  // 주 액션(근흑 accent/primary)은 여전히 화면당 1개다.
  point,
  pointOutline,
  pointText,
  pointElevated,
}
