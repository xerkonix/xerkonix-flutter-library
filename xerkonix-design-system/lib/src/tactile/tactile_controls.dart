import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'tactile_surface.dart';
import 'tactile_tokens.dart';

/// TACTILE checkbox · radio · switch (DS #119). Use these, not a plain
/// Material [Checkbox] / [Radio] / [Switch]: only these meet the edge and
/// focus rules.
///
/// Thin wrappers over the Material widgets, themed by [XkTactileTheme]:
/// edge `--input-border`, hover ink, checked / on `--control-on`. Keyboard
/// focus keeps the edge as it is and draws a separate 2px `--focus-ring`
/// ring 2px outside the painted box (`outline:2px solid var(--focus-ring);
/// outline-offset:2px`).
///
/// The radio ring and the switch track edge are painted here, not by
/// Material: the round edge's outer bound is put on device pixel
/// boundaries, so on a 1x screen at a fractional position the pixel just
/// outside is the ground, not a half-strength fringe of the edge.
/// The checkbox edge is [XkTactileEdgeShape] (straight sides on whole
/// device pixels) from the theme.
///
/// Painted box inside the Material widget (centred): checkbox 18×18 r2,
/// radio ring outer ⌀20 (2 wide, dot ⌀9), switch track 52×32 (Material 3).
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
    return _XkToggleChrome(
      shape: const Size.square(18),
      radius: 2,
      enabled: onChanged != null,
      edge: null,
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
    final bool on = RadioGroup.maybeOf<T>(context)?.groupValue == value;
    final bool live = enabled ?? (RadioGroup.maybeOf<T>(context) != null);
    return _XkToggleChrome(
      shape: const Size.square(20),
      radius: 10,
      enabled: live,
      edge: (bool hover) => _XkEdgePaint(
        color: _edge(t, <WidgetState>{
          if (on) WidgetState.selected,
          if (hover) WidgetState.hovered,
        }),
        dot: on ? t.controlOn : null,
      ),
      child: Radio<T>(
        value: value,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        overlayColor: _noOverlay,
        // Ring and dot are painted by the wrapper (pixel-aligned).
        fillColor: const WidgetStatePropertyAll<Color>(XkTactileTokens.clear),
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
    return _XkToggleChrome(
      shape: const Size(52, 32),
      radius: 16,
      enabled: onChanged != null,
      outward: true,
      edge: (bool hover) => _XkEdgePaint(
        color: _edge(t, <WidgetState>{
          if (value) WidgetState.selected,
          if (hover) WidgetState.hovered,
        }),
      ),
      child: Switch(
        value: value,
        onChanged: onChanged,
        autofocus: autofocus,
        focusNode: focusNode,
        overlayColor: _noOverlay,
        // The track edge is painted by the wrapper (pixel-aligned).
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          XkTactileTokens.clear,
        ),
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

class _XkEdgePaint {
  const _XkEdgePaint({required this.color, this.dot});

  final Color color;

  /// Radio dot colour when chosen.
  final Color? dot;

  @override
  bool operator ==(Object other) =>
      other is _XkEdgePaint && other.color == color && other.dot == dot;

  @override
  int get hashCode => Object.hash(color, dot);
}

/// Tracks keyboard focus and hover inside [child]; paints the wrapper's own
/// edge (when [edge] is set) and the separate focus ring around the centred
/// painted box, both with the outer bound on device pixel boundaries.
class _XkToggleChrome extends StatefulWidget {
  const _XkToggleChrome({
    required this.shape,
    required this.radius,
    required this.enabled,
    required this.edge,
    required this.child,
    this.outward = false,
  });

  final Size shape;
  final double radius;
  final bool enabled;

  /// Own edge by hover state, or null when Material paints the edge.
  final _XkEdgePaint Function(bool hover)? edge;

  /// Snap the edge box outward (contains Material's own fill) instead of to
  /// the nearest device pixel.
  final bool outward;
  final Widget child;

  @override
  State<_XkToggleChrome> createState() => _XkToggleChromeState();
}

class _XkToggleChromeState extends State<_XkToggleChrome> {
  bool _focused = false;
  bool _hover = false;
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
    final _XkEdgePaint? edge = widget.edge?.call(_hover && widget.enabled);
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: (bool next) {
        if (next != _focused) {
          setState(() => _focused = next);
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: _XkSnappedChrome(
          key: show ? const ValueKey<String>('xk-toggle-focus-ring') : null,
          shape: widget.shape,
          radius: widget.radius,
          outward: widget.outward,
          dpr: MediaQuery.devicePixelRatioOf(context),
          edge: edge == null
              ? null
              : _XkEdgePaint(
                  color: widget.enabled
                      ? edge.color
                      : edge.color.withValues(
                          alpha: XkTactileTokens.disabledOpacity,
                        ),
                  dot: edge.dot,
                ),
          ring: show ? t.focusRing : null,
          child: widget.child,
        ),
      ),
    );
  }
}

class _XkSnappedChrome extends SingleChildRenderObjectWidget {
  const _XkSnappedChrome({
    super.key,
    required this.shape,
    required this.radius,
    required this.outward,
    required this.dpr,
    required this.edge,
    required this.ring,
    super.child,
  });

  final Size shape;
  final double radius;
  final bool outward;
  final double dpr;
  final _XkEdgePaint? edge;
  final Color? ring;

  @override
  _RenderXkSnappedChrome createRenderObject(BuildContext context) {
    return _RenderXkSnappedChrome(shape, radius, outward, dpr, edge, ring);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderXkSnappedChrome renderObject,
  ) {
    renderObject
      ..shape = shape
      ..radius = radius
      ..outward = outward
      ..dpr = dpr
      ..edge = edge
      ..ring = ring;
  }
}

class _RenderXkSnappedChrome extends RenderProxyBox {
  _RenderXkSnappedChrome(
    this._shape,
    this._radius,
    this._outward,
    this._dpr,
    this._edge,
    this._ring,
  );

  Size _shape;
  set shape(Size v) {
    if (v != _shape) {
      _shape = v;
      markNeedsPaint();
    }
  }

  double _radius;
  set radius(double v) {
    if (v != _radius) {
      _radius = v;
      markNeedsPaint();
    }
  }

  bool _outward;
  set outward(bool v) {
    if (v != _outward) {
      _outward = v;
      markNeedsPaint();
    }
  }

  double _dpr;
  set dpr(double v) {
    if (v != _dpr) {
      _dpr = v;
      markNeedsPaint();
    }
  }

  _XkEdgePaint? _edge;
  set edge(_XkEdgePaint? v) {
    if (v != _edge) {
      _edge = v;
      markNeedsPaint();
    }
  }

  Color? _ring;
  set ring(Color? v) {
    if (v != _ring) {
      _ring = v;
      markNeedsPaint();
    }
  }

  /// [box] (local) moved so its outer bound sits on device pixel
  /// boundaries: nearest, or outward to contain it.
  Rect _snap(Rect box, Offset global) {
    final double d = _dpr;
    double lo(double v) => _outward ? v.floorToDouble() : v.roundToDouble();
    double hi(double v) => _outward ? v.ceilToDouble() : v.roundToDouble();
    final double l = (global.dx + box.left) * d;
    final double t = (global.dy + box.top) * d;
    final double w = _outward
        ? hi((global.dx + box.right) * d) - lo(l)
        : (box.width * d).roundToDouble();
    final double h = _outward
        ? hi((global.dy + box.bottom) * d) - lo(t)
        : (box.height * d).roundToDouble();
    return Rect.fromLTWH(
      lo(l) / d - global.dx,
      lo(t) / d - global.dy,
      w / d,
      h / d,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final _XkEdgePaint? edge = _edge;
    final Color? ring = _ring;
    if (edge == null && ring == null) {
      return;
    }
    final Rect box = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: _shape.width,
      height: _shape.height,
    );
    final Rect snapped = _snap(box, localToGlobal(Offset.zero));
    final Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    const double w = 2;
    if (edge != null) {
      final RRect outer = RRect.fromRectAndRadius(
        snapped,
        Radius.circular(math.min(_radius, snapped.shortestSide / 2)),
      );
      canvas.drawRRect(
        outer.deflate(w / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w
          ..color = edge.color,
      );
      final Color? dot = edge.dot;
      if (dot != null) {
        canvas.drawCircle(snapped.center, 4.5, Paint()..color = dot);
      }
    }
    if (ring != null) {
      const double gap =
          XkTactileTokens.inputFocusRingOffset +
          XkTactileTokens.inputFocusRingWidth;
      final Rect r = snapped.inflate(gap);
      final RRect outer = RRect.fromRectAndRadius(
        r,
        Radius.circular(math.min(_radius + gap, r.shortestSide / 2)),
      );
      canvas.drawRRect(
        outer.deflate(XkTactileTokens.inputFocusRingWidth / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = XkTactileTokens.inputFocusRingWidth
          ..color = ring,
      );
    }
    canvas.restore();
  }
}
