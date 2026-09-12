import 'package:flutter/material.dart';

import '../palette/color.dart';
import 'xerkonix_surface_card.dart';

/// Static placeholder. Pulse/shimmer is gone in v4.
class XkSkeleton extends StatelessWidget {
  const XkSkeleton({
    super.key,
    this.height = 14,
    this.width,
    this.radius = 8,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: XkColor.insetBgOf(b),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: XkColor.ruleOf(b)),
      ),
    );
  }
}

class XkSkeletonCard extends StatelessWidget {
  const XkSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const XkCard(
      child: Row(
        children: <Widget>[
          XkSkeleton(height: 44, width: 44, radius: 12),
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
