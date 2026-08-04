import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty.g.theme.dart';

/// {@template ShadEmptyTheme}
/// Theme for the `ShadEmpty` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadEmptyTheme with _$ShadEmptyTheme {
  /// {@macro ShadEmptyTheme}
  const ShadEmptyTheme({
    bool canMerge = true,
    this.padding,
    this.gap,
    this.iconSize,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadEmpty.padding}
  final EdgeInsetsGeometry? padding;

  /// The vertical gap between the icon, title, description and actions.
  final double? gap;

  /// {@macro ShadEmpty.iconSize}
  final double? iconSize;

  /// The color applied to the icon.
  final Color? iconColor;

  /// {@macro ShadEmpty.titleStyle}
  final TextStyle? titleStyle;

  /// {@macro ShadEmpty.descriptionStyle}
  final TextStyle? descriptionStyle;

  /// {@macro ShadEmpty.crossAxisAlignment}
  final CrossAxisAlignment? crossAxisAlignment;

  /// {@macro ShadEmpty.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  static ShadEmptyTheme? lerp(
    ShadEmptyTheme? a,
    ShadEmptyTheme? b,
    double t,
  ) => _$ShadEmptyTheme.lerp(a, b, t);
}
