// The theme for an individual size of ShadButton.
import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'button_sizes.g.theme.dart';

/// {@template ShadButtonSizeTheme}
/// The metrics of one `ShadButton` size: its height, padding and icon size.
/// {@endtemplate}
@themeGen
@immutable
class ShadButtonSizeTheme with _$ShadButtonSizeTheme {
  /// {@macro ShadButtonSizeTheme}
  const ShadButtonSizeTheme({
    bool canMerge = true,
    required this.height,
    required this.padding,
    this.width,
    this.iconSize,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// The button's height.
  final double height;

  /// The padding around the button's content.
  final EdgeInsetsGeometry padding;

  /// A fixed width. The icon sizes set it to make a square button. Null lets
  /// the button size itself to its content.
  final double? width;

  /// Size handed to icons inside the button, shadcn's
  /// `[&_svg:not([class*='size-'])]:size-4`.
  ///
  /// Null falls back to the ambient [IconTheme]; an icon that sets its own
  /// size always wins, as the `:not` in the reference selector does.
  final double? iconSize;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadButtonSizeTheme? lerp(
    ShadButtonSizeTheme? a,
    ShadButtonSizeTheme? b,
    double t,
  ) {
    return _$ShadButtonSizeTheme.lerp(a, b, t);
  }
}

/// {@template ShadButtonSizesTheme}
/// The theme for the predefined sizes of ShadButton.
/// {@endtemplate}
@themeGen
@immutable
class ShadButtonSizesTheme with _$ShadButtonSizesTheme {
  /// {@macro ShadButtonSizesTheme}
  const ShadButtonSizesTheme({
    bool canMerge = true,
    this.regular,
    this.sm,
    this.lg,
    this.icon,
    this.iconSm,
    this.iconLg,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// The default size, shadcn's `size-default`.
  final ShadButtonSizeTheme? regular;

  /// The small size, shadcn's `size-sm`.
  final ShadButtonSizeTheme? sm;

  /// The large size, shadcn's `size-lg`.
  final ShadButtonSizeTheme? lg;

  /// The square sizes, shadcn's `size-icon`, `size-icon-sm` and
  /// `size-icon-lg`.
  ///
  /// Separate from [sm]/[lg] because the reference sizes an icon button's
  /// glyph independently of a text button's at the same step.
  final ShadButtonSizeTheme? icon;

  /// The small square size, shadcn's `size-icon-sm`. See [icon].
  final ShadButtonSizeTheme? iconSm;

  /// The large square size, shadcn's `size-icon-lg`. See [icon].
  final ShadButtonSizeTheme? iconLg;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadButtonSizesTheme? lerp(
    ShadButtonSizesTheme? a,
    ShadButtonSizesTheme? b,
    double t,
  ) => _$ShadButtonSizesTheme.lerp(a, b, t);
}
