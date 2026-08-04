import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'spinner.g.theme.dart';

/// {@template ShadSpinnerTheme}
/// Theme for the `ShadSpinner` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadSpinnerTheme with _$ShadSpinnerTheme {
  /// {@macro ShadSpinnerTheme}
  const ShadSpinnerTheme({
    bool canMerge = true,
    this.color,
    this.trackColor,
    this.size,
    this.strokeWidth,
    this.duration,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadSpinner.color}
  final Color? color;

  /// {@macro ShadSpinner.trackColor}
  final Color? trackColor;

  /// {@macro ShadSpinner.size}
  final double? size;

  /// {@macro ShadSpinner.strokeWidth}
  final double? strokeWidth;

  /// {@macro ShadSpinner.duration}
  final Duration? duration;

  static ShadSpinnerTheme? lerp(
    ShadSpinnerTheme? a,
    ShadSpinnerTheme? b,
    double t,
  ) => _$ShadSpinnerTheme.lerp(a, b, t);
}
