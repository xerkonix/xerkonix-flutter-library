import 'package:flutter/material.dart';

import '../palette/color.dart';

/// Motion token values from XERKONIX DS v1.1
class XkMotionToken {
  XkMotionToken._();

  static const Duration observe = Duration(milliseconds: 160);
  static const Duration interpret = Duration(milliseconds: 230);
  static const Duration connect = Duration(milliseconds: 300);

  static const Duration statusBreath = Duration(milliseconds: 2600);
  static const Duration signalSweep = Duration(milliseconds: 2600);
  static const Duration waveDrift = Duration(milliseconds: 3800);
  static const Duration focusRipple = Duration(milliseconds: 2200);
  static const Duration cardSettle = Duration(milliseconds: 2800);
  static const Duration alertBeat = Duration(milliseconds: 1900);

  static const Curve ease = Cubic(0.2, 0, 0.1, 1);
  static const Curve spring = Cubic(0.34, 1.35, 0.64, 1);
}

/// Motion widgets for common DS effects.
class XkMotion {
  XkMotion._();

  /// Status Breath animation (v1.1 default: 2.6s)
  static Widget breathingLight({
    Duration duration = XkMotionToken.statusBreath,
    double minOpacity = 0.35,
    double maxOpacity = 1.0,
    Color? color,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return _BreathingLight(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      color: color ?? XkColor.identity,
      respectReducedMotion: respectReducedMotion,
      child: child,
    );
  }

  /// Alert Beat / signal pulse animation.
  static Widget pulse({
    Duration duration = XkMotionToken.alertBeat,
    Curve curve = XkMotionToken.ease,
    Color? primaryColor,
    Color? secondaryColor,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return _PulseAnimation(
      duration: duration,
      curve: curve,
      primaryColor: primaryColor ?? XkColor.identity,
      secondaryColor: secondaryColor ?? XkColor.signal,
      respectReducedMotion: respectReducedMotion,
      child: child,
    );
  }
}

class _BreathingLight extends StatefulWidget {
  const _BreathingLight({
    required this.child,
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
    required this.color,
    required this.respectReducedMotion,
  });

  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final Color color;
  final bool respectReducedMotion;

  @override
  State<_BreathingLight> createState() => _BreathingLightState();
}

class _BreathingLightState extends State<_BreathingLight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: XkMotionToken.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.respectReducedMotion && reducedMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.primaryColor,
    required this.secondaryColor,
    required this.respectReducedMotion,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color primaryColor;
  final Color secondaryColor;
  final bool respectReducedMotion;

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color2;
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.respectReducedMotion && reducedMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final blendedColor = _blend(
          widget.primaryColor,
          widget.secondaryColor,
          _animation.value,
        );

        return ColorFiltered(
          colorFilter: ColorFilter.mode(blendedColor, BlendMode.modulate),
          child: widget.child,
        );
      },
    );
  }
}
