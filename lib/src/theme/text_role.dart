import 'package:flutter/widgets.dart';

/// The typographic treatment of one *role* in a shadcn/ui style.
///
/// shadcn does not give every component its own type ramp; it reuses a handful
/// of treatments — a title, an interactive label, body copy, a caption, a
/// section overline, and the text inside a field — and each style redefines
/// them. `lyra` drops body copy to 12px, `mira` adds relaxed leading, and
/// `sera` sets labels in 12px semibold uppercase with wide tracking. Modelling
/// the roles rather than the components is what lets one style setting restyle
/// every piece of text consistently.
///
/// Sizes and line heights follow Tailwind: `text-xs` is 12/16, `text-sm`
/// 14/20, `text-base` 16/24, `text-lg` 18/28. Tracking is stored in logical
/// pixels — Tailwind's `tracking-wider` is `0.05em`, so at 18px it is 0.9.
@immutable
class ShadTextRole {
  const ShadTextRole({
    required this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.height,
    this.uppercase = false,
  });

  /// Font size in logical pixels.
  final double fontSize;

  /// Null keeps whatever the underlying text style has.
  final FontWeight? fontWeight;

  /// Letter spacing in logical pixels, not ems.
  final double? letterSpacing;

  /// Line height as a multiple of [fontSize]. Null uses Tailwind's default for
  /// this size.
  final double? height;

  /// Whether text in this role is upper-cased.
  ///
  /// A [TextStyle] cannot express CSS's `text-transform`, so components that
  /// own their text apply this through [applyCase]; anything taking a caller's
  /// widget leaves the text alone.
  final bool uppercase;

  /// Tailwind's default line height for a given size.
  static double defaultHeightFor(double fontSize) => switch (fontSize) {
    <= 12 => 16 / 12,
    <= 14 => 20 / 14,
    <= 16 => 24 / 16,
    <= 18 => 28 / 18,
    _ => 1.5,
  };

  /// Applies this role on top of [base], keeping its colour and family.
  TextStyle apply(TextStyle base) => base.copyWith(
    fontSize: fontSize,
    fontWeight: fontWeight ?? base.fontWeight,
    letterSpacing: letterSpacing,
    height: height ?? defaultHeightFor(fontSize),
  );

  /// Transforms [text] according to [uppercase].
  String applyCase(String text) => uppercase ? text.toUpperCase() : text;

  ShadTextRole copyWith({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    bool? uppercase,
  }) {
    return ShadTextRole(
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      height: height ?? this.height,
      uppercase: uppercase ?? this.uppercase,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShadTextRole &&
          other.fontSize == fontSize &&
          other.fontWeight == fontWeight &&
          other.letterSpacing == letterSpacing &&
          other.height == height &&
          other.uppercase == uppercase);

  @override
  int get hashCode =>
      Object.hash(fontSize, fontWeight, letterSpacing, height, uppercase);

  @override
  String toString() =>
      'ShadTextRole($fontSize, $fontWeight'
      '${uppercase ? ', uppercase' : ''})';
}
