import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';
import 'xerkonix_button.dart';
import 'xerkonix_glass.dart';

/// A centered loading spinner pane. Covers the admin `LoadingPane`.
class XkLoadingPane extends StatelessWidget {
  const XkLoadingPane({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: XkLoader(semanticLabel: 'loading'),
      ),
    );
  }
}

/// A centered, muted "nothing here" message. Covers the admin `EmptyPane`.
class XkEmptyPane extends StatelessWidget {
  const XkEmptyPane({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color muted = isDark ? XkColor.darkInk2 : XkColor.ink2;
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
            .copyWith(color: muted),
      ),
    );
  }
}

/// A centered error card with an optional retry action. Covers the admin
/// `ErrorPane` (retry is optional here so it can be used for terminal errors).
class XkErrorPane extends StatelessWidget {
  const XkErrorPane({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = '다시 시도',
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Color error = isDark ? XkColor.darkBad : XkColor.bad;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: XkGlass(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error_outline, color: error),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: 16),
                XkButton.outline(
                  onPressed: onRetry,
                  child: Text(retryLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
