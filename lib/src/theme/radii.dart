import 'package:flutter/widgets.dart';

/// Named steps on a corner-radius scale, mirroring Tailwind's `rounded-*`
/// utilities as shadcn/ui uses them.
///
/// Components pick a *token* rather than a number, so a single theme radius
/// drives the whole set consistently: cards stay proportionally rounder than
/// buttons, menu items proportionally tighter, and changing the theme radius
/// moves all of them together.
enum ShadRadiusToken {
  none,
  sm,

  /// The base step. `ShadThemeData.radius` is this one — it is what buttons,
  /// inputs and popovers use.
  md,
  lg,
  xl,
  xl2,
  xl3,
  xl4,

  /// Fully rounded, for pills and circles.
  full,
}

/// A corner-radius scale derived from one base radius.
///
/// shadcn/ui defines its scale relative to a single `--radius` custom
/// property:
///
/// ```css
/// --radius-sm: calc(var(--radius) * 0.6);
/// --radius-md: calc(var(--radius) * 0.8);
/// --radius-lg: var(--radius);
/// --radius-xl: calc(var(--radius) * 1.4);
/// ```
///
/// This package's `ShadThemeData.radius` is the *component* radius — the
/// `rounded-md` step, since that is what button and input use — so the
/// multipliers here are expressed relative to `md`. With the default 8px that
/// reproduces shadcn's scale exactly: sm 6, md 8, lg 10, xl 14, 2xl 16,
/// 3xl 24, 4xl 32.
@immutable
class ShadRadii {
  /// Creates a scale from the base (`md`) radius.
  const ShadRadii(this.md);

  /// The `md` step, i.e. the theme's component radius.
  final BorderRadius md;

  BorderRadius get none => BorderRadius.zero;

  BorderRadius get sm => _scale(0.75);

  BorderRadius get lg => _scale(1.25);

  BorderRadius get xl => _scale(1.75);

  BorderRadius get xl2 => _scale(2);

  BorderRadius get xl3 => _scale(3);

  BorderRadius get xl4 => _scale(4);

  BorderRadius get full => const BorderRadius.all(Radius.circular(9999));

  /// The radius for [token].
  BorderRadius resolve(ShadRadiusToken token) => switch (token) {
    ShadRadiusToken.none => none,
    ShadRadiusToken.sm => sm,
    ShadRadiusToken.md => md,
    ShadRadiusToken.lg => lg,
    ShadRadiusToken.xl => xl,
    ShadRadiusToken.xl2 => xl2,
    ShadRadiusToken.xl3 => xl3,
    ShadRadiusToken.xl4 => xl4,
    ShadRadiusToken.full => full,
  };

  BorderRadius _scale(double factor) => BorderRadius.only(
    topLeft: _scaleRadius(md.topLeft, factor),
    topRight: _scaleRadius(md.topRight, factor),
    bottomLeft: _scaleRadius(md.bottomLeft, factor),
    bottomRight: _scaleRadius(md.bottomRight, factor),
  );

  static Radius _scaleRadius(Radius radius, double factor) =>
      Radius.elliptical(radius.x * factor, radius.y * factor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ShadRadii && other.md == md);

  @override
  int get hashCode => md.hashCode;

  @override
  String toString() => 'ShadRadii(md: $md)';
}
