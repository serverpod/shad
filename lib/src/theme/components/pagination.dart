import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'pagination.g.theme.dart';

/// {@template ShadPaginationTheme}
/// Theme for the `ShadPagination` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadPaginationTheme with _$ShadPaginationTheme {
  /// {@macro ShadPaginationTheme}
  const ShadPaginationTheme({
    bool canMerge = true,
    this.gap,
    this.mainAxisAlignment,
    this.siblingCount,
    this.boundaryCount,
    this.showEdges,
    this.ellipsisTextStyle,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// The gap between pagination items.
  final double? gap;

  /// {@macro ShadPagination.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  /// {@macro ShadPagination.siblingCount}
  final int? siblingCount;

  /// {@macro ShadPagination.boundaryCount}
  final int? boundaryCount;

  /// {@macro ShadPagination.showEdges}
  final bool? showEdges;

  /// The style of the ellipsis shown in place of skipped pages.
  final TextStyle? ellipsisTextStyle;

  static ShadPaginationTheme? lerp(
    ShadPaginationTheme? a,
    ShadPaginationTheme? b,
    double t,
  ) => _$ShadPaginationTheme.lerp(a, b, t);
}
