import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'option.g.theme.dart';

/// {@template ShadOptionTheme}
/// Theme for the `ShadOption` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadOptionTheme with _$ShadOptionTheme {
  /// {@macro ShadOptionTheme}
  const ShadOptionTheme({
    bool canMerge = true,
    this.hoveredBackgroundColor,
    this.selectedBackgroundColor,
    this.backgroundColor,
    this.textStyle,
    this.selectedTextStyle,
    this.padding,
    this.radius,
    this.selectedIconColor,
    this.selectedHoveredIconColor,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// The row's background while hovered. Defaults to the colour scheme's
  /// `accent`.
  final Color? hoveredBackgroundColor;

  /// The padding around the row's content.
  final EdgeInsetsGeometry? padding;

  /// The row's corner radius. Defaults to `ShadThemeData.radius`.
  final BorderRadius? radius;

  /// The row's background at rest.
  final Color? backgroundColor;

  /// The text style of the row's label.
  final TextStyle? textStyle;

  /// The row's background when it is selected.
  final Color? selectedBackgroundColor;

  /// The text style of the row's label when it is selected.
  final TextStyle? selectedTextStyle;

  /// The colour of the check indicator on a selected row at rest.
  final Color? selectedIconColor;

  /// The colour of the check indicator while the row is hovered, when the
  /// highlight's own foreground applies (`focus:**:text-accent-foreground`).
  final Color? selectedHoveredIconColor;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadOptionTheme? lerp(
    ShadOptionTheme? a,
    ShadOptionTheme? b,
    double t,
  ) => _$ShadOptionTheme.lerp(a, b, t);
}
