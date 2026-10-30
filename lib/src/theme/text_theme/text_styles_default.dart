import 'package:flutter/widgets.dart';

/// The font family shad bundled before 1.0.
@Deprecated(
  'shad no longer bundles fonts, so this family resolves to nothing and text '
  'falls back to the platform font. Set ShadTextTheme(family: ...) to a font '
  'your app declares, or use ShadTextTheme.fromGoogleFont. '
  'Will be removed in the next major version.',
)
const kDefaultFontFamily = 'packages/shad/Inter';

/// The monospace font family shad bundled before 1.0.
@Deprecated(
  'shad no longer bundles fonts, so this family resolves to nothing and text '
  'falls back to the platform font. Use a monospace family your app declares. '
  'Will be removed in the next major version.',
)
const kDefaultFontFamilyMono = 'packages/shad/GeistMono';

/// The default text styles of a `ShadTextTheme`, before a style's text roles
/// are applied.
///
/// `family` is null by default, so text uses the platform font unless the
/// app sets one.
abstract class ShadTextDefaultTheme {
  /// The display heading: 48px, extra-bold.
  static TextStyle h1Large({
    String? family,
  }) {
    return TextStyle(
      fontSize: 48,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w800,
      height: 48 / 48,
      letterSpacing: -1.2,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// The `h1` heading: 36px, extra-bold.
  static TextStyle h1({
    String? family,
  }) {
    return TextStyle(
      fontSize: 36,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w800,
      height: 40 / 36,
      letterSpacing: -0.9,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// The `h2` heading: 30px, semibold.
  static TextStyle h2({
    String? family,
  }) {
    return TextStyle(
      fontSize: 30,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 36 / 30,
      letterSpacing: -0.75,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// The `h3` heading: 24px, semibold.
  static TextStyle h3({
    String? family,
  }) {
    return TextStyle(
      fontSize: 24,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 32 / 24,
      letterSpacing: -0.6,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// The `h4` heading: 20px, semibold.
  static TextStyle h4({
    String? family,
  }) {
    return TextStyle(
      fontSize: 20,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 28 / 20,
      letterSpacing: -0.5,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Body paragraph text: 16px with a 28px line height.
  static TextStyle p({
    String? family,
  }) {
    return TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 28 / 16,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Blockquote text: 16px italic.
  static TextStyle blockquote({
    String? family,
  }) {
    return TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Table header text: 16px bold.
  static TextStyle table({
    String? family,
  }) {
    return TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      height: 24 / 16,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// List item text: 16px.
  static TextStyle list({
    String? family,
  }) {
    return TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Lead paragraph text: 20px.
  static TextStyle lead({
    String? family,
  }) {
    return TextStyle(
      fontSize: 20,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 28 / 20,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Large text: 18px, semibold.
  static TextStyle large({
    String? family,
  }) {
    return TextStyle(
      fontSize: 18,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 28 / 18,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Small text: 14px, medium weight, with a line height equal to the size.
  static TextStyle small({
    String? family,
  }) {
    return TextStyle(
      fontSize: 14,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: 14 / 14,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Muted text: 14px with a 20px line height.
  static TextStyle muted({
    String? family,
  }) {
    return TextStyle(
      fontSize: 14,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
      letterSpacing: 0,
      fontFamily: family,
      textBaseline: TextBaseline.alphabetic,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
