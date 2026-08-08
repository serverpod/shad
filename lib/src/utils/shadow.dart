import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// {@template ShadShadowDecoration}
/// A [Decoration] that paints [shadows] behind [decoration] the way CSS paints
/// an outer `box-shadow`.
///
/// Flutter's [BoxShadow] cannot express that on its own:
///
/// * With the default [BlurStyle.normal] the whole blurred shape is painted
///   behind the element, so it shows through any transparent or translucent
///   fill as a grey wash.
/// * With [BlurStyle.outer] the hole is cut out of the *shadow's* own
///   rectangle — `rect.shift(offset).inflate(spreadRadius)`, see
///   `BoxDecoration`'s painter — which is a different shape from the element
///   whenever the shadow has an offset or a spread. Every shadow in `Shadows`
///   has both, so the cut-out lands below and inside the element: a `shadow-lg`
///   dialog loses the 7px of shadow directly under it and then starts again
///   with a hard edge.
///
/// CSS clips to the border box itself. This does the same: the shadows are
/// blurred normally and clipped to the region *outside*
/// [Decoration.getClipPath] of the wrapped decoration, which is where both
/// behaviours above were trying to get to.
///
/// [decoration] must not carry shadows of its own — pass them here instead.
/// Inset shadows are not covered by this; they stay on the wrapped decoration,
/// where [BlurStyle.inner] already clips them the way CSS clips `inset`.
/// {@endtemplate}
@immutable
class ShadShadowDecoration extends Decoration {
  /// {@macro ShadShadowDecoration}
  const ShadShadowDecoration({
    required this.decoration,
    this.shadows = const [],
  });

  /// A [ShadShadowDecoration] wrapping a [BoxDecoration] built from the usual
  /// [BoxDecoration] arguments, so a call site reads like the plain decoration
  /// it replaces.
  factory ShadShadowDecoration.box({
    List<BoxShadow> shadows = const [],
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return ShadShadowDecoration(
      shadows: shadows,
      decoration: BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
    );
  }

  /// The decoration painted on top of [shadows].
  final Decoration decoration;

  /// The outer shadows, painted behind [decoration] and clipped to the region
  /// outside its shape.
  final List<BoxShadow> shadows;

  @override
  EdgeInsetsGeometry get padding => decoration.padding;

  @override
  bool get isComplex => shadows.isNotEmpty || decoration.isComplex;

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) =>
      decoration.getClipPath(rect, textDirection);

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) =>
      decoration.hitTest(size, position, textDirection: textDirection);

  @override
  ShadShadowDecoration? lerpFrom(Decoration? a, double t) {
    final other = _wrap(a);
    if (other == null && a != null) return null;
    return ShadShadowDecoration(
      decoration: Decoration.lerp(other?.decoration, decoration, t)!,
      shadows: BoxShadow.lerpList(other?.shadows, shadows, t) ?? const [],
    );
  }

  @override
  ShadShadowDecoration? lerpTo(Decoration? b, double t) {
    final other = _wrap(b);
    if (other == null && b != null) return null;
    return ShadShadowDecoration(
      decoration: Decoration.lerp(decoration, other?.decoration, t)!,
      shadows: BoxShadow.lerpList(shadows, other?.shadows, t) ?? const [],
    );
  }

  /// Views a plain [BoxDecoration]/[ShapeDecoration] as a shadowless
  /// [ShadShadowDecoration] so the two can be lerped against each other.
  static ShadShadowDecoration? _wrap(Decoration? decoration) {
    return switch (decoration) {
      null => null,
      final ShadShadowDecoration d => d,
      final BoxDecoration d => ShadShadowDecoration(decoration: d),
      final ShapeDecoration d => ShadShadowDecoration(decoration: d),
      _ => null,
    };
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    final inner = onChanged == null
        ? decoration.createBoxPainter()
        : decoration.createBoxPainter(onChanged);
    return _ShadShadowPainter(this, inner, onChanged);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShadShadowDecoration &&
        other.decoration == decoration &&
        listEquals(other.shadows, shadows);
  }

  @override
  int get hashCode => Object.hash(decoration, Object.hashAll(shadows));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Decoration>('decoration', decoration))
      ..add(IterableProperty<BoxShadow>('shadows', shadows));
  }
}

class _ShadShadowPainter extends BoxPainter {
  _ShadShadowPainter(this._decoration, this._inner, [super.onChanged]);

  final ShadShadowDecoration _decoration;
  final BoxPainter _inner;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size != null) {
      paintOuterShadows(
        canvas,
        offset & size,
        shadows: _decoration.shadows,
        decoration: _decoration.decoration,
        textDirection: configuration.textDirection,
      );
    }
    _inner.paint(canvas, offset, configuration);
  }

  @override
  void dispose() {
    _inner.dispose();
    super.dispose();
  }
}

/// Paints [shadows] outside the shape [decoration] describes for [rect], the
/// way CSS clips an outer `box-shadow` to the border box.
///
/// {@macro ShadShadowDecoration}
void paintOuterShadows(
  Canvas canvas,
  Rect rect, {
  required List<BoxShadow> shadows,
  required Decoration decoration,
  TextDirection? textDirection,
}) {
  if (shadows.isEmpty || rect.isEmpty) return;

  // How far the shadows can reach from the element, so the clip has something
  // finite to subtract the border box from. Three sigma covers a gaussian.
  var reach = 0.0;
  for (final shadow in shadows) {
    final shadowReach =
        shadow.spreadRadius +
        shadow.blurSigma * 3 +
        math.max(shadow.offset.dx.abs(), shadow.offset.dy.abs());
    reach = math.max(reach, shadowReach);
  }
  if (reach <= 0) return;

  final direction = textDirection ?? TextDirection.ltr;
  final outside = Path.combine(
    PathOperation.difference,
    Path()..addRect(rect.inflate(reach + 1)),
    decoration.getClipPath(rect, direction),
  );

  canvas.save();
  canvas.clipPath(outside);
  for (final shadow in shadows) {
    final bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);
    if (bounds.isEmpty) continue;
    final paint = Paint()..color = shadow.color;
    if (shadow.blurSigma > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurSigma);
    }
    assert(() {
      if (debugDisableShadows) paint.maskFilter = null;
      return true;
    }());
    canvas.drawPath(_spreadPath(decoration, bounds, shadow, direction), paint);
  }
  canvas.restore();
}

/// The shadow's own shape at [bounds].
///
/// A CSS spread grows the corner radii along with the box, which
/// [Decoration.getClipPath] does not do for a [BoxDecoration] — it keeps the
/// element's radii on the larger rect. That is invisible under a wide blur but
/// not for the crisp spread-only shadows used as outlines, so rounded
/// rectangles are built here instead.
Path _spreadPath(
  Decoration decoration,
  Rect bounds,
  BoxShadow shadow,
  TextDirection textDirection,
) {
  if (decoration case BoxDecoration(
    shape: BoxShape.rectangle,
    :final borderRadius?,
  ) when shadow.spreadRadius != 0) {
    final radius = borderRadius.resolve(textDirection);
    Radius grow(Radius r) => Radius.elliptical(
      math.max(0, r.x + shadow.spreadRadius),
      math.max(0, r.y + shadow.spreadRadius),
    );
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        bounds,
        topLeft: grow(radius.topLeft),
        topRight: grow(radius.topRight),
        bottomLeft: grow(radius.bottomLeft),
        bottomRight: grow(radius.bottomRight),
      ),
    );
  }
  return decoration.getClipPath(bounds, textDirection);
}
