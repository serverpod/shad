import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'toggle.g.theme.dart';

/// {@template ShadToggleTheme}
/// Theme for the `ShadToggle` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadToggleTheme with _$ShadToggleTheme {
  /// {@macro ShadToggleTheme}
  const ShadToggleTheme({
    bool canMerge = true,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedHoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.selectedForegroundColor,
    this.padding,
    this.decoration,
    this.textStyle,
    this.gap,
    this.height,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadToggle.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadToggle.hoverBackgroundColor}
  final Color? hoverBackgroundColor;

  /// {@macro ShadToggle.selectedBackgroundColor}
  final Color? selectedBackgroundColor;

  /// {@macro ShadToggle.selectedHoverBackgroundColor}
  final Color? selectedHoverBackgroundColor;

  /// {@macro ShadToggle.foregroundColor}
  final Color? foregroundColor;

  /// {@macro ShadToggle.hoverForegroundColor}
  final Color? hoverForegroundColor;

  /// {@macro ShadToggle.selectedForegroundColor}
  final Color? selectedForegroundColor;

  /// {@macro ShadToggle.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadToggle.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadToggle.textStyle}
  final TextStyle? textStyle;

  /// The gap between the leading icon and the label.
  final double? gap;

  /// The height of the toggle.
  final double? height;

  static ShadToggleTheme? lerp(
    ShadToggleTheme? a,
    ShadToggleTheme? b,
    double t,
  ) => _$ShadToggleTheme.lerp(a, b, t);
}
