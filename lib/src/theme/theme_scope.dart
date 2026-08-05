import 'package:flutter/material.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';

/// Derives the Material [ThemeData] a [ShadThemeData] implies.
///
/// `ShadApp` does this at the root so that Material widgets — and the ambient
/// [DefaultTextStyle] and [IconTheme] that every `Text` and `Icon` reads from —
/// agree with the Shad theme. Exposed so a subtree can be re-themed too; see
/// [ShadThemeScope].
ThemeData shadMaterialThemeFrom(ShadThemeData themeData) {
  return ThemeData(
    fontFamily: themeData.textTheme.family,
    colorScheme: ColorScheme(
      brightness: themeData.brightness,
      primary: themeData.colorScheme.primary,
      onPrimary: themeData.colorScheme.primaryForeground,
      secondary: themeData.colorScheme.secondary,
      onSecondary: themeData.colorScheme.secondaryForeground,
      error: themeData.colorScheme.destructive,
      onError: themeData.colorScheme.destructiveForeground,
      surface: themeData.colorScheme.background,
      onSurface: themeData.colorScheme.foreground,
    ),
    scaffoldBackgroundColor: themeData.colorScheme.background,
    brightness: themeData.brightness,
    dividerTheme: DividerThemeData(
      color: themeData.separatorTheme.color ?? themeData.colorScheme.border,
      thickness: themeData.separatorTheme.thickness ?? 1,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: themeData.colorScheme.primary,
      selectionColor: themeData.colorScheme.selection,
      selectionHandleColor: themeData.colorScheme.primary,
    ),
    iconTheme: IconThemeData(
      size: 16,
      color: themeData.colorScheme.foreground,
    ),
    scrollbarTheme: ScrollbarThemeData(
      crossAxisMargin: 1,
      mainAxisMargin: 1,
      thickness: const WidgetStatePropertyAll(8),
      radius: const Radius.circular(999),
      thumbColor: WidgetStatePropertyAll(themeData.colorScheme.border),
    ),
  );
}

/// {@template ShadThemeScope}
/// Applies a [ShadThemeData] to a subtree, including the ambient text and icon
/// styling that comes with it.
///
/// [ShadTheme] alone only publishes the Shad theme: `ShadTheme.of` picks it up,
/// but a plain [Text] keeps whatever [DefaultTextStyle] it inherited from
/// further up, so a light-on-dark panel inside a light app renders dark text on
/// a dark surface. `ShadApp` avoids this by also installing a Material [Theme];
/// this widget does the same thing for any subtree.
///
/// Reach for it when part of the UI is deliberately themed differently from the
/// app — a dark settings panel, a themed preview pane, an embedded editor:
///
/// ```dart
/// ShadThemeScope(
///   data: ShadThemeData(
///     brightness: Brightness.dark,
///     colorScheme: const ShadNeutralColorScheme.dark(),
///   ),
///   child: const SettingsPanel(),
/// )
/// ```
///
/// Overlays opened from inside the scope — popovers, tooltips, selects — stay
/// within it, because they are built through `OverlayPortal` from this position
/// in the tree. Routes do not: `showShadDialog` re-publishes the ambient theme
/// itself for that reason.
/// {@endtemplate}
class ShadThemeScope extends StatelessWidget {
  /// {@macro ShadThemeScope}
  const ShadThemeScope({
    super.key,
    required this.data,
    required this.child,
    this.applyMaterialTheme = true,
  });

  /// The theme to apply to [child].
  final ShadThemeData data;

  final Widget child;

  /// Whether to install the derived Material [Theme] as well.
  ///
  /// Defaults to true, which is what makes text and icon colours follow. Set
  /// to false if an ancestor already provides the right Material theme and you
  /// only want the Shad half.
  final bool applyMaterialTheme;

  @override
  Widget build(BuildContext context) {
    Widget result = DefaultTextStyle(
      style: data.textTheme.p.copyWith(color: data.colorScheme.foreground),
      child: IconTheme(
        data: IconThemeData(size: 16, color: data.colorScheme.foreground),
        child: child,
      ),
    );

    if (applyMaterialTheme) {
      result = Theme(data: shadMaterialThemeFrom(data), child: result);
    }

    return ShadTheme(data: data, child: result);
  }
}
