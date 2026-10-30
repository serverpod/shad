import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'popover.g.theme.dart';

/// {@template ShadPopoverTheme}
/// Theme for the `ShadPopover` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadPopoverTheme with _$ShadPopoverTheme {
  /// {@macro ShadPopoverTheme}
  const ShadPopoverTheme({
    bool canMerge = true,
    this.effects,
    this.shadows,
    this.reverseDuration,
    this.textStyle,
    this.padding,
    this.decoration,
    this.anchor,
    this.filter,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadPopover.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadPopover.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadPopover.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadPopover.filter}
  final ImageFilter? filter;

  /// {@macro ShadPopover.reverseDuration}
  final Duration? reverseDuration;

  /// {@macro ShadPopover.textStyle}
  final TextStyle? textStyle;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadPopoverTheme? lerp(
    ShadPopoverTheme? a,
    ShadPopoverTheme? b,
    double t,
  ) => _$ShadPopoverTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadPopoverTheme &&
      listEquals(effects, other.effects) &&
      listEquals(shadows, other.shadows) &&
      super == other.copyWith(effects: effects, shadows: shadows);

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(effects ?? const []),
    Object.hashAll(shadows ?? const []),
  );
}
