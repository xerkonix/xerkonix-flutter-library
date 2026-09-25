import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tactile_app_surface.dart';
import 'tactile_field.dart';
import 'tactile_fonts.dart';
import 'tactile_tokens.dart';

/// Material slot → TACTILE CSS role. Owner of app ThemeData chrome.
///
/// Hex lives in [XkTactileTokens] (from `tactile/tokens.css`). This file does
/// not invent colors. Product `_tokens.dart` / CosentioTokens ledgers stay
/// generated or brand-parity copies — do not hand-edit those to retarget paint.
///
/// Mapping table: `tools/tactile_theme_roles.json`
/// (`python3 tools/build_tactile_theme_roles.py --write|--check`).
class XkTactileChrome {
  const XkTactileChrome._(this.tokens);

  final XkTactileTokens tokens;

  static XkTactileChrome of(Brightness brightness) {
    return XkTactileChrome._(XkTactileTokens.of(brightness));
  }

  Color get canvas => tokens.canvas;
  Color get surface => tokens.surface;
  Color get surfaceRaised => tokens.surfaceRaised;
  Color get panel => tokens.panelFill;
  Color get overlay => tokens.overlayFill;
  Color get overlayBorder => tokens.overlayBorder;
  Color get overlayBackdrop => tokens.overlayBackdrop;
  Color get glass => tokens.glassFill;
  Color get glassRim => tokens.glassRim;
  Color get glassInset => tokens.glassInset;
  List<BoxShadow> get shadowFloat => tokens.shadowFloat;
  Color get ink => tokens.ink;
  Color get muted => tokens.muted;
  Color get faint => tokens.faint;
  Color get line => tokens.line;
  Color get header => tokens.headerFill;
  Color get inputFill => tokens.inputFill;
  Color get primary => tokens.primaryBase;
  Color get onPrimary => tokens.primaryText;
  Color get ice => tokens.ice;
  Color get accent => tokens.accent;
  Color get controlOn => tokens.controlOn;
  Color get controlTrack => tokens.controlTrack;
  Color get controlMark => tokens.controlMark;
  Color get selectedFill => tokens.selectedFill;
  Color get selectedBorder => tokens.selectedBorder;
}

/// Product screen version 6-B roles for Flutter apps.
///
/// Names follow DS `flutter/APP_SURFACE_MAPPING.md`; values are the
/// [XkTactileTokens] constants checked by
/// `tools/build_tactile_theme_roles.py` against `tactile/app-surface.css`.
/// [XkTactileTheme.themeData] installs this extension. Read it with
/// [XkTactileAppSurface.of].
///
/// - Ink plane roles (`appIntro*`, `onAppIntro*`) belong to
///   [XkTactileAppIntro] — login, an empty state, a dashboard head, or
///   payment completion only.
/// - [currentLabel], [keyMetric], [humanReviewLabel], [selectedCue] are the
///   dark-derived Aquamarine reading text (AA on canvas and surface). Say the
///   state in words too. Do not use light raw `accent` for reading text or a
///   required edge.
/// - Selected controls stay neutral: `selectedFill` / `selectedBorder` /
///   `ink` on [XkTactileTokens]. [selectedCue] is the small text beside the
///   selected label, never the control fill.
@immutable
class XkTactileAppSurface extends ThemeExtension<XkTactileAppSurface> {
  const XkTactileAppSurface({
    required this.appIntroSurface,
    required this.onAppIntro,
    required this.appIntroBody,
    required this.appIntroPrimaryFill,
    required this.appIntroPrimaryText,
    required this.appIntroPrimaryHover,
    required this.appIntroFocusRing,
    required this.onAppIntroAccent,
    required this.appIntroLink,
    required this.appIntroBrandWord,
    required this.completionSheen,
    required this.currentLabel,
    required this.keyMetric,
    required this.humanReviewLabel,
    required this.selectedCue,
    required this.humanReviewSurface,
    required this.humanReviewBorder,
  });

  factory XkTactileAppSurface.fromTokens(XkTactileTokens t) {
    return XkTactileAppSurface(
      appIntroSurface: t.appIntroSurface,
      onAppIntro: t.onAppIntro,
      appIntroBody: t.appIntroBody,
      appIntroPrimaryFill: t.appIntroPrimaryFill,
      appIntroPrimaryText: t.appIntroPrimaryText,
      appIntroPrimaryHover: t.appIntroPrimaryHover,
      appIntroFocusRing: t.appIntroFocusRing,
      onAppIntroAccent: t.onAppIntroAccent,
      appIntroLink: t.appIntroLink,
      appIntroBrandWord: t.appIntroBrandWord,
      completionSheen: t.completionSheen,
      currentLabel: t.currentLabel,
      keyMetric: t.keyMetric,
      humanReviewLabel: t.humanReviewLabel,
      selectedCue: t.selectedCue,
      humanReviewSurface: t.humanReviewSurface,
      humanReviewBorder: t.humanReviewBorder,
    );
  }

  static final XkTactileAppSurface light = XkTactileAppSurface.fromTokens(
    XkTactileTokens.light,
  );
  static final XkTactileAppSurface dark = XkTactileAppSurface.fromTokens(
    XkTactileTokens.dark,
  );

  /// The installed extension, or the TACTILE roles for the theme brightness
  /// when the app builds its own [ThemeData].
  static XkTactileAppSurface of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.extension<XkTactileAppSurface>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  final Color appIntroSurface;
  final Color onAppIntro;
  final Color appIntroBody;
  final Color appIntroPrimaryFill;
  final Color appIntroPrimaryText;
  final Color appIntroPrimaryHover;
  final Color appIntroFocusRing;
  final Color onAppIntroAccent;
  final Color appIntroLink;

  /// Two stops of one Aquamarine hue. One place per screen, on the ink plane.
  final List<Color> appIntroBrandWord;
  final Color completionSheen;
  final Color currentLabel;
  final Color keyMetric;
  final Color humanReviewLabel;
  final Color selectedCue;
  final Color humanReviewSurface;
  final Color humanReviewBorder;

  // Value equality keeps ThemeData equal across rebuilds, so AnimatedTheme
  // does not start a lerp and the ink-plane scope does not notify.
  @override
  bool operator ==(Object other) {
    return other is XkTactileAppSurface &&
        other.appIntroSurface == appIntroSurface &&
        other.onAppIntro == onAppIntro &&
        other.appIntroBody == appIntroBody &&
        other.appIntroPrimaryFill == appIntroPrimaryFill &&
        other.appIntroPrimaryText == appIntroPrimaryText &&
        other.appIntroPrimaryHover == appIntroPrimaryHover &&
        other.appIntroFocusRing == appIntroFocusRing &&
        other.onAppIntroAccent == onAppIntroAccent &&
        other.appIntroLink == appIntroLink &&
        other.completionSheen == completionSheen &&
        other.currentLabel == currentLabel &&
        other.keyMetric == keyMetric &&
        other.humanReviewLabel == humanReviewLabel &&
        other.selectedCue == selectedCue &&
        other.humanReviewSurface == humanReviewSurface &&
        other.humanReviewBorder == humanReviewBorder &&
        listEquals(other.appIntroBrandWord, appIntroBrandWord);
  }

  @override
  int get hashCode => Object.hash(
    appIntroSurface,
    onAppIntro,
    appIntroBody,
    appIntroPrimaryFill,
    appIntroPrimaryText,
    appIntroPrimaryHover,
    appIntroFocusRing,
    onAppIntroAccent,
    appIntroLink,
    completionSheen,
    currentLabel,
    keyMetric,
    humanReviewLabel,
    selectedCue,
    humanReviewSurface,
    humanReviewBorder,
    Object.hashAll(appIntroBrandWord),
  );

  @override
  XkTactileAppSurface copyWith({
    Color? appIntroSurface,
    Color? onAppIntro,
    Color? appIntroBody,
    Color? appIntroPrimaryFill,
    Color? appIntroPrimaryText,
    Color? appIntroPrimaryHover,
    Color? appIntroFocusRing,
    Color? onAppIntroAccent,
    Color? appIntroLink,
    List<Color>? appIntroBrandWord,
    Color? completionSheen,
    Color? currentLabel,
    Color? keyMetric,
    Color? humanReviewLabel,
    Color? selectedCue,
    Color? humanReviewSurface,
    Color? humanReviewBorder,
  }) {
    return XkTactileAppSurface(
      appIntroSurface: appIntroSurface ?? this.appIntroSurface,
      onAppIntro: onAppIntro ?? this.onAppIntro,
      appIntroBody: appIntroBody ?? this.appIntroBody,
      appIntroPrimaryFill: appIntroPrimaryFill ?? this.appIntroPrimaryFill,
      appIntroPrimaryText: appIntroPrimaryText ?? this.appIntroPrimaryText,
      appIntroPrimaryHover: appIntroPrimaryHover ?? this.appIntroPrimaryHover,
      appIntroFocusRing: appIntroFocusRing ?? this.appIntroFocusRing,
      onAppIntroAccent: onAppIntroAccent ?? this.onAppIntroAccent,
      appIntroLink: appIntroLink ?? this.appIntroLink,
      appIntroBrandWord: appIntroBrandWord ?? this.appIntroBrandWord,
      completionSheen: completionSheen ?? this.completionSheen,
      currentLabel: currentLabel ?? this.currentLabel,
      keyMetric: keyMetric ?? this.keyMetric,
      humanReviewLabel: humanReviewLabel ?? this.humanReviewLabel,
      selectedCue: selectedCue ?? this.selectedCue,
      humanReviewSurface: humanReviewSurface ?? this.humanReviewSurface,
      humanReviewBorder: humanReviewBorder ?? this.humanReviewBorder,
    );
  }

  @override
  XkTactileAppSurface lerp(
    covariant ThemeExtension<XkTactileAppSurface>? other,
    double t,
  ) {
    if (other is! XkTactileAppSurface) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return XkTactileAppSurface(
      appIntroSurface: mix(appIntroSurface, other.appIntroSurface),
      onAppIntro: mix(onAppIntro, other.onAppIntro),
      appIntroBody: mix(appIntroBody, other.appIntroBody),
      appIntroPrimaryFill: mix(appIntroPrimaryFill, other.appIntroPrimaryFill),
      appIntroPrimaryText: mix(appIntroPrimaryText, other.appIntroPrimaryText),
      appIntroPrimaryHover: mix(
        appIntroPrimaryHover,
        other.appIntroPrimaryHover,
      ),
      appIntroFocusRing: mix(appIntroFocusRing, other.appIntroFocusRing),
      onAppIntroAccent: mix(onAppIntroAccent, other.onAppIntroAccent),
      appIntroLink: mix(appIntroLink, other.appIntroLink),
      appIntroBrandWord: <Color>[
        for (int i = 0; i < appIntroBrandWord.length; i++)
          mix(
            appIntroBrandWord[i],
            other.appIntroBrandWord[i.clamp(
              0,
              other.appIntroBrandWord.length - 1,
            )],
          ),
      ],
      completionSheen: mix(completionSheen, other.completionSheen),
      currentLabel: mix(currentLabel, other.currentLabel),
      keyMetric: mix(keyMetric, other.keyMetric),
      humanReviewLabel: mix(humanReviewLabel, other.humanReviewLabel),
      selectedCue: mix(selectedCue, other.selectedCue),
      humanReviewSurface: mix(humanReviewSurface, other.humanReviewSurface),
      humanReviewBorder: mix(humanReviewBorder, other.humanReviewBorder),
    );
  }
}

/// Assembles [ThemeData] so used Material defaults read current roles.
///
/// Brand state colors (`ok` / `warn` / `bad`, temperature, mark tile) are
/// passed in by the app — they are allowed differences, not chrome.
///
/// ColorScheme primary / secondary / tertiary stay monochrome so primary
/// buttons, checkboxes, and focus do not turn Aquamarine. Tab bar,
/// navigation bar, and navigation rail indicators use the neutral selected
/// face (`--selected-fill` + `--selected-border`, label `--selected-text`).
/// Product screen 6-B roles are installed as [XkTactileAppSurface].
class XkTactileTheme {
  const XkTactileTheme._();

  static ThemeData themeData(
    Brightness brightness, {
    String? fontFamily,
    TextTheme? textTheme,
    Color? error,
    Color? onError,
    Color? tertiary,
    Color? onTertiary,
  }) {
    final XkTactileChrome c = XkTactileChrome.of(brightness);
    final XkTactileTokens t = c.tokens;
    const Color clear = XkTactileTokens.clear;
    final Color err = error ?? t.ink;
    final Color onErr = onError ?? t.canvas;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.ink,
      onSecondary: c.canvas,
      surface: c.surface,
      onSurface: c.ink,
      error: err,
      onError: onErr,
      outline: c.line,
      surfaceTint: clear,
      inverseSurface: c.overlay,
      onInverseSurface: c.ink,
      tertiary: tertiary ?? c.ink,
      onTertiary: onTertiary ?? c.canvas,
    );

    final BorderRadius panelR = BorderRadius.circular(
      XkTactileTokens.panelRadius,
    );
    final BorderRadius overlayR = BorderRadius.circular(
      XkTactileTokens.overlayRadius,
    );
    final BorderSide lineSide = BorderSide(color: c.line);
    final BorderSide overlaySide = BorderSide(color: c.overlayBorder);
    final RoundedRectangleBorder selectedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(XkTactileTokens.controlRadius),
      side: BorderSide(color: c.selectedBorder),
    );
    // M3 labelMedium metrics; colour from the neutral selected rule.
    final TextStyle navLabel =
        textTheme?.labelMedium ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 4 / 3,
        );
    final TextStyle navLabelSelected = navLabel.copyWith(
      color: c.ink,
      fontWeight: FontWeight.w600,
    );
    final TextStyle navLabelIdle = navLabel.copyWith(color: c.muted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily ?? XkTactileFonts.family,
      textTheme: textTheme,
      colorScheme: scheme,
      extensions: <XkTactileAppSurface>[XkTactileAppSurface.fromTokens(t)],
      scaffoldBackgroundColor: c.canvas,
      canvasColor: c.canvas,
      dividerColor: c.line,
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: c.header,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: clear,
        centerTitle: false,
        titleTextStyle: textTheme?.titleLarge,
        shape: Border(bottom: lineSide),
      ),
      cardTheme: CardThemeData(
        color: c.panel,
        elevation: 0,
        shadowColor: clear,
        surfaceTintColor: clear,
        shape: RoundedRectangleBorder(borderRadius: panelR, side: lineSide),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.overlay,
        elevation: 0,
        shadowColor: clear,
        surfaceTintColor: clear,
        shape: RoundedRectangleBorder(
          borderRadius: overlayR,
          side: overlaySide,
        ),
        titleTextStyle: textTheme?.titleLarge,
        contentTextStyle: textTheme?.bodyMedium,
        barrierColor: c.overlayBackdrop,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.overlay,
        elevation: 0,
        shadowColor: clear,
        surfaceTintColor: clear,
        textStyle: textTheme?.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: panelR, side: overlaySide),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.overlay,
        modalBackgroundColor: c.overlay,
        elevation: 0,
        shadowColor: clear,
        surfaceTintColor: clear,
        modalBarrierColor: c.overlayBackdrop,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(XkTactileTokens.overlayRadius),
          ),
          side: overlaySide,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: c.overlay,
        elevation: 0,
        shadowColor: clear,
        surfaceTintColor: clear,
        shape: const RoundedRectangleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.overlay,
        contentTextStyle: textTheme?.bodyMedium?.copyWith(color: c.ink),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: panelR, side: overlaySide),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.overlay,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: c.overlayBorder),
        ),
        textStyle: textTheme?.bodySmall?.copyWith(color: c.ink),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: ShapeDecoration(color: c.selectedFill, shape: selectedShape),
        indicatorColor: c.selectedBorder,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: c.ink,
        unselectedLabelColor: c.muted,
        dividerColor: c.line,
        overlayColor: const WidgetStatePropertyAll<Color>(clear),
        splashBorderRadius: BorderRadius.circular(
          XkTactileTokens.controlRadius,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: c.selectedFill,
        indicatorShape: selectedShape,
        surfaceTintColor: clear,
        elevation: 0,
        overlayColor: const WidgetStatePropertyAll<Color>(clear),
        iconTheme: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? c.ink : c.muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? navLabelSelected
              : navLabelIdle,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        useIndicator: true,
        indicatorColor: c.selectedFill,
        indicatorShape: selectedShape,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: c.ink),
        unselectedIconTheme: IconThemeData(color: c.muted),
        selectedLabelTextStyle: navLabelSelected,
        unselectedLabelTextStyle: navLabelIdle,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _iceButton(t, filled: true),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _iceButton(t, filled: true),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(c.ink),
          overlayColor: const WidgetStatePropertyAll<Color>(clear),
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(44, XkTactileTokens.controlHeight),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(c.ink),
          overlayColor: const WidgetStatePropertyAll<Color>(clear),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XkTactileTokens.controlRadius),
        ),
      ),
      inputDecorationTheme: XkTactileField.inputThemeOf(brightness),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) =>
              s.contains(WidgetState.selected) ? c.controlOn : clear,
        ),
        checkColor: WidgetStatePropertyAll<Color>(c.controlMark),
        side: BorderSide(color: c.line),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) =>
              s.contains(WidgetState.selected) ? c.controlOn : c.line,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? c.controlMark
              : c.surfaceRaised,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) =>
              s.contains(WidgetState.selected) ? c.controlOn : c.controlTrack,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.line,
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ButtonStyle _iceButton(XkTactileTokens t, {required bool filled}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        if (!filled) {
          return XkTactileTokens.clear;
        }
        if (s.contains(WidgetState.disabled)) {
          return t.primaryBase.withValues(
            alpha: XkTactileTokens.disabledOpacity,
          );
        }
        return t.primaryBase;
      }),
      foregroundColor: WidgetStatePropertyAll<Color>(t.primaryText),
      elevation: const WidgetStatePropertyAll<double>(0),
      shadowColor: const WidgetStatePropertyAll<Color>(XkTactileTokens.clear),
      minimumSize: const WidgetStatePropertyAll<Size>(
        Size(48, XkTactileTokens.controlHeight),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XkTactileTokens.controlRadius),
        ),
      ),
    );
  }
}
