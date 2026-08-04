import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'collapsible.g.theme.dart';

/// {@template ShadCollapsibleTheme}
/// Theme for the `ShadCollapsible` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadCollapsibleTheme with _$ShadCollapsibleTheme {
  /// {@macro ShadCollapsibleTheme}
  const ShadCollapsibleTheme({
    bool canMerge = true,
    this.duration,
    this.curve,
    this.reverseDuration,
    this.reverseCurve,
    this.crossAxisAlignment,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadCollapsible.duration}
  final Duration? duration;

  /// {@macro ShadCollapsible.curve}
  final Curve? curve;

  /// {@macro ShadCollapsible.reverseDuration}
  final Duration? reverseDuration;

  /// {@macro ShadCollapsible.reverseCurve}
  final Curve? reverseCurve;

  /// {@macro ShadCollapsible.crossAxisAlignment}
  final CrossAxisAlignment? crossAxisAlignment;

  static ShadCollapsibleTheme? lerp(
    ShadCollapsibleTheme? a,
    ShadCollapsibleTheme? b,
    double t,
  ) => _$ShadCollapsibleTheme.lerp(a, b, t);
}
