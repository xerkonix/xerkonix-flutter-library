import 'package:flutter/widgets.dart';

/// A coarse classification of the available layout width.
///
/// This is intentionally small and orthogonal to the logical-pixel (`lp`)
/// scaling system provided by [Sizer]/[ResponsiveSizer]. Use it to switch
/// between structurally different layouts (e.g. bottom navigation vs. a
/// persistent sidebar) rather than to scale individual dimensions.
enum XkWidthClass {
  /// Narrow viewports (phones, small windows).
  mobile,

  /// Medium viewports (large phones, small tablets, split-view windows).
  tablet,

  /// Wide viewports (tablets in landscape, desktop, large browser windows).
  desktop,
}

/// Named width breakpoints used to derive an [XkWidthClass] from a width.
///
/// The defaults mirror common product conventions:
///
/// * width `< mobile` -> [XkWidthClass.mobile]
/// * `mobile <= width < desktop` -> [XkWidthClass.tablet]
/// * width `>= desktop` -> [XkWidthClass.desktop]
///
/// The boundaries are inclusive on the lower bound (i.e. a width exactly equal
/// to [mobile] is already [XkWidthClass.tablet]). This matches the common
/// product idiom `width >= breakpoint` for "at least this wide".
///
/// Both [mobile] and [desktop] express the *minimum* width, in logical pixels,
/// at which the next class begins.
@immutable
class XkBreakpoints {
  /// Creates a breakpoint configuration.
  ///
  /// [mobile] is the minimum width for [XkWidthClass.tablet] and [desktop] is
  /// the minimum width for [XkWidthClass.desktop]. [desktop] must be greater
  /// than or equal to [mobile].
  const XkBreakpoints({this.mobile = 760, this.desktop = 1080})
    : assert(mobile > 0, 'mobile breakpoint must be positive'),
      assert(
        desktop >= mobile,
        'desktop breakpoint must be >= mobile breakpoint',
      );

  /// The default breakpoints (`mobile = 760`, `desktop = 1080`).
  ///
  /// These align with the product's `breakpointMobile` / `breakpointSidebar`
  /// tokens.
  static const XkBreakpoints defaults = XkBreakpoints();

  /// Minimum width (logical pixels) at which the layout is at least
  /// [XkWidthClass.tablet]. Below this the layout is [XkWidthClass.mobile].
  final double mobile;

  /// Minimum width (logical pixels) at which the layout is
  /// [XkWidthClass.desktop]. Between [mobile] (inclusive) and this the layout
  /// is [XkWidthClass.tablet].
  ///
  /// Also the natural place to switch a sidebar on, matching the product's
  /// `breakpointSidebar` idiom.
  final double desktop;

  /// Classifies [width] (in logical pixels) into an [XkWidthClass].
  XkWidthClass classify(double width) {
    if (width >= desktop) return XkWidthClass.desktop;
    if (width >= mobile) return XkWidthClass.tablet;
    return XkWidthClass.mobile;
  }

  /// Whether [width] is classified as [XkWidthClass.mobile].
  bool isMobile(double width) => classify(width) == XkWidthClass.mobile;

  /// Whether [width] is classified as [XkWidthClass.tablet].
  bool isTablet(double width) => classify(width) == XkWidthClass.tablet;

  /// Whether [width] is classified as [XkWidthClass.desktop].
  bool isDesktop(double width) => classify(width) == XkWidthClass.desktop;

  /// Returns a copy with the given fields replaced.
  XkBreakpoints copyWith({double? mobile, double? desktop}) => XkBreakpoints(
    mobile: mobile ?? this.mobile,
    desktop: desktop ?? this.desktop,
  );

  @override
  bool operator ==(Object other) =>
      other is XkBreakpoints &&
      other.mobile == mobile &&
      other.desktop == desktop;

  @override
  int get hashCode => Object.hash(mobile, desktop);

  @override
  String toString() => 'XkBreakpoints(mobile: $mobile, desktop: $desktop)';
}

/// Classifies a raw [width] using the [XkBreakpoints.defaults] configuration.
///
/// For a custom configuration use [XkBreakpoints.classify].
XkWidthClass xkWidthClass(
  double width, {
  XkBreakpoints breakpoints = XkBreakpoints.defaults,
}) => breakpoints.classify(width);

/// Convenience helpers for reading the current width class off a [BoxConstraints]
/// (e.g. the constraints handed to a [LayoutBuilder] builder).
extension XkBoxConstraintsBreakpoints on BoxConstraints {
  /// The [XkWidthClass] for this constraint's [maxWidth].
  ///
  /// If [maxWidth] is unbounded (`double.infinity`) this returns
  /// [XkWidthClass.desktop], treating "unbounded" as "as wide as it gets".
  XkWidthClass widthClass({
    XkBreakpoints breakpoints = XkBreakpoints.defaults,
  }) {
    final double width = maxWidth.isFinite ? maxWidth : double.maxFinite;
    return breakpoints.classify(width);
  }

  /// Whether [maxWidth] is classified as [XkWidthClass.mobile].
  bool isMobile({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.mobile;

  /// Whether [maxWidth] is classified as [XkWidthClass.tablet].
  bool isTablet({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.tablet;

  /// Whether [maxWidth] is classified as [XkWidthClass.desktop].
  bool isDesktop({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.desktop;
}

/// Convenience helpers for reading the current width class off a [BuildContext]
/// via [MediaQuery].
///
/// These read `MediaQuery.sizeOf(context).width`, so widgets using them rebuild
/// when the media size changes. Prefer [XkBoxConstraintsBreakpoints] inside a
/// [LayoutBuilder] when you care about the size of a sub-tree rather than the
/// whole window.
extension XkContextBreakpoints on BuildContext {
  /// The [XkWidthClass] for the current media width.
  XkWidthClass widthClass({
    XkBreakpoints breakpoints = XkBreakpoints.defaults,
  }) => breakpoints.classify(MediaQuery.sizeOf(this).width);

  /// Whether the current media width is [XkWidthClass.mobile].
  bool isMobile({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.mobile;

  /// Whether the current media width is [XkWidthClass.tablet].
  bool isTablet({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.tablet;

  /// Whether the current media width is [XkWidthClass.desktop].
  bool isDesktop({XkBreakpoints breakpoints = XkBreakpoints.defaults}) =>
      widthClass(breakpoints: breakpoints) == XkWidthClass.desktop;
}

/// Builds a widget from the current [XkWidthClass].
typedef XkWidthClassBuilder =
    Widget Function(BuildContext context, XkWidthClass widthClass);

/// A [LayoutBuilder]-based widget that rebuilds its child whenever the layout
/// crosses a width-class boundary.
///
/// Because it measures the *incoming constraints* it reflects the size of the
/// space this widget is given, which is usually what you want for structural
/// layout decisions. Use the [builder] for full control, or the
/// [mobile]/[tablet]/[desktop] slots for the common case.
///
/// When using the slots, [tablet] falls back to [mobile] and [desktop] falls
/// back to [tablet] (then [mobile]) if not provided, so you only need to supply
/// the layouts that actually differ.
class XkResponsiveLayout extends StatelessWidget {
  /// Creates a responsive layout driven by [builder].
  const XkResponsiveLayout({
    super.key,
    required XkWidthClassBuilder this.builder,
    this.breakpoints = XkBreakpoints.defaults,
  }) : mobile = null,
       tablet = null,
       desktop = null;

  /// Creates a responsive layout that switches between the given per-class
  /// slots.
  ///
  /// At least [mobile] must be provided. [tablet] and [desktop] fall back to
  /// the next-narrower provided slot.
  const XkResponsiveLayout.slots({
    super.key,
    required WidgetBuilder this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoints = XkBreakpoints.defaults,
  }) : builder = null;

  /// The breakpoints used to classify the available width.
  final XkBreakpoints breakpoints;

  /// Full-control builder. Non-null only for the default constructor.
  final XkWidthClassBuilder? builder;

  /// Slot for [XkWidthClass.mobile]. Non-null only for [XkResponsiveLayout.slots].
  final WidgetBuilder? mobile;

  /// Slot for [XkWidthClass.tablet]. May be null (falls back to [mobile]).
  final WidgetBuilder? tablet;

  /// Slot for [XkWidthClass.desktop]. May be null (falls back to [tablet]).
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final XkWidthClass widthClass = constraints.widthClass(
          breakpoints: breakpoints,
        );
        final XkWidthClassBuilder? b = builder;
        if (b != null) return b(context, widthClass);
        return _slotFor(widthClass)(context);
      },
    );
  }

  WidgetBuilder _slotFor(XkWidthClass widthClass) {
    switch (widthClass) {
      case XkWidthClass.desktop:
        return desktop ?? tablet ?? mobile!;
      case XkWidthClass.tablet:
        return tablet ?? mobile!;
      case XkWidthClass.mobile:
        return mobile!;
    }
  }
}
