import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/border.dart';
import 'package:shad/src/utils/shadow.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'decorator.g.theme.dart';

/// {@template ShadDecoration}
/// The border, fill and label styling of a control, applied by [ShadDecorator].
///
/// A control has a primary border drawn on its edge and an optional secondary
/// border drawn outside it, which is how the focus ring is painted. Each has a
/// normal, focused and error form. The label, description and error fields
/// style the text around form fields.
/// {@endtemplate}
@themeGen
@immutable
class ShadDecoration with _$ShadDecoration {
  /// {@macro ShadDecoration}
  const ShadDecoration({
    bool canMerge = true,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.secondaryBorder,
    this.secondaryFocusedBorder,
    this.secondaryErrorBorder,
    this.labelStyle,
    this.errorLabelStyle,
    this.errorStyle,
    this.descriptionStyle,
    this.labelPadding,
    this.descriptionPadding,
    this.errorPadding,
    this.fallbackToBorder,
    this.color,
    this.image,
    this.shadows,
    this.gradient,
    this.backgroundBlendMode,
    this.shape,
    this.hasError,
    this.fallbackToLabelStyle,
    this.disableSecondaryBorder,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// A decoration with no borders that replaces, rather than merges into, the
  /// decoration it is merged with.
  static const ShadDecoration none = ShadDecoration(
    canMerge: false,
    border: ShadBorder.none,
    focusedBorder: ShadBorder.none,
    errorBorder: ShadBorder.none,
    secondaryBorder: ShadBorder.none,
    secondaryFocusedBorder: ShadBorder.none,
    secondaryErrorBorder: ShadBorder.none,
  );

  /// The text style of a field's label.
  final TextStyle? labelStyle;

  /// The text style of a field's label while the field has an error. See
  /// [fallbackToLabelStyle].
  final TextStyle? errorLabelStyle;

  /// The border drawn on the control's edge.
  final ShadBorder? border;

  /// The border drawn on the control's edge while it has focus.
  final ShadBorder? focusedBorder;

  /// The border drawn on the control's edge while [hasError] is true.
  final ShadBorder? errorBorder;

  /// The border drawn outside the control, such as shadcn's `ring-*`.
  final ShadBorder? secondaryBorder;

  /// The outer border while the control has focus. This is the focus ring.
  final ShadBorder? secondaryFocusedBorder;

  /// The outer border while [hasError] is true.
  final ShadBorder? secondaryErrorBorder;

  /// The text style of a field's error message.
  final TextStyle? errorStyle;

  /// The text style of a field's description.
  final TextStyle? descriptionStyle;

  /// The padding around a field's label. Defaults to 8 below it.
  final EdgeInsetsGeometry? labelPadding;

  /// The padding around a field's description. Defaults to 8 above it.
  final EdgeInsetsGeometry? descriptionPadding;

  /// The padding around a field's error message. Defaults to 8 above it.
  final EdgeInsetsGeometry? errorPadding;

  /// The fill colour of the control.
  final Color? color;

  /// An image painted inside the control.
  final DecorationImage? image;

  /// The shadows painted outside the control.
  ///
  /// They are clipped to the area outside the control's outline, as CSS does.
  final List<BoxShadow>? shadows;

  /// A gradient painted inside the control, instead of [color].
  final Gradient? gradient;

  /// The blend mode of [color] or [gradient] with the content behind the
  /// control.
  final BlendMode? backgroundBlendMode;

  /// The shape of the control. Defaults to [BoxShape.rectangle].
  final BoxShape? shape;

  /// Whether the control shows its error borders and error label style.
  /// Defaults to false.
  final bool? hasError;

  /// Whether to skip the secondary borders. Defaults to
  /// `ShadThemeData.disableSecondaryBorder`.
  final bool? disableSecondaryBorder;

  /// Whether to fallback to the [border] if no [focusedBorder] or [errorBorder]
  /// is provided, defaults to true.
  ///
  /// This also affects the [secondaryBorder] with the same conditions.
  final bool? fallbackToBorder;

  /// Whether to fallback to the [labelStyle] if no [errorLabelStyle] is
  /// provided, defaults to true.
  final bool? fallbackToLabelStyle;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadDecoration? lerp(
    ShadDecoration? a,
    ShadDecoration? b,
    double t,
  ) => _$ShadDecoration.lerp(a, b, t);

  @override
  String toString() {
    return '''ShadDecoration(border: $border, focusedBorder: $focusedBorder, errorBorder: $errorBorder, secondaryBorder: $secondaryBorder, secondaryFocusedBorder: $secondaryFocusedBorder, secondaryErrorBorder: $secondaryErrorBorder, labelStyle: $labelStyle, errorLabelStyle: $errorLabelStyle, errorStyle: $errorStyle, descriptionStyle: $descriptionStyle, labelPadding: $labelPadding, descriptionPadding: $descriptionPadding, errorPadding: $errorPadding, fallbackToBorder: $fallbackToBorder, color: $color, image: $image, shadows: $shadows, gradient: $gradient, backgroundBlendMode: $backgroundBlendMode, shape: $shape, hasError: $hasError, fallbackToLabelStyle: $fallbackToLabelStyle, disableSecondaryBorder: $disableSecondaryBorder)''';
  }

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadDecoration &&
      listEquals(shadows, other.shadows) &&
      super == other.copyWith(shadows: shadows);

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(shadows ?? const []),
  );
}

/// Paints a [ShadDecoration] around [child].
///
/// Picks the normal, focused or error form of each border from [focused] and
/// `decoration.hasError`, and merges [decoration] over
/// `ShadThemeData.decoration`.
class ShadDecorator extends StatelessWidget {
  /// Creates a decorator.
  const ShadDecorator({
    super.key,
    this.child,
    this.decoration,
    this.focused = false,
  });

  /// The child to decorate.
  final Widget? child;

  /// The decoration to apply to the child.
  final ShadDecoration? decoration;

  /// Whether the child has focus, defaults to false.
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final textDirection = Directionality.of(context);

    final effectiveDecoration = theme.decoration.merge(decoration);

    final effectiveFallbackToBorder =
        effectiveDecoration.fallbackToBorder ?? true;

    final effectiveDisableSecondaryBorder =
        effectiveDecoration.disableSecondaryBorder ??
        theme.disableSecondaryBorder;

    final hasError = effectiveDecoration.hasError ?? false;

    final fallbackBorder = switch (focused) {
      true => effectiveDecoration.focusedBorder,
      false => effectiveDecoration.border,
    };

    var border = switch (hasError) {
      true => effectiveDecoration.errorBorder,
      false => fallbackBorder,
    };

    if (effectiveFallbackToBorder && border == null) {
      border = fallbackBorder ?? effectiveDecoration.border;
    }

    final fallbackSecondaryBorder = switch (focused) {
      true => effectiveDecoration.secondaryFocusedBorder,
      false => effectiveDecoration.secondaryBorder,
    };

    var secondaryBorder = switch (hasError) {
      true => effectiveDecoration.secondaryErrorBorder,
      false => fallbackSecondaryBorder,
    };

    if (effectiveFallbackToBorder && secondaryBorder == null) {
      secondaryBorder =
          fallbackSecondaryBorder ?? effectiveDecoration.secondaryBorder;
    }

    // The shadows go on the wrapper rather than the decoration itself so they
    // are clipped to the control's own outline; see [ShadShadowDecoration].
    final primaryDecoration = ShadShadowDecoration(
      shadows: effectiveDecoration.shadows ?? const [],
      decoration: switch (border) {
        final ShadRoundedSuperellipseBorder border => ShapeDecoration(
          color: effectiveDecoration.color,
          image: effectiveDecoration.image,
          gradient: effectiveDecoration.gradient,
          shape: border.toBorder(
            textDirection: textDirection,
            defaultRadius: theme.radius,
          ),
        ),
        final ShadBorder? border => BoxDecoration(
          border: true == border?.hasBorder ? border?.toBorder() : null,
          borderRadius: effectiveDecoration.shape == BoxShape.circle
              ? null
              : border?.radius,
          color: effectiveDecoration.color,
          shape: effectiveDecoration.shape ?? BoxShape.rectangle,
          backgroundBlendMode: effectiveDecoration.backgroundBlendMode,
          gradient: effectiveDecoration.gradient,
          image: effectiveDecoration.image,
        ),
      },
    );

    Widget decorated = Container(
      decoration: primaryDecoration,
      padding: border?.padding,
      child: child,
    );

    if (secondaryBorder != null && !effectiveDisableSecondaryBorder) {
      decorated = Padding(
        padding: secondaryBorder.padding ?? EdgeInsets.zero,
        child: CustomPaint(
          foregroundPainter: ShadOutwardBorderPainter(
            border: secondaryBorder.toBorder(),
            offset: secondaryBorder.offset ?? 0,
            radius:
                secondaryBorder.radius?.resolve(textDirection) ??
                BorderRadius.zero,
            textDirection: textDirection,
          ),
          child: decorated,
        ),
      );
    }

    return decorated;
  }
}

/// {@template shadOutwardBorderPainter}
/// A [CustomPainter] that paints a border outward from the given rectangle.
/// {@endtemplate}
class ShadOutwardBorderPainter extends CustomPainter {
  /// {@macro shadOutwardBorderPainter}
  const ShadOutwardBorderPainter({
    required this.border,
    required this.offset,
    required this.radius,
    required this.textDirection,
  });

  /// The border to paint.
  final Border border;

  /// The offset to inflate the border by.
  final double offset;

  /// The radius of the border.
  final BorderRadius? radius;

  /// The text direction to use when painting the border.
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    border.paint(
      canvas,
      (Offset.zero & size).inflate(offset),
      borderRadius: radius,
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(covariant ShadOutwardBorderPainter oldDelegate) {
    return border != oldDelegate.border ||
        offset != oldDelegate.offset ||
        radius != oldDelegate.radius ||
        textDirection != oldDelegate.textDirection;
  }
}
