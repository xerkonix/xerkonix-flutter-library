import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// A centered loading spinner pane. Covers the admin `LoadingPane`.
class XkLoadingPane extends StatelessWidget {
  const XkLoadingPane({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// A centered, muted "nothing here" message. Covers the admin `EmptyPane`.
class XkEmptyPane extends StatelessWidget {
  const XkEmptyPane({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color muted = isDark ? XkColor.darkTextMuted : XkColor.textMuted;
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color error = isDark ? XkColor.darkError : XkColor.error;
    final Color surface = isDark ? XkColor.darkSurface : XkColor.surface;
    final Color border = isDark ? XkColor.darkBorder : XkColor.border;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: XkShape.mdBorderRadius,
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error_outline, color: error),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
