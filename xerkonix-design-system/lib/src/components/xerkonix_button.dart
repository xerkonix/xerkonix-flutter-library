import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';
import '../tactile/tactile_button.dart';
import '../tactile/tactile_primary_button.dart';

/// XERKONIX buttons. Primary / former gem factories = TACTILE
/// `.btn.btn-primary`. Support / tonal / outline / text = `.btn-secondary`
/// / `.btn-quiet` / `.btn-text`. No aqua gem path.
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
  final bool expanded;
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
      semanticColor: XkColor.ink2,
      expanded: expanded,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.primary ||
        buttonType == ButtonType.action ||
        buttonType == ButtonType.accent ||
        buttonType == ButtonType.point ||
        buttonType == ButtonType.pointElevated ||
        buttonType == ButtonType.brand) {
      return XkTactilePrimaryButton(
        onPressed: onPressed,
        expanded: expanded,
        child: child,
      );
    }
    if (buttonType == ButtonType.semantic || semanticColor != null) {
      return XkTactileButton(
        onPressed: onPressed,
        expanded: expanded,
        kind: XkTactileButtonKind.secondary,
        semanticFill: _resolvedSemanticFill(context),
        semanticRole: _semanticRoleName,
        child: child,
      );
    }
    final XkTactileButtonKind kind = switch (buttonType) {
      ButtonType.outline || ButtonType.pointOutline => XkTactileButtonKind.quiet,
      ButtonType.pointText => XkTactileButtonKind.text,
      _ => XkTactileButtonKind.secondary,
    };
    return XkTactileButton(
      onPressed: onPressed,
      expanded: expanded,
      kind: kind,
      child: child,
    );
  }

  String? get _semanticRoleName {
    if (semanticColor == XkColor.ok) {
      return 'success';
    }
    if (semanticColor == XkColor.warn) {
      return 'warning';
    }
    if (semanticColor == XkColor.bad) {
      return 'error';
    }
    if (semanticColor == XkColor.ink2) {
      return 'info';
    }
    return 'custom';
  }

  Color? _resolvedSemanticFill(BuildContext context) {
    final Color? raw = semanticColor;
    if (raw == null) {
      return null;
    }
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    if (raw == XkColor.ok) {
      return dark ? XkColor.darkOk : XkColor.ok;
    }
    if (raw == XkColor.warn) {
      return dark ? XkColor.darkWarn : XkColor.warn;
    }
    if (raw == XkColor.bad) {
      return dark ? XkColor.darkBad : XkColor.bad;
    }
    if (raw == XkColor.ink2) {
      return dark ? XkColor.darkInk2 : XkColor.ink2;
    }
    return raw;
  }
}

class AnimatedTranslate extends StatelessWidget {
  const AnimatedTranslate({
    super.key,
    required this.offset,
    required this.child,
  });

  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: XkMotion.hover,
      curve: XkMotionToken.easeOut,
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0),
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
  point,
  pointOutline,
  pointText,
  pointElevated,
}
