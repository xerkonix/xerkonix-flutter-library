import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../palette/color.dart';

/// Weave icon names from the design-system HTML reference.
enum XkIconName {
  chevLeft('chev-left'),
  chevRight('chev-right'),
  chevUp('chev-up'),
  chevDown('chev-down'),
  plus('plus'),
  minus('minus'),
  close('close'),
  check('check'),
  search('search'),
  filter('filter'),
  sort('sort'),
  sliders('sliders'),
  home('home'),
  user('user'),
  users('users'),
  briefcase('briefcase'),
  chartBar('chart-bar'),
  chartLine('chart-line'),
  pie('pie'),
  trendUp('trend-up'),
  bell('bell'),
  alert('alert'),
  info('info'),
  help('help'),
  settings('settings'),
  lock('lock'),
  unlock('unlock'),
  keyhole('keyhole'),
  calendar('calendar'),
  clock('clock'),
  map('map'),
  pin('pin'),
  mail('mail'),
  message('message'),
  link('link'),
  copy('copy'),
  refresh('refresh'),
  download('download'),
  upload('upload'),
  cloud('cloud'),
  file('file'),
  folder('folder'),
  grid('grid'),
  list('list'),
  play('play'),
  pause('pause'),
  stop('stop'),
  power('power');

  const XkIconName(this.token);
  final String token;
}

class XkIconSize {
  XkIconSize._();

  static const double inline = 12;
  static const double small = 16;
  static const double regular = 20;
  static const double large = 24;
  static const double display = 32;
  static const double hero = 48;
}

/// Stroke-based Weave icon widget.
class XkIcon extends StatelessWidget {
  const XkIcon(
    this.name, {
    super.key,
    this.size = XkIconSize.regular,
    this.color,
    this.strokeWidth = 1.6,
    this.semanticLabel,
  });

  final XkIconName name;
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor =
        color ?? (isDark ? XkColor.darkTextBody : XkColor.textBody);
    final spec = _xkIconSpecs[name]!;

    return SvgPicture.string(
      _buildSvg(spec, strokeWidth),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel ?? name.token,
    );
  }

  String _buildSvg(_XkIconSpec spec, double width) {
    final stroke = width.toStringAsFixed(2);
    return '<svg viewBox="${spec.viewBox}" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="$stroke" stroke-linecap="round" stroke-linejoin="round">${spec.body}</svg>';
  }
}

class _XkIconSpec {
  const _XkIconSpec(this.viewBox, this.body);

  final String viewBox;
  final String body;
}

const Map<XkIconName, _XkIconSpec> _xkIconSpecs = {
  XkIconName.chevLeft: _XkIconSpec('0 0 20 20', '<path d="M12 5L7 10l5 5"/>'),
  XkIconName.chevRight: _XkIconSpec('0 0 20 20', '<path d="M8 5l5 5-5 5"/>'),
  XkIconName.chevUp: _XkIconSpec('0 0 20 20', '<path d="M5 12l5-5 5 5"/>'),
  XkIconName.chevDown: _XkIconSpec('0 0 20 20', '<path d="M5 8l5 5 5-5"/>'),
  XkIconName.plus: _XkIconSpec('0 0 20 20', '<path d="M10 4v12M4 10h12"/>'),
  XkIconName.minus: _XkIconSpec('0 0 20 20', '<path d="M4 10h12"/>'),
  XkIconName.close:
      _XkIconSpec('0 0 20 20', '<path d="M5 5l10 10M15 5L5 15"/>'),
  XkIconName.check: _XkIconSpec('0 0 20 20', '<path d="M4 10l4 4 8-8"/>'),
  XkIconName.search: _XkIconSpec(
      '0 0 20 20', '<circle cx="9" cy="9" r="5"/><path d="M15 15l-3-3"/>'),
  XkIconName.filter:
      _XkIconSpec('0 0 20 20', '<path d="M3 4h14M6 10h8M8 16h4"/>'),
  XkIconName.sort:
      _XkIconSpec('0 0 20 20', '<path d="M6 4h8M4 10h12M8 16h4"/>'),
  XkIconName.sliders: _XkIconSpec('0 0 20 20',
      '<path d="M4 6h12M4 10h12M4 14h12"/><circle cx="7" cy="6" r="1.6"/><circle cx="13" cy="10" r="1.6"/><circle cx="9" cy="14" r="1.6"/>'),
  XkIconName.home: _XkIconSpec(
      '0 0 20 20', '<path d="M3 10l7-6 7 6v7H3z"/><path d="M8 17v-4h4v4"/>'),
  XkIconName.user: _XkIconSpec('0 0 20 20',
      '<circle cx="10" cy="7" r="3"/><path d="M4 17c0-3.3 2.7-6 6-6s6 2.7 6 6"/>'),
  XkIconName.users: _XkIconSpec('0 0 20 20',
      '<circle cx="7" cy="8" r="2.5"/><circle cx="13" cy="8" r="2.5"/><path d="M2.5 16c0-2.4 2-4.4 4.5-4.4M13 11.6c2.5 0 4.5 2 4.5 4.4"/>'),
  XkIconName.briefcase: _XkIconSpec(
      '0 0 20 20', '<path d="M3 7h14v9H3z"/><path d="M7 7V5h6v2"/>'),
  XkIconName.chartBar: _XkIconSpec('0 0 20 20',
      '<rect x="3" y="11" width="3" height="6"/><rect x="8.5" y="7" width="3" height="10"/><rect x="14" y="4" width="3" height="13"/>'),
  XkIconName.chartLine:
      _XkIconSpec('0 0 20 20', '<path d="M3 14l4-4 3 2 5-6 2 2"/>'),
  XkIconName.pie: _XkIconSpec(
      '0 0 20 20', '<circle cx="10" cy="10" r="7"/><path d="M10 3v7h7"/>'),
  XkIconName.trendUp: _XkIconSpec(
      '0 0 20 20', '<path d="M4 14l5-5 3 3 4-6"/><path d="M12 6h4v4"/>'),
  XkIconName.bell: _XkIconSpec('0 0 20 20',
      '<path d="M10 2a6 6 0 0 1 6 6c0 3 1 4 1 5H3c0-1 1-2 1-5a6 6 0 0 1 6-6"/><path d="M8.5 17a1.5 1.5 0 0 0 3 0"/>'),
  XkIconName.alert: _XkIconSpec(
      '0 0 20 20', '<path d="M10 3l8 14H2z"/><path d="M10 8v4M10 14h.01"/>'),
  XkIconName.info: _XkIconSpec('0 0 20 20',
      '<circle cx="10" cy="10" r="7"/><path d="M10 8v5M10 6h.01"/>'),
  XkIconName.help: _XkIconSpec('0 0 20 20',
      '<circle cx="10" cy="10" r="7"/><path d="M8.7 8.2a1.8 1.8 0 1 1 3 .9c-.9.5-1.3 1-1.3 2"/><path d="M10 14h.01"/>'),
  XkIconName.settings: _XkIconSpec('0 0 20 20',
      '<circle cx="10" cy="10" r="2.5"/><path d="M10 2.5v2M10 15.5v2M2.5 10h2M15.5 10h2M4.9 4.9l1.4 1.4M13.7 13.7l1.4 1.4M15.1 4.9l-1.4 1.4M6.3 13.7l-1.4 1.4"/>'),
  XkIconName.lock: _XkIconSpec('0 0 20 20',
      '<rect x="4" y="9" width="12" height="8" rx="2"/><path d="M7 9V6a3 3 0 0 1 6 0v3"/>'),
  XkIconName.unlock: _XkIconSpec('0 0 20 20',
      '<rect x="4" y="9" width="12" height="8" rx="2"/><path d="M13 9V6a3 3 0 0 0-6 0"/>'),
  XkIconName.keyhole: _XkIconSpec(
      '0 0 20 20', '<path d="M3 9l7-6 7 6v8H3z"/><path d="M10 9l7-6"/>'),
  XkIconName.calendar: _XkIconSpec('0 0 20 20',
      '<rect x="3" y="4" width="14" height="13" rx="2"/><path d="M3 8h14M7 2v4M13 2v4"/>'),
  XkIconName.clock: _XkIconSpec(
      '0 0 20 20', '<circle cx="10" cy="10" r="7"/><path d="M10 6v4l3 2"/>'),
  XkIconName.map: _XkIconSpec(
      '0 0 20 20', '<path d="M3 15l4-5 3 3 5-6 2 2"/><path d="M15 7h2v2"/>'),
  XkIconName.pin: _XkIconSpec('0 0 20 20',
      '<path d="M10 17s5-4.4 5-8a5 5 0 1 0-10 0c0 3.6 5 8 5 8z"/><circle cx="10" cy="9" r="1.8"/>'),
  XkIconName.mail: _XkIconSpec('0 0 20 20',
      '<rect x="3" y="5" width="14" height="10" rx="2"/><path d="M3 7l7 4 7-4"/>'),
  XkIconName.message: _XkIconSpec('0 0 20 20', '<path d="M4 5h12v8H8l-4 3z"/>'),
  XkIconName.link: _XkIconSpec('0 0 20 20',
      '<path d="M8 12l4-4"/><path d="M7 6H5a3 3 0 0 0 0 6h2"/><path d="M13 6h2a3 3 0 0 1 0 6h-2"/>'),
  XkIconName.copy: _XkIconSpec('0 0 20 20',
      '<rect x="6" y="6" width="10" height="10" rx="2"/><rect x="4" y="4" width="10" height="10" rx="2"/>'),
  XkIconName.refresh: _XkIconSpec('0 0 20 20',
      '<path d="M16 10a6 6 0 1 1-1.8-4.3"/><path d="M16 4v4h-4"/>'),
  XkIconName.download: _XkIconSpec('0 0 20 20',
      '<path d="M10 3v10"/><path d="M6 9l4 4 4-4"/><path d="M4 17h12"/>'),
  XkIconName.upload: _XkIconSpec('0 0 20 20',
      '<path d="M10 17V7"/><path d="M14 11l-4-4-4 4"/><path d="M4 3h12"/>'),
  XkIconName.cloud: _XkIconSpec('0 0 20 20',
      '<path d="M6 15h9a3 3 0 0 0 .4-6A5 5 0 0 0 5 10a2.6 2.6 0 0 0 1 5z"/>'),
  XkIconName.file: _XkIconSpec(
      '0 0 20 20', '<path d="M5 3h7l3 3v11H5z"/><path d="M12 3v3h3"/>'),
  XkIconName.folder: _XkIconSpec('0 0 20 20', '<path d="M3 6h6l2 2h6v8H3z"/>'),
  XkIconName.grid: _XkIconSpec('0 0 20 20',
      '<rect x="3" y="3" width="5" height="5"/><rect x="12" y="3" width="5" height="5"/><rect x="3" y="12" width="5" height="5"/><rect x="12" y="12" width="5" height="5"/>'),
  XkIconName.list:
      _XkIconSpec('0 0 20 20', '<path d="M4 5h12M4 10h12M4 15h12"/>'),
  XkIconName.play: _XkIconSpec('0 0 20 20', '<path d="M8 6l6 4-6 4z"/>'),
  XkIconName.pause: _XkIconSpec('0 0 20 20',
      '<rect x="6" y="5" width="3" height="10"/><rect x="11" y="5" width="3" height="10"/>'),
  XkIconName.stop:
      _XkIconSpec('0 0 20 20', '<rect x="6" y="6" width="8" height="8"/>'),
  XkIconName.power: _XkIconSpec(
      '0 0 20 20', '<path d="M10 3v7"/><path d="M6 5.5a6 6 0 1 0 8 0"/>'),
};
