import 'package:flutter/material.dart';

import '../palette/color.dart';

/// A full-screen dual-ring spinner with a centered gradient dot and a message,
/// drawn over a dimmed backdrop. Covers the product `CosentioLoadingOverlay`.
///
/// Intended to be placed in a `Stack` (it returns a `Positioned.fill`). Renders
/// nothing when [visible] is false.
class XkLoadingOverlay extends StatelessWidget {
  const XkLoadingOverlay({
    super.key,
    required this.message,
    required this.visible,
  });

  final String message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? XkColor.darkBg : XkColor.bg;
    final Color accent = isDark ? XkColor.darkAccent : XkColor.accent;
    final Color accentDeep = isDark ? XkColor.darkAccentDeep : XkColor.accentDeep;
    return Positioned.fill(
      child: ColoredBox(
        color: bg.withValues(alpha: 0.92),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 84,
                height: 84,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _SpinRing(color: accent),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: _SpinRing(
                        color: accent.withValues(alpha: 0.5),
                        reverse: true,
                        duration: const Duration(milliseconds: 1700),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[accent, accentDeep],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: accent.withValues(alpha: 0.5),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  message,
                  key: ValueKey<String>(message),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpinRing extends StatefulWidget {
  const _SpinRing({
    required this.color,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 1100),
  });

  final Color color;
  final bool reverse;
  final Duration duration;

  @override
  State<_SpinRing> createState() => _SpinRingState();
}

class _SpinRingState extends State<_SpinRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      // Halt the endlessly-repeating rotation ticker and show a static ring
      // (value: null keeps the OS-level indeterminate indicator, which the
      // platform itself renders without motion when animations are disabled).
      if (_controller.isAnimating) {
        _controller.stop();
      }
      return CircularProgressIndicator(strokeWidth: 1.5, color: widget.color);
    }
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
    return RotationTransition(
      turns: Tween<double>(
        begin: 0,
        end: widget.reverse ? -1 : 1,
      ).animate(_controller),
      child: CircularProgressIndicator(strokeWidth: 1.5, color: widget.color),
    );
  }
}
