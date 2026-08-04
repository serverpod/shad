import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'skeleton.g.theme.dart';

/// {@template ShadSkeletonTheme}
/// Theme for the `ShadSkeleton` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadSkeletonTheme with _$ShadSkeletonTheme {
  /// {@macro ShadSkeletonTheme}
  const ShadSkeletonTheme({
    bool canMerge = true,
    this.color,
    this.highlightColor,
    this.radius,
    this.duration,
    this.curve,
    this.animate,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadSkeleton.color}
  final Color? color;

  /// {@macro ShadSkeleton.highlightColor}
  final Color? highlightColor;

  /// {@macro ShadSkeleton.radius}
  final BorderRadiusGeometry? radius;

  /// {@macro ShadSkeleton.duration}
  final Duration? duration;

  /// {@macro ShadSkeleton.curve}
  final Curve? curve;

  /// {@macro ShadSkeleton.animate}
  final bool? animate;

  static ShadSkeletonTheme? lerp(
    ShadSkeletonTheme? a,
    ShadSkeletonTheme? b,
    double t,
  ) => _$ShadSkeletonTheme.lerp(a, b, t);
}
