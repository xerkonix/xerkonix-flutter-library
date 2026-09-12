import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';

/// Full-screen LTR bar loader over a dimmed canvas. No spin.
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
    final Brightness b = Theme.of(context).brightness;
    return Positioned.fill(
      child: ColoredBox(
        color: XkColor.canvasOf(b).withValues(alpha: 0.92),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const XkLoader(semanticLabel: 'loading'),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: XkMotion.hover,
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
      ),
    );
  }
}
