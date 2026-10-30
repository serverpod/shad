import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'scroll_area.g.theme.dart';

/// {@template ShadScrollAreaTheme}
/// Theme for `ShadScrollArea` and `ShadScrollbar`.
/// {@endtemplate}
@themeGen
@immutable
class ShadScrollAreaTheme with _$ShadScrollAreaTheme {
  /// {@macro ShadScrollAreaTheme}
  const ShadScrollAreaTheme({
    bool canMerge = true,
    this.thickness,
    this.crossAxisMargin,
    this.mainAxisMargin,
    this.radius,
    this.thumbColor,
    this.thumbVisibility,
    this.fadeDuration,
    this.timeToFade,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadScrollbar.thickness}
  final double? thickness;

  /// {@macro ShadScrollbar.crossAxisMargin}
  final double? crossAxisMargin;

  /// {@macro ShadScrollbar.mainAxisMargin}
  final double? mainAxisMargin;

  /// {@macro ShadScrollbar.radius}
  final Radius? radius;

  /// {@macro ShadScrollbar.thumbColor}
  final Color? thumbColor;

  /// {@macro ShadScrollbar.thumbVisibility}
  final bool? thumbVisibility;

  /// {@macro ShadScrollbar.fadeDuration}
  final Duration? fadeDuration;

  /// {@macro ShadScrollbar.timeToFade}
  final Duration? timeToFade;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadScrollAreaTheme? lerp(
    ShadScrollAreaTheme? a,
    ShadScrollAreaTheme? b,
    double t,
  ) => _$ShadScrollAreaTheme.lerp(a, b, t);
}
