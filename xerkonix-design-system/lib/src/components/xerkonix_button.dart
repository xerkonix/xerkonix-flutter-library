import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../typography/xerkonix_typography.dart';

/// XERKONIX TACTILE button component.
///
/// The current task uses a solid ink action. Supporting controls use a neutral
/// surface or text. All variants keep native keyboard and disabled semantics.
/// Existing factory names remain callable; primaryGradient renders a solid fill.
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

  /// Existing constructor kept for callers; renders a solid action button.
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
  ///
  /// 주 CTA 가 아닌 **보조 변형**이다. 화면당 근흑 액션(`XkButton.accent`) 1개
  /// 규칙 안에서 포인트 면 채움은 보조 행동에만 쓴다 — TACTILE v2.6 의 "CTA 면을
  /// `--point`/`--gem` 으로 칠하지 않는다" 는 주 CTA 에 대한 규칙이다.
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
      semanticColor: XkColor.ok,
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
      semanticColor: XkColor.warn,
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
      semanticColor: XkColor.bad,
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
      semanticColor: XkColor.muted,
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
      gradient: null,
      textColor: spec.textColor,
      border: spec.border,
      elevated: false,
      disabledFill: isDark ? XkColor.darkWell : XkColor.well,
      disabledTextColor: isDark ? XkColor.darkMuted : XkColor.muted,
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
          fill: isDark ? XkColor.darkInk : XkColor.ink,
          textColor: isDark ? XkColor.darkBg : XkColor.bg,
        );
      case ButtonType.action:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkInk : XkColor.ink,
          textColor: isDark ? XkColor.darkBg : XkColor.bg,
          gradient: LinearGradient(
            colors: isDark
                ? const <Color>[XkColor.darkTintFill, XkColor.darkTintLight]
                : const <Color>[XkColor.tintFill, XkColor.tintTextHover],
          ),
        );
      case ButtonType.brand:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkTintLight : XkColor.tintTextHover,
          textColor: isDark ? XkColor.darkBg : XkColor.bg,
        );
      case ButtonType.support:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkOk : XkColor.ok,
          textColor: isDark ? XkColor.darkBg : XkColor.tintOnFill,
        );
      case ButtonType.accent:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkInk : XkColor.ink,
          textColor: isDark ? XkColor.darkBg : XkColor.bg,
        );
      case ButtonType.tonal:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkHairSoft : XkColor.panel,
          textColor: isDark ? XkColor.darkInk : XkColor.ink,
        );
      case ButtonType.point:
        // [v2.4] 필드 글자는 표면색 — 라이트 순백(5.96:1) · 다크 어두운 면(6.21:1).
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkTintText : XkColor.tintText,
          textColor: isDark ? XkColor.darkPanel : XkColor.panel,
        );
      case ButtonType.pointOutline:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkTintText : XkColor.tintText,
          border: Border.all(
            width: 1.5,
            color: isDark ? XkColor.darkTintText : XkColor.tintText,
          ),
          elevated: false,
        );
      case ButtonType.pointText:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkTintText : XkColor.tintText,
          elevated: false,
        );
      case ButtonType.pointElevated:
        return _XkButtonSpec(
          fill: isDark ? XkColor.darkPanel : XkColor.panel,
          textColor: isDark ? XkColor.darkTintText : XkColor.tintText,
        );
      case ButtonType.outline:
        return _XkButtonSpec(
          fill: Colors.transparent,
          textColor: isDark ? XkColor.darkInk : XkColor.ink,
          border: Border.all(
            color: isDark ? XkColor.darkHair : XkColor.hair,
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
        ? XkColor.tintOnFill
        : (isDark ? XkColor.darkBg : XkColor.ink);
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

/// Native focus, keyboard activation and disabled semantics for all variants.
class _NeumorphicButton extends StatelessWidget {
  const _NeumorphicButton({required this.onPressed, required this.child, required this.fill, required this.textColor, required this.disabledFill, required this.disabledTextColor, this.gradient, this.border, this.elevated = false});
  final VoidCallback? onPressed;
  final Widget child;
  final Color fill, textColor, disabledFill, disabledTextColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final bool elevated;
  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 22, vertical: 14)),
        textStyle: WidgetStatePropertyAll(XkTypo.buttonLabel.copyWith(fontWeight: FontWeight.w600)),
        backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.disabled) ? disabledFill : fill),
        foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.disabled) ? disabledTextColor : textColor),
        shape: WidgetStateProperty.resolveWith((states) => StadiumBorder(side: states.contains(WidgetState.focused) ? BorderSide(color: dark ? XkColor.darkTintText : XkColor.tintText, width: 2) : (border?.top ?? BorderSide.none))),
      ),
      child: child,
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
