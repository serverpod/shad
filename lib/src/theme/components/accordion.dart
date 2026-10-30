import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'accordion.g.theme.dart';

/// {@template ShadAccordionTheme}
/// Theme for the `ShadAccordion` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadAccordionTheme with _$ShadAccordionTheme {
  /// {@macro ShadAccordionTheme}
  const ShadAccordionTheme({
    bool canMerge = true,
    this.iconData,
    this.iconEffects,
    this.padding,
    this.underlineTitleOnHover,
    this.titleStyle,
    this.curve,
    this.duration,
    this.maintainState,
    this.effects,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadAccordionItem.iconData}
  final IconData? iconData;

  /// {@macro ShadAccordionItem.iconEffects}
  final List<Effect<dynamic>>? iconEffects;

  /// {@macro ShadAccordionItem.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadAccordionItem.underlineTitleOnHover}
  final bool? underlineTitleOnHover;

  /// {@macro ShadAccordionItem.titleStyle}
  final TextStyle? titleStyle;

  /// {@macro ShadAccordionItem.curve}
  final Curve? curve;

  /// {@macro ShadAccordionItem.duration}
  final Duration? duration;

  /// {@macro ShadAccordion.maintainState}
  final bool? maintainState;

  /// {@macro ShadAccordionItem.effects}
  final List<Effect<dynamic>>? effects;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadAccordionTheme? lerp(
    ShadAccordionTheme? a,
    ShadAccordionTheme? b,
    double t,
  ) => _$ShadAccordionTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadAccordionTheme &&
      listEquals(iconEffects, other.iconEffects) &&
      listEquals(effects, other.effects) &&
      super == other.copyWith(iconEffects: iconEffects, effects: effects);

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(iconEffects ?? const []),
    Object.hashAll(effects ?? const []),
  );
}
