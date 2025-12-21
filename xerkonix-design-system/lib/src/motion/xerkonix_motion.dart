import 'package:flutter/material.dart';

import '../palette/color.dart';

/// Motion System
/// Provides smooth pulsing animations for UI components.
class XkMotion {
  XkMotion._();

  /// Breathing Light Animation
  /// Creates a smooth pulsing opacity animation.
  static Widget breathingLight({
    Duration duration = const Duration(seconds: 2),
    double minOpacity = 0.3,
    double maxOpacity = 1.0,
    Color? color,
    required Widget child,
  }) {
    return _BreathingLight(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      color: color ?? XkColor.identity,
      child: child,
    );
  }

  /// Pulse Animation (Identity + Pulse Color Blend)
  static Widget pulse({
    Duration duration = const Duration(seconds: 2),
    Color? primaryColor,
    Color? secondaryColor,
    required Widget child,
  }) {
    return _PulseAnimation(
      duration: duration,
      primaryColor: primaryColor ?? XkColor.identity,
      secondaryColor: secondaryColor ?? XkColor.pulse,
      child: child,
    );
  }
}

class _BreathingLight extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final Color color;

  const _BreathingLight({
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
    required this.color,
    required this.child,
  });

  @override
  State<_BreathingLight> createState() => _BreathingLightState();
}

class _BreathingLightState extends State<_BreathingLight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color primaryColor;
  final Color secondaryColor;

  const _PulseAnimation({
    required this.duration,
    required this.primaryColor,
    required this.secondaryColor,
    required this.child,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _blendColors(Color color1, Color color2, double ratio) {
    return Color.fromRGBO(
      (color1.red + (color2.red - color1.red) * ratio).round(),
      (color1.green + (color2.green - color1.green) * ratio).round(),
      (color1.blue + (color2.blue - color1.blue) * ratio).round(),
      (color1.alpha + (color2.alpha - color1.alpha) * ratio) / 255.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final blendedColor = _blendColors(
          widget.primaryColor,
          widget.secondaryColor,
          _animation.value,
        );
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            blendedColor,
            BlendMode.modulate,
          ),
          child: widget.child,
        );
      },
    );
  }
}

