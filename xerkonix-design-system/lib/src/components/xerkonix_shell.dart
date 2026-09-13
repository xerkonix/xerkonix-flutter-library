import 'package:flutter/material.dart';

import '../icons/xerkonix_icon.dart';
import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_button.dart';
import 'xerkonix_glass.dart';

class XkNavDestination {
  const XkNavDestination({
    required this.label,
    this.icon,
  });

  final String label;
  final XkIconName? icon;
}

/// Compact sidebar. Selected row uses [XkSelected] aqua tint, not a filled rail.
class XkNavRail extends StatelessWidget {
  const XkNavRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onSelect,
    this.width = 196,
  });

  final List<XkNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onSelect;
  final double width;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return SizedBox(
      width: width,
      child: XkGlass(
        role: XkGlassRole.navigation,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 0; i < destinations.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: XkListRow(
                  label: destinations[i].label,
                  icon: destinations[i].icon,
                  selected: i == selectedIndex,
                  onTap: onSelect == null ? null : () => onSelect!(i),
                  showChevron: false,
                  surface: false,
                  ink: selectedIndex == i
                      ? XkColor.inkOf(b)
                      : XkColor.ink2Of(b),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class XkListRow extends StatelessWidget {
  const XkListRow({
    super.key,
    required this.label,
    this.subtitle,
    this.icon,
    this.selected = false,
    this.onTap,
    this.showChevron = true,
    this.ink,
    this.surface = true,
  });

  final String label;
  final String? subtitle;
  final XkIconName? icon;
  final bool selected;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? ink;
  /// Reading glass panel. Nav items inside [XkNavRail] set this false.
  final bool surface;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final Color labelColor = ink ?? XkColor.inkOf(b);
    final BorderRadius radius =
        surface ? XkRadius.cardBorderRadius : XkRadius.ctlBorderRadius;
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            XkIcon(icon!, size: 16, color: labelColor),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: XkTypo.body.copyWith(color: labelColor)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: XkTypo.hint.copyWith(color: XkColor.ink2Of(b)),
                  ),
              ],
            ),
          ),
          if (showChevron)
            XkIcon(XkIconName.chevRight, size: 16, color: XkColor.ink3Of(b)),
        ],
      ),
    );
    Widget body = XkSelected(
      selected: selected,
      borderRadius: radius,
      child: row,
    );
    if (surface) {
      body = XkGlass(
        role: XkGlassRole.reading,
        borderRadius: radius,
        padding: EdgeInsets.zero,
        child: body,
      );
    }
    return _Activate(
      enabled: onTap != null,
      selected: selected,
      onTap: onTap,
      borderRadius: radius,
      child: body,
    );
  }
}

class XkTabs extends StatelessWidget {
  const XkTabs({
    super.key,
    required this.labels,
    required this.index,
    this.onSelect,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return Wrap(
      children: <Widget>[
        for (int i = 0; i < labels.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _Activate(
              enabled: onSelect != null,
              selected: i == index,
              onTap: onSelect == null ? null : () => onSelect!(i),
              borderRadius: XkRadius.ctlBorderRadius,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    labels[i],
                    style: XkTypo.label.copyWith(
                      color: i == index ? XkColor.inkOf(b) : XkColor.ink2Of(b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 2,
                    width: 28,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: i == index
                            ? XkColor.inkOf(b)
                            : XkColor.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class XkDialog extends StatelessWidget {
  const XkDialog({
    super.key,
    required this.title,
    required this.body,
    this.primaryLabel = '확인',
    this.secondaryLabel = '취소',
    this.onPrimary,
    this.onSecondary,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
    String primaryLabel = '확인',
    String secondaryLabel = '취소',
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: XkColor.ink.withValues(alpha: 0.18),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: XkColor.none,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: XkDialog(
            title: title,
            body: body,
            primaryLabel: primaryLabel,
            secondaryLabel: secondaryLabel,
            onPrimary: onPrimary ?? () => Navigator.of(ctx).pop(),
            onSecondary: onSecondary ?? () => Navigator.of(ctx).pop(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final Size view = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: view.width < 420 ? view.width : 420,
        maxHeight: view.height * 0.85,
      ),
      child: XkGlass(
        borderRadius: XkRadius.panelBorderRadius,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              style: XkTypo.h3.copyWith(color: XkColor.inkOf(b)),
              softWrap: true,
            ),
            const SizedBox(height: 8),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Text(
                  body,
                  style: XkTypo.body.copyWith(color: XkColor.ink2Of(b)),
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                XkButton.support(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel, softWrap: true),
                ),
                XkButton.primary(
                  onPressed: onPrimary,
                  child: Text(primaryLabel, softWrap: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Activate extends StatefulWidget {
  const _Activate({
    required this.enabled,
    required this.selected,
    required this.borderRadius,
    required this.child,
    this.onTap,
  });

  final bool enabled;
  final bool selected;
  final BorderRadius borderRadius;
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_Activate> createState() => _ActivateState();
}

class _ActivateState extends State<_Activate> {
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final Widget ring = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: _focus ? XkColor.aquaDeepOf(b) : XkColor.none,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: widget.child,
      ),
    );
    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      child: widget.enabled
          ? FocusableActionDetector(
              mouseCursor: SystemMouseCursors.click,
              onFocusChange: (bool has) => setState(() => _focus = has),
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (ActivateIntent intent) {
                    widget.onTap?.call();
                    return null;
                  },
                ),
                ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                  onInvoke: (ButtonActivateIntent intent) {
                    widget.onTap?.call();
                    return null;
                  },
                ),
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                child: ring,
              ),
            )
          : ring,
    );
  }
}
