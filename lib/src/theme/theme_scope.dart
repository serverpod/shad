import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';

/// {@template ShadThemeScope}
/// Applies a [ShadThemeData] to a subtree, including the ambient text and icon
/// styling that comes with it.
///
/// [ShadTheme] alone only publishes the Shad theme: `ShadTheme.of` picks it up,
/// but a plain [Text] keeps whatever [DefaultTextStyle] it inherited from
/// further up, so a light-on-dark panel inside a light app renders dark text on
/// a dark surface. This widget also sets the text style, icon theme and
/// selection colours for the subtree.
///
/// Material widgets in the subtree follow it too when they are wrapped in a
/// `ShadMaterial` from `package:shad/material.dart`, which reads the nearest
/// shad theme.
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
  });

  /// The theme to apply to [child].
  final ShadThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadTheme(
      data: data,
      child: DefaultTextStyle(
        style: data.textTheme.p.copyWith(color: data.colorScheme.foreground),
        child: ShadDefaultStyles(data: data, child: child),
      ),
    );
  }
}

/// Sets the icon theme and the text selection colours that a [ShadThemeData]
/// implies for [child].
///
/// `ShadApp` puts one at the root and [ShadThemeScope] one in each re-themed
/// subtree.
class ShadDefaultStyles extends StatelessWidget {
  /// Creates the default icon and selection styles for [data].
  const ShadDefaultStyles({super.key, required this.data, required this.child});

  /// The theme the styles come from.
  final ShadThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(size: 16, color: data.colorScheme.foreground),
      child: DefaultSelectionStyle(
        cursorColor: data.colorScheme.primary,
        selectionColor: data.colorScheme.selection,
        child: child,
      ),
    );
  }
}
