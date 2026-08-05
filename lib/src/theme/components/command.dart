import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'command.g.theme.dart';

/// {@template ShadCommandTheme}
/// Theme for the `ShadCommand` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadCommandTheme with _$ShadCommandTheme {
  /// {@macro ShadCommandTheme}
  const ShadCommandTheme({
    bool canMerge = true,
    this.backgroundColor,
    this.decoration,
    this.padding,
    this.searchPadding,
    this.optionsPadding,
    this.groupHeadingStyle,
    this.groupHeadingPadding,
    this.itemPadding,
    this.itemTextStyle,
    this.itemSelectedBackgroundColor,
    this.itemSelectedForegroundColor,
    this.itemForegroundColor,
    this.itemRadius,
    this.itemGap,
    this.height,
    this.width,
    this.emptyPadding,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadCommand.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadCommand.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadCommand.padding}
  final EdgeInsetsGeometry? padding;

  /// The padding around the search field.
  final EdgeInsetsGeometry? searchPadding;

  /// The padding around the scrollable option list.
  final EdgeInsetsGeometry? optionsPadding;

  /// The style of a `ShadCommandGroup` heading.
  final TextStyle? groupHeadingStyle;

  /// The padding around a `ShadCommandGroup` heading.
  final EdgeInsetsGeometry? groupHeadingPadding;

  /// The padding inside a `ShadCommandItem`.
  final EdgeInsetsGeometry? itemPadding;

  /// The text style of a `ShadCommandItem`.
  final TextStyle? itemTextStyle;

  /// The background color of the highlighted item.
  final Color? itemSelectedBackgroundColor;

  /// The content color of the highlighted item.
  final Color? itemSelectedForegroundColor;

  /// The content color of a non-highlighted item.
  final Color? itemForegroundColor;

  /// The corner radius of an item.
  final BorderRadiusGeometry? itemRadius;

  /// The gap between an item's leading widget, label and trailing widget.
  final double? itemGap;

  /// {@macro ShadCommand.height}
  final double? height;

  /// {@macro ShadCommand.width}
  final double? width;

  /// The padding around the empty state.
  final EdgeInsetsGeometry? emptyPadding;

  static ShadCommandTheme? lerp(
    ShadCommandTheme? a,
    ShadCommandTheme? b,
    double t,
  ) => _$ShadCommandTheme.lerp(a, b, t);
}
