import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/utils/border.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'card.g.theme.dart';

/// {@template ShadCardTheme}
/// Theme for the `ShadCard` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadCardTheme with _$ShadCardTheme {
  /// {@macro ShadCardTheme}
  const ShadCardTheme({
    bool canMerge = true,
    this.backgroundColor,
    this.padding,
    this.radius,
    this.border,
    this.shadows,
    this.width,
    this.height,
    this.rowMainAxisAlignment,
    this.rowCrossAxisAlignment,
    this.columnMainAxisAlignment,
    this.columnCrossAxisAlignment,
    this.rowMainAxisSize,
    this.columnMainAxisSize,
    this.clipBehavior,
    this.titleStyle,
    this.descriptionStyle,
    this.gap,
    this.sectionGap,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadCard.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadCard.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadCard.radius}
  final BorderRadius? radius;

  /// {@macro ShadCard.border}
  final ShadBorder? border;

  /// {@macro ShadCard.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadCard.width}
  final double? width;

  /// {@macro ShadCard.height}
  final double? height;

  /// {@macro ShadCard.rowMainAxisAlignment}
  final MainAxisAlignment? rowMainAxisAlignment;

  /// {@macro ShadCard.rowCrossAxisAlignment}
  final CrossAxisAlignment? rowCrossAxisAlignment;

  /// {@macro ShadCard.columnMainAxisAlignment}
  final MainAxisAlignment? columnMainAxisAlignment;

  /// {@macro ShadCard.columnCrossAxisAlignment}
  final CrossAxisAlignment? columnCrossAxisAlignment;

  /// {@macro ShadCard.rowMainAxisSize}
  final MainAxisSize? rowMainAxisSize;

  /// {@macro ShadCard.columnMainAxisSize}
  final MainAxisSize? columnMainAxisSize;

  /// {@macro ShadCard.clipBehavior}
  final Clip? clipBehavior;

  /// {@macro ShadCard.titleStyle}
  final TextStyle? titleStyle;

  /// {@macro ShadCard.descriptionStyle}
  final TextStyle? descriptionStyle;

  /// {@macro ShadCard.gap}
  final double? gap;

  /// The space between a card's sections — header, content and footer —
  /// shadcn's `gap-(--card-spacing)`. [gap] stays the small gap between the
  /// title and its description. Null falls back to [gap].
  final double? sectionGap;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadCardTheme? lerp(
    ShadCardTheme? a,
    ShadCardTheme? b,
    double t,
  ) => _$ShadCardTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadCardTheme &&
      listEquals(shadows, other.shadows) &&
      super == other.copyWith(shadows: shadows);

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(shadows ?? const []),
  );
}
