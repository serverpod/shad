import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'separator.g.theme.dart';

/// {@template ShadSeparatorTheme}
/// Theme for the `ShadSeparator` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadSeparatorTheme with _$ShadSeparatorTheme {
  /// {@macro ShadSeparatorTheme}
  const ShadSeparatorTheme({
    bool canMerge = true,
    this.verticalMargin,
    this.horizontalMargin,
    this.thickness,
    this.color,
    this.radius,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadSeparator.color}
  final Color? color;

  /// {@macro ShadSeparator.thickness}
  final double? thickness;

  /// The margin (or space) around the vertical divider.
  final EdgeInsetsGeometry? verticalMargin;

  /// The margin (or space) around the horizontal divider.
  final EdgeInsetsGeometry? horizontalMargin;

  /// {@macro ShadSeparator.radius}
  final BorderRadiusGeometry? radius;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadSeparatorTheme? lerp(
    ShadSeparatorTheme? a,
    ShadSeparatorTheme? b,
    double t,
  ) => _$ShadSeparatorTheme.lerp(a, b, t);
}
