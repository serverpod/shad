import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/utils/border.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'kbd.g.theme.dart';

/// {@template ShadKbdTheme}
/// Theme for the `ShadKbd` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadKbdTheme with _$ShadKbdTheme {
  /// {@macro ShadKbdTheme}
  const ShadKbdTheme({
    bool canMerge = true,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.padding,
    this.textStyle,
    this.gap,
    this.minWidth,
    this.height,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadKbd.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadKbd.foregroundColor}
  final Color? foregroundColor;

  /// {@macro ShadKbd.border}
  final ShadBorder? border;

  /// {@macro ShadKbd.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadKbd.textStyle}
  final TextStyle? textStyle;

  /// The gap between adjacent keys in a `ShadKbd` group.
  final double? gap;

  /// The minimum width of a single key cap.
  final double? minWidth;

  /// The height of a single key cap, shadcn's `h-5`.
  ///
  /// A key cap has a fixed height so it stays key-shaped wherever it is put —
  /// inside a button, a table row, or a line of prose.
  final double? height;

  static ShadKbdTheme? lerp(ShadKbdTheme? a, ShadKbdTheme? b, double t) =>
      _$ShadKbdTheme.lerp(a, b, t);
}
