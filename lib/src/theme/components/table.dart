import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

part 'table.g.theme.dart';

/// {@template ShadTableTheme}
/// Theme for the `ShadTable` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadTableTheme with _$ShadTableTheme {
  /// {@macro ShadTableTheme}
  const ShadTableTheme({
    bool canMerge = true,
    this.diagonalDragBehavior,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.columnBuilder,
    this.rowBuilder,
    this.cellAlignment,
    this.cellHeight,
    this.cellPadding,
    this.cellStyle,
    this.cellHeaderStyle,
    this.cellFooterStyle,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadTable.diagonalDragBehavior}
  final DiagonalDragBehavior? diagonalDragBehavior;

  /// {@macro ShadTable.dragStartBehavior}
  final DragStartBehavior? dragStartBehavior;

  /// {@macro ShadTable.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// {@macro ShadTable.columnBuilder}
  final TableSpanBuilder? columnBuilder;

  /// {@macro ShadTable.rowBuilder}
  final TableSpanBuilder? rowBuilder;

  /// {@macro ShadTableCell.alignment}
  final Alignment? cellAlignment;

  /// {@macro ShadTableCell.height}
  final double? cellHeight;

  /// {@macro ShadTableCell.padding}
  final EdgeInsetsGeometry? cellPadding;

  /// Text style of header cells. Defaults to the text theme's `muted` at
  /// medium weight.
  final TextStyle? cellHeaderStyle;

  /// Text style of body cells. Defaults to the text theme's `muted`.
  final TextStyle? cellStyle;

  /// Text style of footer cells. Defaults to the text theme's `muted` at
  /// medium weight.
  final TextStyle? cellFooterStyle;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadTableTheme? lerp(
    ShadTableTheme? a,
    ShadTableTheme? b,
    double t,
  ) => _$ShadTableTheme.lerp(a, b, t);
}
