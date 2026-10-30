import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:shad/src/components/button.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'tabs.g.theme.dart';

/// {@template ShadTabsTheme}
/// Theme for the `ShadTabs` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadTabsTheme with _$ShadTabsTheme {
  /// {@macro ShadTabsTheme}
  const ShadTabsTheme({
    bool canMerge = true,
    this.gap,
    this.tabsGap,
    this.expandTabs,
    this.tabBarAlignment,
    this.dragStartBehavior,
    this.physics,
    this.padding,
    this.decoration,
    this.tabBarConstraints,
    this.contentConstraints,
    this.expandContent,
    this.tabWidth,
    this.tabBackgroundColor,
    this.tabSelectedBackgroundColor,
    this.tabHoverBackgroundColor,
    this.tabSelectedHoverBackgroundColor,
    this.tabPadding,
    this.tabDecoration,
    this.tabSelectedDecoration,
    this.tabForegroundColor,
    this.tabSelectedForegroundColor,
    this.tabTextStyle,
    this.tabShadows,
    this.tabSelectedShadows,
    this.tabSize,
    this.tabCursor,
    this.tabHoverForegroundColor,
    this.tabPressedBackgroundColor,
    this.tabPressedForegroundColor,
    this.tabGradient,
    this.tabTextDecoration,
    this.tabHoverTextDecoration,
    this.tabMainAxisAlignment,
    this.tabCrossAxisAlignment,
    this.tabHoverStrategies,
    this.longPressDuration,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadTabs.gap}
  final double? gap;

  /// {@macro ShadTabs.tabsGap}
  final double? tabsGap;

  /// {@macro ShadTabs.expandTabs}
  final bool? expandTabs;

  /// {@macro ShadTabs.tabBarAlignment}
  final Alignment? tabBarAlignment;

  /// {@macro ShadTabs.dragStartBehavior}
  final DragStartBehavior? dragStartBehavior;

  /// {@macro ShadTabs.physics}
  final ScrollPhysics? physics;

  /// {@macro ShadTabs.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadTabs.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadTabs.tabBarConstraints}
  final BoxConstraints? tabBarConstraints;

  /// {@macro ShadTabs.contentConstraints}
  final BoxConstraints? contentConstraints;

  /// {@macro ShadTab.expand}
  final bool? expandContent;

  /// {@macro ShadTab.width}
  final double? tabWidth;

  /// {@macro ShadTab.backgroundColor}
  final Color? tabBackgroundColor;

  /// {@macro ShadTab.selectedBackgroundColor}
  final Color? tabSelectedBackgroundColor;

  /// {@macro ShadTab.hoverBackgroundColor}
  final Color? tabHoverBackgroundColor;

  /// {@macro ShadTab.selectedHoverBackgroundColor}
  final Color? tabSelectedHoverBackgroundColor;

  /// {@macro ShadTab.padding}
  final EdgeInsetsGeometry? tabPadding;

  /// {@macro ShadTab.decoration}
  final ShadDecoration? tabDecoration;

  /// {@macro ShadTab.selectedDecoration}
  final ShadDecoration? tabSelectedDecoration;

  /// {@macro ShadTab.foregroundColor}
  final Color? tabForegroundColor;

  /// {@macro ShadTab.selectedForegroundColor}
  final Color? tabSelectedForegroundColor;

  /// {@macro ShadTab.textStyle}
  final TextStyle? tabTextStyle;

  /// {@macro ShadTab.shadows}
  final List<BoxShadow>? tabShadows;

  /// {@macro ShadTab.selectedShadows}
  final List<BoxShadow>? tabSelectedShadows;

  /// {@macro ShadTab.size}
  final ShadButtonSize? tabSize;

  /// {@macro ShadTab.cursor}
  final MouseCursor? tabCursor;

  /// {@macro ShadTab.hoverForegroundColor}
  final Color? tabHoverForegroundColor;

  /// {@macro ShadTab.pressedBackgroundColor}
  final Color? tabPressedBackgroundColor;

  /// {@macro ShadTab.pressedForegroundColor}
  final Color? tabPressedForegroundColor;

  /// {@macro ShadTab.gradient}
  final Gradient? tabGradient;

  /// {@macro ShadTab.textDecoration}
  final TextDecoration? tabTextDecoration;

  /// {@macro ShadTab.hoverTextDecoration}
  final TextDecoration? tabHoverTextDecoration;

  /// {@macro ShadButton.mainAxisAlignment}
  final MainAxisAlignment? tabMainAxisAlignment;

  /// {@macro ShadButton.crossAxisAlignment}
  final CrossAxisAlignment? tabCrossAxisAlignment;

  /// {@macro ShadButton.hoverStrategies}
  final ShadHoverStrategies? tabHoverStrategies;

  /// {@macro ShadButton.longPressDuration}
  final Duration? longPressDuration;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadTabsTheme? lerp(
    ShadTabsTheme? a,
    ShadTabsTheme? b,
    double t,
  ) => _$ShadTabsTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadTabsTheme &&
      listEquals(tabShadows, other.tabShadows) &&
      listEquals(tabSelectedShadows, other.tabSelectedShadows) &&
      super ==
          other.copyWith(
            tabShadows: tabShadows,
            tabSelectedShadows: tabSelectedShadows,
          );

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(tabShadows ?? const []),
    Object.hashAll(tabSelectedShadows ?? const []),
  );
}
