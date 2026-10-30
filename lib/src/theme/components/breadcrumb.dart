import 'package:flutter/widgets.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'breadcrumb.g.theme.dart';

/// {@template ShadBreadcrumbTheme}
/// Theme for the `ShadBreadcrumb` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadBreadcrumbTheme with _$ShadBreadcrumbTheme {
  /// {@macro ShadBreadcrumbTheme}
  const ShadBreadcrumbTheme({
    bool canMerge = true,
    this.separator,
    this.ellipsis,
    this.separatorSize,
    this.separatorColor,
    this.ellipsisSize,
    this.spacing,
    this.itemTextStyle,
    this.linkTextStyle,
    this.linkNormalTextColor,
    this.linkHoverTextColor,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.dropdownMenuBackgroundColor,
    this.dropdownMenuPadding,
    this.dropdownTextStyle,
    this.dropdownItemPadding,
    this.dropdownMenuAnchor,
    this.dropdownArrowGap,
    this.lastItemTextColor,
    this.showDropdownArrow,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// The widget between items. Defaults to `ShadBreadcrumbSeparator`.
  final Widget? separator;

  /// The widget `ShadBreadcrumbEllipsis` shows for collapsed items. Defaults
  /// to Lucide's ellipsis icon at `ellipsisSize`.
  final Widget? ellipsis;

  /// {@macro ShadBreadcrumb.separatorSize}
  final double? separatorSize;

  /// {@macro ShadBreadcrumb.separatorColor}
  final Color? separatorColor;

  /// {@macro ShadBreadcrumb.ellipsisSize}
  final double? ellipsisSize;

  /// {@macro ShadBreadcrumb.spacing}
  final double? spacing;

  /// {@macro ShadBreadcrumb.itemTextStyle}
  final TextStyle? itemTextStyle;

  /// {@macro ShadBreadcrumb.linkTextStyle}
  final TextStyle? linkTextStyle;

  /// {@macro ShadBreadcrumb.linkNormalTextColor}
  final Color? linkNormalTextColor;

  /// {@macro ShadBreadcrumb.linkHoverTextColor}
  final Color? linkHoverTextColor;

  /// {@macro ShadBreadcrumb.wrapAlignment}
  final WrapAlignment? mainAxisAlignment;

  /// {@macro ShadBreadcrumb.wrapCrossAxisAlignment}
  final WrapCrossAlignment? crossAxisAlignment;

  /// {@macro ShadBreadcrumb.dropdownMenuBackgroundColor}
  final Color? dropdownMenuBackgroundColor;

  /// {@macro ShadBreadcrumb.dropdownMenuPadding}
  final EdgeInsetsGeometry? dropdownMenuPadding;

  /// {@macro ShadBreadcrumb.dropdownTextStyle}
  final TextStyle? dropdownTextStyle;

  /// {@macro ShadBreadcrumb.dropdownItemPadding}
  final EdgeInsetsGeometry? dropdownItemPadding;

  /// {@macro ShadBreadcrumb.dropdownMenuAnchor}
  final ShadAnchorBase? dropdownMenuAnchor;

  /// {@macro ShadBreadcrumb.dropdownArrowGap}
  final double? dropdownArrowGap;

  /// {@macro ShadBreadcrumb.lastItemTextColor}
  final Color? lastItemTextColor;

  /// {@macro ShadBreadcrumb.showDropdownArrow}
  final bool? showDropdownArrow;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadBreadcrumbTheme? lerp(
    ShadBreadcrumbTheme? a,
    ShadBreadcrumbTheme? b,
    double t,
  ) => _$ShadBreadcrumbTheme.lerp(a, b, t);
}
