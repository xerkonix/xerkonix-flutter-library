import 'package:flutter/material.dart';

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

/// Assembles [ThemeData] so used Material defaults read current roles.
///
/// Brand state colors (`ok` / `warn` / `bad`, temperature, mark tile) are
/// passed in by the app — they are allowed differences, not chrome.
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
    final Color err = error ?? t.accentDeep;
    final Color onErr = onError ?? t.surfaceRaised;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.accent,
      onSecondary: c.surfaceRaised,
      surface: c.surface,
      onSurface: c.ink,
      error: err,
      onError: onErr,
      outline: c.line,
      surfaceTint: clear,
      inverseSurface: c.overlay,
      onInverseSurface: c.ink,
      tertiary: tertiary ?? c.accent,
      onTertiary: onTertiary ?? c.surfaceRaised,
    );

    final BorderRadius panelR = BorderRadius.circular(
      XkTactileTokens.panelRadius,
    );
    final BorderRadius overlayR = BorderRadius.circular(
      XkTactileTokens.overlayRadius,
    );
    final BorderSide lineSide = BorderSide(color: c.line);
    final BorderSide overlaySide = BorderSide(color: c.overlayBorder);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily ?? XkTactileFonts.family,
      textTheme: textTheme,
      colorScheme: scheme,
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
        shape: RoundedRectangleBorder(
          borderRadius: panelR,
          side: lineSide,
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: panelR,
          side: overlaySide,
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: panelR,
          side: overlaySide,
        ),
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
        indicatorColor: c.ice,
        labelColor: c.ink,
        unselectedLabelColor: c.muted,
        dividerColor: c.line,
        overlayColor: const WidgetStatePropertyAll<Color>(clear),
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
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? c.controlOn
              : c.controlTrack,
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
          return t.primaryBase.withValues(alpha: XkTactileTokens.disabledOpacity);
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
