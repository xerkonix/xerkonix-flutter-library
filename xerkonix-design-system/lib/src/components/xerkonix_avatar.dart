import 'package:flutter/material.dart';

import '../palette/color.dart';

/// An initials avatar on a name-derived gradient, in the shape of a rounded
/// square (radius scales with [size]). Covers the product `PersonAvatar`.
///
/// The gradient is chosen deterministically from [name] so the same person
/// always gets the same color, and it respects light/dark.
class XkAvatar extends StatelessWidget {
  const XkAvatar({
    super.key,
    required this.name,
    this.size = 44,
  });

  final String name;
  final double size;

  static const List<List<Color>> _lightGradients = <List<Color>>[
    <Color>[XkColor.accent, XkColor.accentDeep],
    <Color>[Color(0xFF5E8F7B), Color(0xFF3E4462)],
    <Color>[Color(0xFF6F779D), Color(0xFF3D46A8)],
    <Color>[Color(0xFFB08954), Color(0xFF565D80)],
    <Color>[Color(0xFF4B5DC3), Color(0xFF292E45)],
  ];

  static const List<List<Color>> _darkGradients = <List<Color>>[
    <Color>[XkColor.darkAccent, XkColor.darkAccentDeep],
    <Color>[Color(0xFF7FB59E), Color(0xFF565D80)],
    <Color>[Color(0xFF8C93B8), Color(0xFFA5B0F0)],
    <Color>[Color(0xFFD3A96E), Color(0xFF6F779D)],
    <Color>[Color(0xFF8E9BE6), Color(0xFF3E4462)],
  ];

  String get _initial {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed.characters.first.toUpperCase();
  }

  int get _bucket {
    if (name.isEmpty) {
      return 0;
    }
    int hash = 0;
    for (final int unit in name.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<List<Color>> palettes =
        isDark ? _darkGradients : _lightGradients;
    final List<Color> colors = palettes[_bucket % palettes.length];
    final Color onColor =
        isDark ? XkColor.darkAccentText : XkColor.accentText;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        _initial,
        style: TextStyle(
          color: onColor,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
