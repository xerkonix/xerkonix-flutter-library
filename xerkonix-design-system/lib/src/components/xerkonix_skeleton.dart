import 'package:flutter/material.dart';

import '../palette/color.dart';
import 'xerkonix_surface_card.dart';

/// A pulsing placeholder block for skeleton loading states — feels faster than a
/// spinner because the screen already shows the shape of the content to come.
class XkSkeleton extends StatefulWidget {
  const XkSkeleton({
    super.key,
    this.height = 14,
    this.width,
    this.radius = 8,
  });

  final double height;

  /// Defaults to `double.infinity` (fill available width) when null.
  final double? width;
  final double radius;

  @override
  State<XkSkeleton> createState() => _XkSkeletonState();
}

class _XkSkeletonState extends State<XkSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color base = isDark ? XkColor.darkTextMuted : XkColor.textMuted;
    final bool reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final Widget block = Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );
    if (reducedMotion) {
      // Stop the ticker rather than leaving it repeating behind a static frame.
      if (_controller.isAnimating) {
        _controller.stop();
      }
      return block;
    }
    if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 0.8).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: block,
    );
  }
}

/// One skeleton card shaped like a person / next-action row (avatar + two lines).
class XkSkeletonCard extends StatelessWidget {
  const XkSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const XkCard(
      child: Row(
        children: <Widget>[
          XkSkeleton(height: 44, width: 44, radius: 22),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                XkSkeleton(height: 13, width: 120),
                SizedBox(height: 10),
                XkSkeleton(height: 11, width: 220),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A column of skeleton cards for first-load / detail-load states.
class XkSkeletonList extends StatelessWidget {
  const XkSkeletonList({
    super.key,
    this.count = 4,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
  });

  final int count;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: count,
      separatorBuilder: (BuildContext _, int _) => const SizedBox(height: 12),
      itemBuilder: (BuildContext _, int _) => const XkSkeletonCard(),
    );
  }
}
