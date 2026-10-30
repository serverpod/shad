import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'select.g.theme.dart';

/// The minimum width of a select's trigger and options when none is set.
@Deprecated(
  'Use ShadSelect.defaultMinWidth. Will be removed in the next major version.',
)
const kDefaultSelectMinWidth = 128.0;

/// The maximum height of a select's options when none is set.
@Deprecated(
  'Use ShadSelect.defaultMaxHeight. Will be removed in the next major version.',
)
const kDefaultSelectMaxHeight = 384.0;

/// {@template ShadSelectTheme}
/// Theme for the `ShadSelect` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadSelectTheme with _$ShadSelectTheme {
  /// {@macro ShadSelectTheme}
  const ShadSelectTheme({
    bool canMerge = true,
    this.decoration,
    this.placeholderStyle,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.minHeight,
    this.padding,
    this.optionsPadding,
    this.showScrollToTopChevron,
    this.showScrollToBottomChevron,
    this.anchor,
    this.searchPadding,
    this.clearSearchOnClose,
    this.effects,
    this.shadows,
    this.filter,
    this.popoverReverseDuration,
    this.popoverDecoration,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadPopover.reverseDuration}
  final Duration? popoverReverseDuration;

  /// {@macro ShadSelect.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadSelect.placeholderStyle}
  final TextStyle? placeholderStyle;

  /// {@macro ShadSelect.minWidth}
  final double? minWidth;

  /// {@macro ShadSelect.maxWidth}
  final double? maxWidth;

  /// {@macro ShadSelect.maxHeight}
  final double? maxHeight;

  /// {@macro ShadSelect.minHeight}
  final double? minHeight;

  /// {@macro ShadSelect.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadSelect.optionsPadding}
  final EdgeInsetsGeometry? optionsPadding;

  /// {@macro ShadSelect.showScrollToTopChevron}
  final bool? showScrollToTopChevron;

  /// {@macro ShadSelect.showScrollToBottomChevron}
  final bool? showScrollToBottomChevron;

  /// {@macro ShadSelect.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadSelect.searchPadding}
  final EdgeInsetsGeometry? searchPadding;

  /// {@macro ShadSelect.clearSearchOnClose}
  final bool? clearSearchOnClose;

  /// {@macro ShadPopover.filter}
  final ImageFilter? filter;

  /// The decoration of the options popover, as opposed to [decoration] which
  /// styles the trigger. Menus can carry their own palette (see
  /// `ShadThemeData.menuColorScheme`), so the options surface cannot simply
  /// fall back to the page's `ShadPopoverTheme`.
  final ShadDecoration? popoverDecoration;

  /// {@macro ShadPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadPopover.shadows}
  final List<BoxShadow>? shadows;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadSelectTheme? lerp(
    ShadSelectTheme? a,
    ShadSelectTheme? b,
    double t,
  ) => _$ShadSelectTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadSelectTheme &&
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
