import 'package:flutter/widgets.dart';

import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'radio.g.theme.dart';

@themeGen
@immutable
class ShadRadioTheme with _$ShadRadioTheme {
  const ShadRadioTheme({
    bool canMerge = true,
    this.color,
    this.duration,
    this.decoration,
    this.checkedDecoration,
    this.size,
    this.padding,
    this.circleSize,
    this.axis,
    this.spacing,
    this.runSpacing,
    this.alignment,
    this.runAlignment,
    this.crossAxisAlignment,
    this.radioPadding,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadRadio.color}
  final Color? color;

  /// {@macro ShadRadio.size}
  final double? size;

  /// {@macro ShadRadio.duration}
  final Duration? duration;

  /// {@macro ShadRadio.decoration}
  final ShadDecoration? decoration;

  /// The decoration while selected, when it differs from [decoration]: the
  /// reference fills the circle with the primary (`data-checked:bg-primary
  /// data-checked:border-primary`) and draws a primary-foreground dot, so the
  /// selected radio cannot keep the unchecked outline. Null means "same as
  /// [decoration]".
  final ShadDecoration? checkedDecoration;

  /// {@macro ShadRadio.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadRadio.circleSize}
  final double? circleSize;

  /// {@macro ShadRadioGroup.axis}
  final Axis? axis;

  /// {@macro ShadRadioGroup.spacing}
  final double? spacing;

  /// {@macro ShadRadioGroup.runSpacing}
  final double? runSpacing;

  /// {@macro ShadRadioGroup.alignment}
  final WrapAlignment? alignment;

  /// {@macro ShadRadioGroup.runAlignment}
  final WrapAlignment? runAlignment;

  /// {@macro ShadRadioGroup.crossAxisAlignment}
  final WrapCrossAlignment? crossAxisAlignment;

  /// {@macro ShadRadio.radioPadding}
  final EdgeInsetsGeometry? radioPadding;

  static ShadRadioTheme? lerp(
    ShadRadioTheme? a,
    ShadRadioTheme? b,
    double t,
  ) => _$ShadRadioTheme.lerp(a, b, t);
}
