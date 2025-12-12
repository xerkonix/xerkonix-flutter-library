import 'package:flutter/material.dart';

import '../palette/color.dart';

/// Motion System
/// The Pulse (호흡) - 생명체가 숨을 쉬듯 부드럽게 명멸
class XkMotion {
  XkMotion._();

  /// Breathing Light Animation
  /// AI(Cosentio)가 연산을 할 때, Identity Color와 Pulse Color가 섞이며
  /// 마치 생명체가 숨을 쉬듯 부드럽게 명멸(Pulse)합니다.
  static Widget breathingLight({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    double minOpacity = 0.3,
    double maxOpacity = 1.0,
    Color? color,
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
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    Color? primaryColor,
    Color? secondaryColor,
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
    required this.child,
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
    required this.color,
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
    required this.child,
    required this.duration,
    required this.primaryColor,
    required this.secondaryColor,
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

