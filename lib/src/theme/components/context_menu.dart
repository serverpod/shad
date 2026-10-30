import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/components/button.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'context_menu.g.theme.dart';

/// {@template ShadContextMenuTheme}
/// Theme for the `ShadContextMenu` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadContextMenuTheme with _$ShadContextMenuTheme {
  /// {@macro ShadContextMenuTheme}
  const ShadContextMenuTheme({
    bool canMerge = true,
    this.constraints,
    this.padding,
    this.leadingPadding,
    this.trailingPadding,
    this.itemPadding,
    this.insetPadding,
    this.anchor,
    this.showDelay,
    this.height,
    this.buttonVariant,
    this.decoration,
    this.textStyle,
    this.selectedTextStyle,
    this.trailingTextStyle,
    this.selectedTrailingTextStyle,
    this.destructiveForegroundColor,
    this.destructiveSelectedBackgroundColor,
    this.itemConstraints,
    this.subMenuPadding,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.closeOnTap,
    this.effects,
    this.shadows,
    this.itemDecoration,
    this.filter,
    this.popoverReverseDuration,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadPopover.reverseDuration}
  final Duration? popoverReverseDuration;

  /// {@macro ShadContextMenu.constraints}
  final BoxConstraints? constraints;

  /// {@macro ShadContextMenu.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadContextMenuItem.leadingPadding}
  final EdgeInsetsGeometry? leadingPadding;

  /// {@macro ShadContextMenuItem.trailingPadding}
  final EdgeInsetsGeometry? trailingPadding;

  /// {@macro ShadContextMenuItem.padding}
  final EdgeInsetsGeometry? itemPadding;

  /// {@macro ShadContextMenuItem.insetPadding}
  final EdgeInsetsGeometry? insetPadding;

  /// {@macro ShadContextMenuItem.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadContextMenuItem.showDelay}
  final Duration? showDelay;

  /// {@macro ShadContextMenuItem.height}
  final double? height;

  /// {@macro ShadContextMenuItem.buttonVariant}
  final ShadButtonVariant? buttonVariant;

  /// {@macro ShadContextMenuItem.decoration}
  final ShadDecoration? itemDecoration;

  /// {@macro ShadContextMenuItem.textStyle}
  final TextStyle? textStyle;

  /// {@macro ShadContextMenuItem.selectedTextStyle}
  final TextStyle? selectedTextStyle;

  /// {@macro ShadContextMenuItem.trailingTextStyle}
  final TextStyle? trailingTextStyle;

  /// The style of an item's trailing widget while the item is hovered or its
  /// submenu is open — shadcn's shortcut going
  /// `group-focus:text-accent-foreground`.
  final TextStyle? selectedTrailingTextStyle;

  /// The text and icon colour of a destructive item,
  /// `data-[variant=destructive]:text-destructive`.
  final Color? destructiveForegroundColor;

  /// The highlight behind a hovered destructive item,
  /// `data-[variant=destructive]:focus:bg-destructive/10`
  /// (`/20` in dark mode).
  final Color? destructiveSelectedBackgroundColor;

  /// Constraints applied to every item row.
  final BoxConstraints? itemConstraints;

  /// {@macro ShadContextMenu.padding}
  final EdgeInsetsGeometry? subMenuPadding;

  /// {@macro ShadContextMenuItem.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadContextMenuItem.selectedBackgroundColor}
  final Color? selectedBackgroundColor;

  /// {@macro ShadContextMenuItem.closeOnTap}
  final bool? closeOnTap;

  /// {@macro ShadPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadPopover.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadPopover.filter}
  final ImageFilter? filter;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadContextMenuTheme? lerp(
    ShadContextMenuTheme? a,
    ShadContextMenuTheme? b,
    double t,
  ) => _$ShadContextMenuTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadContextMenuTheme &&
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
