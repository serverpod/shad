import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'option.g.theme.dart';

@themeGen
@immutable
class ShadOptionTheme with _$ShadOptionTheme {
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

  final Color? hoveredBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? selectedBackgroundColor;
  final TextStyle? selectedTextStyle;

  /// The colour of the check indicator on a selected row at rest.
  final Color? selectedIconColor;

  /// The colour of the check indicator while the row is hovered, when the
  /// highlight's own foreground applies (`focus:**:text-accent-foreground`).
  final Color? selectedHoveredIconColor;

  static ShadOptionTheme? lerp(
    ShadOptionTheme? a,
    ShadOptionTheme? b,
    double t,
  ) => _$ShadOptionTheme.lerp(a, b, t);
}
