import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'sidebar.g.theme.dart';

@themeGen
@immutable
class ShadSidebarTheme with _$ShadSidebarTheme {
  const ShadSidebarTheme({
    bool canMerge = true,
    this.width,
    this.collapsedWidth,
    this.mobileWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.accentColor,
    this.accentForegroundColor,
    this.ringColor,
    this.ringWidth,
    this.headerPadding,
    this.footerPadding,
    this.groupPadding,
    this.contentGap,
    this.menuGap,
    this.groupLabelHeight,
    this.groupLabelPadding,
    this.groupLabelTextStyle,
    this.menuButtonHeight,
    this.menuButtonHeightSm,
    this.menuButtonHeightLg,
    this.menuButtonPadding,
    this.menuButtonGap,
    this.menuButtonRadius,
    this.menuButtonTextStyle,
    this.menuButtonTextStyleSm,
    this.iconSize,
    this.subMenuMargin,
    this.subMenuPadding,
    this.subButtonHeight,
    this.subButtonPadding,
    this.subButtonTextStyle,
    this.badgeTextStyle,
    this.duration,
    this.curve,
    this.floatingMargin,
    this.floatingRadius,
    this.floatingShadows,
    this.insetMargin,
    this.insetRadius,
    this.insetShadows,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadSidebar.width}
  final double? width;

  /// {@macro ShadSidebar.collapsedWidth}
  final double? collapsedWidth;

  /// {@macro ShadSidebar.mobileWidth}
  final double? mobileWidth;

  /// {@macro ShadSidebar.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadSidebar.foregroundColor}
  final Color? foregroundColor;

  /// {@macro ShadSidebar.borderColor}
  final Color? borderColor;

  /// The hover/active fill of menu buttons, shadcn's `bg-sidebar-accent`.
  final Color? accentColor;

  /// The text and icon colour on [accentColor].
  final Color? accentForegroundColor;

  /// The focus ring colour of sidebar items, shadcn's `ring-sidebar-ring`.
  final Color? ringColor;

  /// The focus ring width of sidebar items, shadcn's `focus-visible:ring-2`.
  final double? ringWidth;

  /// Padding around the header slot, shadcn's `p-2`.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding around the footer slot, shadcn's `p-2`.
  final EdgeInsetsGeometry? footerPadding;

  /// Padding around each group, shadcn's `p-2`.
  final EdgeInsetsGeometry? groupPadding;

  /// The gap between groups in the scrollable content, shadcn's `gap-2`.
  final double? contentGap;

  /// The gap between menu rows, shadcn's `gap-1`.
  final double? menuGap;

  /// Height of a group label row, shadcn's `h-8`.
  final double? groupLabelHeight;

  /// Padding of a group label, shadcn's `px-2`.
  final EdgeInsetsGeometry? groupLabelPadding;

  /// Text style of a group label, shadcn's
  /// `text-xs font-medium text-sidebar-foreground/70`.
  final TextStyle? groupLabelTextStyle;

  /// {@macro ShadSidebarMenuButton.height}
  final double? menuButtonHeight;

  /// Height of a small menu button, shadcn's `h-7`.
  final double? menuButtonHeightSm;

  /// Height of a large menu button, shadcn's `h-12`.
  final double? menuButtonHeightLg;

  /// Padding of a menu button, shadcn's `p-2`.
  final EdgeInsetsGeometry? menuButtonPadding;

  /// The gap between a menu button's icon and label, shadcn's `gap-2`.
  final double? menuButtonGap;

  /// Corner radius of menu buttons and group labels, shadcn's `rounded-md`.
  final BorderRadius? menuButtonRadius;

  /// Text style of a menu button, shadcn's `text-sm`.
  final TextStyle? menuButtonTextStyle;

  /// Text style of a small menu button, shadcn's `text-xs`.
  final TextStyle? menuButtonTextStyleSm;

  /// Icon size inside sidebar rows, shadcn's `[&>svg]:size-4`.
  final double? iconSize;

  /// Outer margin of a sub-menu, shadcn's `mx-3.5`.
  final EdgeInsetsGeometry? subMenuMargin;

  /// Inner padding of a sub-menu, shadcn's `px-2.5 py-0.5`.
  final EdgeInsetsGeometry? subMenuPadding;

  /// Height of a sub-menu button, shadcn's `h-7`.
  final double? subButtonHeight;

  /// Padding of a sub-menu button, shadcn's `px-2`.
  final EdgeInsetsGeometry? subButtonPadding;

  /// Text style of a sub-menu button, shadcn's `text-sm`.
  final TextStyle? subButtonTextStyle;

  /// Text style of a menu badge, shadcn's `text-xs font-medium`.
  final TextStyle? badgeTextStyle;

  /// Duration of the expand/collapse animation, shadcn's `duration-200`.
  final Duration? duration;

  /// Curve of the expand/collapse animation, shadcn's `ease-linear`.
  final Curve? curve;

  /// Outer margin of a floating sidebar, shadcn's `p-2`.
  final EdgeInsetsGeometry? floatingMargin;

  /// Corner radius of a floating sidebar, shadcn's `rounded-lg`.
  final BorderRadius? floatingRadius;

  /// Shadows of a floating sidebar, shadcn's `shadow-sm`.
  final List<BoxShadow>? floatingShadows;

  /// Outer margin of the content next to an inset sidebar, shadcn's `m-2`.
  final EdgeInsetsGeometry? insetMargin;

  /// Corner radius of the content next to an inset sidebar, shadcn's
  /// `rounded-xl`.
  final BorderRadius? insetRadius;

  /// Shadows of the content next to an inset sidebar, shadcn's `shadow-sm`.
  final List<BoxShadow>? insetShadows;

  static ShadSidebarTheme? lerp(
    ShadSidebarTheme? a,
    ShadSidebarTheme? b,
    double t,
  ) => _$ShadSidebarTheme.lerp(a, b, t);
}
