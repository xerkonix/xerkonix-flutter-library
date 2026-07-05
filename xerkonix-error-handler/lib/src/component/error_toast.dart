import 'dart:async';

import 'package:flutter/material.dart';

/// Severity used to colour the toast/snackbar.
enum XkToastSeverity { error, warning, info }

/// A top-sliding overlay toast with auto-dismiss, at parity with the product's
/// `showCosentioToast`. Colours are configurable so apps can pass their own
/// theme tokens (defaults follow Material error/warn semantics).
///
/// Prefer the [showXkToast] helper over instantiating this directly.
class XkErrorToast extends StatefulWidget {
  const XkErrorToast({
    super.key,
    required this.message,
    required this.onDone,
    this.severity = XkToastSeverity.error,
    this.accentColor,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.displayDuration = const Duration(milliseconds: 2800),
  });

  final String message;
  final VoidCallback onDone;
  final XkToastSeverity severity;
  final Color? accentColor;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Duration displayDuration;

  @override
  State<XkErrorToast> createState() => _XkErrorToastState();
}

class _XkErrorToastState extends State<XkErrorToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _timer = Timer(widget.displayDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) {
      widget.onDone();
      return;
    }
    await _controller.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _accent {
    if (widget.accentColor != null) return widget.accentColor!;
    switch (widget.severity) {
      case XkToastSeverity.error:
        return Colors.red.shade400;
      case XkToastSeverity.warning:
        return Colors.orange.shade400;
      case XkToastSeverity.info:
        return Colors.blueGrey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = _accent;
    final Color bg =
        widget.backgroundColor ?? accent.withValues(alpha: 0.14);
    final Color fg = widget.textColor ?? accent;
    final bool showIcon = widget.severity != XkToastSeverity.info;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: _dismiss,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accent),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (showIcon) ...<Widget>[
                            Icon(
                              widget.icon ?? Icons.error_outline,
                              size: 18,
                              color: accent,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.message,
                              style: TextStyle(color: fg),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tracks the currently-visible overlay toast so a new one replaces it.
OverlayEntry? _activeXkToast;

/// Shows a top-sliding [XkErrorToast]. Falls back to a [SnackBar] when no
/// [Overlay] is available (parity with `showCosentioToast`).
void showXkToast(
  BuildContext context,
  String message, {
  XkToastSeverity severity = XkToastSeverity.error,
  Color? accentColor,
  Color? backgroundColor,
  Color? textColor,
  IconData? icon,
  Duration displayDuration = const Duration(milliseconds: 2800),
}) {
  final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) {
    showXkSnackBar(
      context,
      message,
      severity: severity,
      backgroundColor: backgroundColor,
    );
    return;
  }
  _activeXkToast?.remove();
  _activeXkToast = null;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext ctx) => XkErrorToast(
      message: message,
      severity: severity,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      displayDuration: displayDuration,
      onDone: () {
        if (_activeXkToast == entry) {
          _activeXkToast = null;
        }
        entry.remove();
      },
    ),
  );
  _activeXkToast = entry;
  overlay.insert(entry);
}

/// Shows the error message via [ScaffoldMessenger] as a [SnackBar].
void showXkSnackBar(
  BuildContext context,
  String message, {
  XkToastSeverity severity = XkToastSeverity.error,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final Color bg = backgroundColor ??
      (severity == XkToastSeverity.error
          ? Colors.red.shade600
          : severity == XkToastSeverity.warning
              ? Colors.orange.shade700
              : Colors.blueGrey.shade700);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: bg,
      duration: duration,
      action: action,
    ),
  );
}
