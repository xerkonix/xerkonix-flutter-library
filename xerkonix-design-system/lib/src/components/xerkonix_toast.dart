import 'dart:async';

import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

OverlayEntry? _activeXkToast;

/// Toast/notice that slides down from the top (errors and notices appear at the
/// top, not the bottom). Tap to dismiss; auto-dismisses after a few seconds.
/// Set [isError] for failures so they show in the error (warn) color.
///
/// Falls back to a [SnackBar] when no [Overlay] is available. Covers the
/// product `showCosentioToast`.
void showXkToast(BuildContext context, String message, {bool isError = false}) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isDark ? XkColor.darkSurface2 : XkColor.surface2,
      ),
    );
    return;
  }
  _activeXkToast?.remove();
  _activeXkToast = null;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext ctx) => XkToast(
      message: message,
      isError: isError,
      isDark: isDark,
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

/// The top-sliding toast surface used by [showXkToast]. Exposed so callers can
/// embed it directly (e.g. in tests or custom overlays); most code should call
/// [showXkToast] instead.
class XkToast extends StatefulWidget {
  const XkToast({
    super.key,
    required this.message,
    required this.onDone,
    this.isError = false,
    this.isDark = false,
  });

  final String message;
  final VoidCallback onDone;
  final bool isError;
  final bool isDark;

  @override
  State<XkToast> createState() => _XkToastState();
}

class _XkToastState extends State<XkToast> with SingleTickerProviderStateMixin {
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
    _timer = Timer(const Duration(milliseconds: 2800), _dismiss);
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

  @override
  Widget build(BuildContext context) {
    final bool dark = widget.isDark;
    final bool err = widget.isError;
    final Color warn = dark ? XkColor.darkError : XkColor.error;
    final Color surface2 = dark ? XkColor.darkSurface2 : XkColor.surface2;
    final Color line = dark ? XkColor.darkBorder : XkColor.border;
    final Color text = dark ? XkColor.darkTextStrong : XkColor.textStrong;
    final Color accent = err ? warn : line;
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
                        color: err ? warn.withValues(alpha: 0.14) : surface2,
                        borderRadius: XkShape.mdBorderRadius,
                        border: Border.all(color: accent),
                        boxShadow: XkShadow.lifted(
                          dark ? Brightness.dark : Brightness.light,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (err) ...<Widget>[
                            Icon(Icons.error_outline, size: 18, color: warn),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.message,
                              style: TextStyle(color: err ? warn : text),
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
