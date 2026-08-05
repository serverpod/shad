import 'package:flutter/widgets.dart';

// Inter, matching shadcn/ui's default (`DEFAULT_CONFIG.font: "inter"`).
// Geist is still bundled and selectable via `ShadTextTheme(family: 'Geist',
// package: 'shad')`.
const kDefaultFontFamily = 'packages/shad/Inter';
const kDefaultFontFamilyMono = 'packages/shad/GeistMono';

abstract class ShadTextDefaultTheme {
  static TextStyle h1Large({
    required String family,
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

  static TextStyle h1({
    required String family,
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

  static TextStyle h2({
    required String family,
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

  static TextStyle h3({
    required String family,
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

  static TextStyle h4({
    required String family,
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

  static TextStyle p({
    required String family,
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

  static TextStyle blockquote({
    required String family,
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

  static TextStyle table({
    required String family,
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

  static TextStyle list({
    required String family,
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

  static TextStyle lead({
    required String family,
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

  static TextStyle large({
    required String family,
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

  static TextStyle small({
    required String family,
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

  static TextStyle muted({
    required String family,
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
