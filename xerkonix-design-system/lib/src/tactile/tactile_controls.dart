import 'package:flutter/material.dart';

import 'tactile_surface.dart';
import 'tactile_tokens.dart';

/// TACTILE checkbox · radio · switch (DS #119).
///
/// Thin wrappers over the Material widgets, themed by [XkTactileTheme]:
/// edge `--input-border`, hover ink, checked / on `--control-on`. Keyboard
/// focus keeps the edge as it is and draws a separate 2px `--focus-ring`
/// ring 2px outside the painted box (`outline:2px solid var(--focus-ring);
/// outline-offset:2px`) — the theme alone cannot, because a Material toggle
/// has no room for a ring apart from its edge. Plain Material widgets still
/// show focus by an ink edge from the theme.
///
/// Painted box inside the Material widget (centred): checkbox 18×18 r2,
/// radio ring outer ⌀20, switch track 52×32 (Material 3, measured).
class XkCheckbox extends StatelessWidget {
  const XkCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return _XkToggleFocusRing(
      shape: const Size.square(18),
      radius: 2,
      enabled: onChanged != null,
      child: Checkbox(
        value: value,
        tristate: tristate,
        onChanged: onChanged,
        autofocus: autofocus,
        focusNode: focusNode,
        semanticLabel: semanticLabel,
        overlayColor: _noOverlay,
        side: WidgetStateBorderSide.resolveWith(
          (Set<WidgetState> s) => BorderSide(color: _edge(t, s)),
        ),
      ),
    );
  }
}

/// TACTILE radio. Use inside a [RadioGroup]. See [XkCheckbox].
class XkRadio<T> extends StatelessWidget {
  const XkRadio({
    super.key,
    required this.value,
    this.enabled,
    this.autofocus = false,
    this.focusNode,
  });

  final T value;
  final bool? enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return _XkToggleFocusRing(
      shape: const Size.square(20),
      radius: 10,
      enabled: enabled ?? true,
      child: Radio<T>(
        value: value,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        overlayColor: _noOverlay,
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => _edge(t, s),
        ),
      ),
    );
  }
}

/// TACTILE switch. See [XkCheckbox].
class XkSwitch extends StatelessWidget {
  const XkSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return _XkToggleFocusRing(
      shape: const Size(52, 32),
      radius: 16,
      enabled: onChanged != null,
      child: Switch(
        value: value,
        onChanged: onChanged,
        autofocus: autofocus,
        focusNode: focusNode,
        overlayColor: _noOverlay,
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => _edge(t, s),
        ),
        trackOutlineWidth: const WidgetStatePropertyAll<double>(2),
      ),
    );
  }
}

/// No Material radial halo: hover darkens the edge, focus is the ring.
const WidgetStateProperty<Color?> _noOverlay = WidgetStatePropertyAll<Color?>(
  XkTactileTokens.clear,
);

/// Edge colour by state, focus left out (the ring shows focus): checked /
/// on `--control-on`, hover ink, rest `--input-border`.
Color _edge(XkTactileTokens t, Set<WidgetState> s) {
  if (s.contains(WidgetState.selected)) {
    return t.controlOn;
  }
  if (s.contains(WidgetState.hovered) && !s.contains(WidgetState.disabled)) {
    return t.ink;
  }
  return t.inputBorder;
}

/// Tracks keyboard focus inside [child] and paints the separate ring
/// around the centred painted box.
class _XkToggleFocusRing extends StatefulWidget {
  const _XkToggleFocusRing({
    required this.shape,
    required this.radius,
    required this.enabled,
    required this.child,
  });

  final Size shape;
  final double radius;
  final bool enabled;
  final Widget child;

  @override
  State<_XkToggleFocusRing> createState() => _XkToggleFocusRingState();
}

class _XkToggleFocusRingState extends State<_XkToggleFocusRing> {
  bool _focused = false;
  late FocusHighlightMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = FocusManager.instance.highlightMode;
    FocusManager.instance.addHighlightModeListener(_onMode);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onMode);
    super.dispose();
  }

  void _onMode(FocusHighlightMode mode) {
    if (mode != _mode) {
      setState(() => _mode = mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    // Ring on keyboard focus only (`:focus-visible`).
    final bool show =
        _focused && widget.enabled && _mode == FocusHighlightMode.traditional;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: (bool next) {
        if (next != _focused) {
          setState(() => _focused = next);
        }
      },
      child: CustomPaint(
        key: show ? const ValueKey<String>('xk-toggle-focus-ring') : null,
        foregroundPainter: show
            ? _CentredRingPainter(
                shape: widget.shape,
                radius: widget.radius,
                color: t.focusRing,
              )
            : null,
        child: widget.child,
      ),
    );
  }
}

class _CentredRingPainter extends CustomPainter {
  const _CentredRingPainter({
    required this.shape,
    required this.radius,
    required this.color,
  });

  final Size shape;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double gap =
        XkTactileTokens.inputFocusRingOffset +
        XkTactileTokens.inputFocusRingWidth;
    final Rect ring = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: shape.width + 2 * gap,
      height: shape.height + 2 * gap,
    );
    XkTactileEdge(
      color: color,
      width: XkTactileTokens.inputFocusRingWidth,
    ).paint(canvas, ring, borderRadius: BorderRadius.circular(radius + gap));
  }

  @override
  bool shouldRepaint(_CentredRingPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}
