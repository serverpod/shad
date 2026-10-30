import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/text_theme/text_styles_default.dart';
import 'package:shad/src/theme/themes/default_theme_variant.dart';

/// Strips the font family from a [TextStyle].
extension OmitFamilyAndPackageExtension on TextStyle {
  /// A copy of this style without its `fontFamily` and `package`.
  ///
  /// Every other property is kept. Used to hand a style to a [ShadFontBuilder],
  /// which supplies the family itself.
  TextStyle get omitFamilyAndPackage {
    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamilyFallback: fontFamilyFallback,
      overflow: overflow,
    );
  }
}

/// Builds a [TextStyle] in a given font, with the same signature as the
/// `google_fonts` style functions such as `GoogleFonts.inter`.
typedef ShadFontBuilder =
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<ui.Shadow>? shadows,
      List<ui.FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    });

/// A [TextStyle] whose family follows its weight and style through a
/// [ShadFontBuilder].
///
/// Font sources such as `google_fonts` register one family per weight
/// (`Inter_700`), so a plain `copyWith(fontWeight: ...)` would keep the old
/// weight's family. This style asks the builder for the family again whenever
/// the weight or style changes. See
/// https://github.com/material-foundation/flutter-packages/issues/35.
class ShadBuilderTextStyle extends TextStyle {
  /// Wraps [textStyle] so that its family comes from [builder].
  ///
  /// When [overrideFamilyWithBuilder] is false, the builder supplies the family
  /// only if [textStyle] has none.
  ShadBuilderTextStyle(
    TextStyle textStyle, {
    required this.builder,
    this.overrideFamilyWithBuilder = false,
  }) : super(
         inherit: textStyle.inherit,
         color: textStyle.color,
         backgroundColor: textStyle.backgroundColor,
         fontSize: textStyle.fontSize,
         fontWeight: textStyle.fontWeight,
         fontStyle: textStyle.fontStyle,
         letterSpacing: textStyle.letterSpacing,
         wordSpacing: textStyle.wordSpacing,
         textBaseline: textStyle.textBaseline,
         height: textStyle.height,
         leadingDistribution: textStyle.leadingDistribution,
         locale: textStyle.locale,
         foreground: textStyle.foreground,
         background: textStyle.background,
         shadows: textStyle.shadows,
         fontFeatures: textStyle.fontFeatures,
         fontVariations: textStyle.fontVariations,
         decoration: textStyle.decoration,
         decorationColor: textStyle.decorationColor,
         decorationStyle: textStyle.decorationStyle,
         decorationThickness: textStyle.decorationThickness,
         debugLabel: textStyle.debugLabel,
         fontFamily: overrideFamilyWithBuilder
             ? builder(
                 fontWeight: textStyle.fontWeight,
                 fontStyle: textStyle.fontStyle,
               ).fontFamily
             : textStyle.fontFamily ??
                   ((textStyle.fontWeight != null ||
                           textStyle.fontStyle != null)
                       ? builder(
                           fontWeight: textStyle.fontWeight,
                           fontStyle: textStyle.fontStyle,
                         ).fontFamily
                       : null),
         fontFamilyFallback: textStyle.fontFamilyFallback,
         overflow: textStyle.overflow,
       );

  /// Resolves the family for a weight and style.
  final ShadFontBuilder builder;

  /// Whether the builder's family replaces the style's own family even when
  /// the style names one.
  final bool overrideFamilyWithBuilder;

  @override
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    List<ui.FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    // The family is per weight and style, so ask for the one this copy will
    // have: a changed weight with the current style, or the reverse.
    // Passing only the new values lost the other one (an italic turned
    // upright when its weight changed, and an overriding style fell back to
    // the regular face on any copy).
    final effectiveWeight = fontWeight ?? this.fontWeight;
    final effectiveStyle = fontStyle ?? this.fontStyle;
    var family =
        fontFamily ??
        ((fontWeight != null || fontStyle != null)
            ? builder(
                fontWeight: effectiveWeight,
                fontStyle: effectiveStyle,
              ).fontFamily
            : null);
    if (overrideFamilyWithBuilder) {
      family = builder(
        fontWeight: effectiveWeight,
        fontStyle: effectiveStyle,
      ).fontFamily;
    }
    return super.copyWith(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: family,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }
}

/// The text styles of a theme, one per shadcn/ui typography element.
///
/// Components read these styles, and the theme variant applies its style's text
/// roles to [small], [muted], [p], [list] and [large]. Use
/// [ShadTextTheme.fromGoogleFont] to set every style in one font.
@immutable
class ShadTextTheme {
  /// Creates a text theme.
  ///
  /// A null style takes the [ShadTextDefaultTheme] value in [family]. [package]
  /// prefixes [family] as `packages/<package>/<family>`. [family] defaults to
  /// null, which uses the platform font.
  factory ShadTextTheme({
    TextStyle? h1Large,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? p,
    TextStyle? blockquote,
    TextStyle? table,
    TextStyle? list,
    TextStyle? lead,
    TextStyle? large,
    TextStyle? small,
    TextStyle? muted,
    String? family,
    String? package,
    ShadFontBuilder? googleFontBuilder,
    Map<String, TextStyle> custom = const {},
  }) {
    // With no family, text uses the platform font. A package only qualifies
    // a family the caller named.
    var effectiveFamily = family;
    if (effectiveFamily != null && package != null && package != '') {
      effectiveFamily = 'packages/$package/$effectiveFamily';
    }

    return ShadTextTheme.custom(
      h1Large: h1Large ?? ShadTextDefaultTheme.h1Large(family: effectiveFamily),
      h1: h1 ?? ShadTextDefaultTheme.h1(family: effectiveFamily),
      h2: h2 ?? ShadTextDefaultTheme.h2(family: effectiveFamily),
      h3: h3 ?? ShadTextDefaultTheme.h3(family: effectiveFamily),
      h4: h4 ?? ShadTextDefaultTheme.h4(family: effectiveFamily),
      p: p ?? ShadTextDefaultTheme.p(family: effectiveFamily),
      blockquote:
          blockquote ??
          ShadTextDefaultTheme.blockquote(family: effectiveFamily),
      table: table ?? ShadTextDefaultTheme.table(family: effectiveFamily),
      list: list ?? ShadTextDefaultTheme.list(family: effectiveFamily),
      lead: lead ?? ShadTextDefaultTheme.lead(family: effectiveFamily),
      large: large ?? ShadTextDefaultTheme.large(family: effectiveFamily),
      small: small ?? ShadTextDefaultTheme.small(family: effectiveFamily),
      muted: muted ?? ShadTextDefaultTheme.muted(family: effectiveFamily),
      family: effectiveFamily,
      googleFontBuilder: googleFontBuilder,
      custom: custom,
    );
  }

  /// Creates a text theme from explicit styles. Nothing is filled in.
  ///
  /// Set [canMerge] to false so that merging this theme into another one
  /// returns it unchanged.
  const ShadTextTheme.custom({
    this.canMerge = true,
    required this.h1Large,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.p,
    required this.blockquote,
    required this.table,
    required this.list,
    required this.lead,
    required this.large,
    required this.small,
    required this.muted,
    this.family,
    this.custom = const {},
    this.googleFontBuilder,
  });

  /// Creates a text theme in the font that [fontBuilder] builds.
  ///
  /// The sizes and weights come from [textTheme], or from the default text
  /// theme when it is null. [custom] styles are added to the result.
  factory ShadTextTheme.fromGoogleFont(
    ShadFontBuilder fontBuilder, {
    ShadTextTheme? textTheme,
    Map<String, TextStyle> custom = const {},
  }) {
    final effectiveTextTheme =
        textTheme ?? ShadDefaultThemeVariant.defaultTextTheme;

    final p = ShadBuilderTextStyle(
      effectiveTextTheme.p.omitFamilyAndPackage,
      builder: fontBuilder,
    );

    return ShadTextTheme(
      h1Large: ShadBuilderTextStyle(
        effectiveTextTheme.h1Large.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      h1: ShadBuilderTextStyle(
        effectiveTextTheme.h1.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      h2: ShadBuilderTextStyle(
        effectiveTextTheme.h2.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      h3: ShadBuilderTextStyle(
        effectiveTextTheme.h3.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      h4: ShadBuilderTextStyle(
        effectiveTextTheme.h4.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      p: p,
      blockquote: ShadBuilderTextStyle(
        effectiveTextTheme.blockquote.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      table: ShadBuilderTextStyle(
        effectiveTextTheme.table.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      list: ShadBuilderTextStyle(
        effectiveTextTheme.list.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      lead: ShadBuilderTextStyle(
        effectiveTextTheme.lead.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      large: ShadBuilderTextStyle(
        effectiveTextTheme.large.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      small: ShadBuilderTextStyle(
        effectiveTextTheme.small.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      muted: ShadBuilderTextStyle(
        effectiveTextTheme.muted.omitFamilyAndPackage,
        builder: fontBuilder,
      ),
      family: p.fontFamily,
      googleFontBuilder: fontBuilder,
      custom: {
        for (final e in effectiveTextTheme.custom.entries)
          e.key: ShadBuilderTextStyle(
            e.value.omitFamilyAndPackage,
            builder: fontBuilder,
          ),
        for (final e in custom.entries)
          e.key: ShadBuilderTextStyle(
            e.value.omitFamilyAndPackage,
            builder: fontBuilder,
          ),
      },
    );
  }

  /// The display heading style, larger than [h1].
  final TextStyle h1Large;

  /// The `h1` heading style.
  final TextStyle h1;

  /// The `h2` heading style.
  final TextStyle h2;

  /// The `h3` heading style.
  final TextStyle h3;

  /// The `h4` heading style.
  final TextStyle h4;

  /// The paragraph style.
  final TextStyle p;

  /// The blockquote style.
  final TextStyle blockquote;

  /// The table text style.
  final TextStyle table;

  /// The list item style.
  final TextStyle list;

  /// The lead paragraph style, larger than [p].
  final TextStyle lead;

  /// The large text style.
  final TextStyle large;

  /// The small text style. Labels use it.
  final TextStyle small;

  /// The muted text style, for descriptions and supporting text.
  final TextStyle muted;

  /// Extra styles an app defines, by name.
  ///
  /// [lerp], [merge] and [apply] carry them along. Empty by default.
  final Map<String, TextStyle> custom;

  /// The font family of the theme.
  ///
  /// Null means the platform font. shad bundles no fonts: set this to a
  /// family your app declares under `flutter: fonts:`, or build the theme
  /// with [ShadTextTheme.fromGoogleFont].
  final String? family;

  /// Whether this theme combines with the one it is merged into.
  ///
  /// When false, `other.merge(this)` returns this theme unchanged.
  final bool canMerge;

  /// The builder that [ShadTextTheme.fromGoogleFont] used, or null.
  final ShadFontBuilder? googleFontBuilder;

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// [package] prefixes the family as `packages/<package>/<family>`, unless it
  /// is prefixed already.
  ShadTextTheme copyWith({
    TextStyle? h1Large,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? p,
    TextStyle? blockquote,
    TextStyle? table,
    TextStyle? list,
    TextStyle? lead,
    TextStyle? large,
    TextStyle? small,
    TextStyle? muted,
    String? family,
    String? package,
    ShadFontBuilder? googleFontBuilder,
    Map<String, TextStyle>? custom,
  }) {
    final baseFamily = family ?? this.family;
    late final String? effectiveFamily;
    if (baseFamily != null && package != null && package.isNotEmpty) {
      final alreadyPrefixed = baseFamily.startsWith('packages/');
      effectiveFamily =
          !alreadyPrefixed //
          ? 'packages/$package/$baseFamily'
          : baseFamily;
    } else {
      effectiveFamily = baseFamily;
    }

    return ShadTextTheme.custom(
      canMerge: canMerge,
      h1Large: h1Large ?? this.h1Large,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      p: p ?? this.p,
      blockquote: blockquote ?? this.blockquote,
      table: table ?? this.table,
      list: list ?? this.list,
      lead: lead ?? this.lead,
      large: large ?? this.large,
      small: small ?? this.small,
      muted: muted ?? this.muted,
      family: effectiveFamily,
      googleFontBuilder: googleFontBuilder ?? this.googleFontBuilder,
      custom: custom ?? this.custom,
    );
  }

  /// Merges [other] into this theme, style by style.
  ///
  /// Returns this theme when [other] is null, and [other] when its [canMerge]
  /// is false. [other]'s family and custom styles take precedence.
  ShadTextTheme merge(ShadTextTheme? other) {
    if (other == null) return this;
    if (!other.canMerge) return other;
    return copyWith(
      h1Large: h1Large.merge(other.h1Large),
      h1: h1.merge(other.h1),
      h2: h2.merge(other.h2),
      h3: h3.merge(other.h3),
      h4: h4.merge(other.h4),
      p: p.merge(other.p),
      blockquote: blockquote.merge(other.blockquote),
      table: table.merge(other.table),
      list: list.merge(other.list),
      lead: lead.merge(other.lead),
      large: large.merge(other.large),
      small: small.merge(other.small),
      muted: muted.merge(other.muted),
      family: other.family,
      googleFontBuilder: other.googleFontBuilder,
      custom: {...custom, ...other.custom},
    );
  }

  /// Applies the same changes to every style, like [TextStyle.apply].
  ///
  /// [displayColor] colours the headings, from [h1Large] to [h4]. [bodyColor]
  /// colours every other style and the custom styles.
  ShadTextTheme apply({
    String? family,
    List<String>? fontFamilyFallback,
    String? package,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color? displayColor,
    Color? bodyColor,
    Color? decorationColor,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
  }) {
    final effectiveFamily = family ?? this.family;
    return ShadTextTheme.custom(
      canMerge: canMerge,
      family: effectiveFamily,
      h1Large: h1Large.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      h1: h1.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      h2: h2.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      h3: h3.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      h4: h4.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      p: p.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      blockquote: blockquote.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      table: table.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      list: list.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      lead: lead.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      large: large.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        color: bodyColor,
      ),
      small: small.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        color: bodyColor,
      ),
      muted: muted.apply(
        fontFamily: effectiveFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        color: bodyColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
      ),
      googleFontBuilder: googleFontBuilder,
      custom: {
        for (final entry in custom.entries)
          entry.key: entry.value.apply(
            fontFamily: effectiveFamily,
            fontFamilyFallback: fontFamilyFallback,
            package: package,
            fontSizeFactor: fontSizeFactor,
            fontSizeDelta: fontSizeDelta,
            color: bodyColor,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationStyle: decorationStyle,
          ),
      },
    );
  }

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadTextTheme? lerp(
    ShadTextTheme? a,
    ShadTextTheme? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return ShadTextTheme.custom(
      canMerge: t < 0.5 ? a.canMerge : b.canMerge,
      h1Large: TextStyle.lerp(a.h1Large, b.h1Large, t)!,
      h1: TextStyle.lerp(a.h1, b.h1, t)!,
      h2: TextStyle.lerp(a.h2, b.h2, t)!,
      h3: TextStyle.lerp(a.h3, b.h3, t)!,
      h4: TextStyle.lerp(a.h4, b.h4, t)!,
      p: TextStyle.lerp(a.p, b.p, t)!,
      blockquote: TextStyle.lerp(a.blockquote, b.blockquote, t)!,
      table: TextStyle.lerp(a.table, b.table, t)!,
      list: TextStyle.lerp(a.list, b.list, t)!,
      lead: TextStyle.lerp(a.lead, b.lead, t)!,
      large: TextStyle.lerp(a.large, b.large, t)!,
      small: TextStyle.lerp(a.small, b.small, t)!,
      muted: TextStyle.lerp(a.muted, b.muted, t)!,
      family: t < 0.5 ? a.family : b.family,
      googleFontBuilder: t < 0.5 ? a.googleFontBuilder : b.googleFontBuilder,
      custom: {
        for (final key in {...a.custom.keys, ...b.custom.keys})
          key: TextStyle.lerp(a.custom[key], b.custom[key], t)!,
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ShadTextTheme &&
        other.h1Large == h1Large &&
        other.h1 == h1 &&
        other.h2 == h2 &&
        other.h3 == h3 &&
        other.h4 == h4 &&
        other.p == p &&
        other.blockquote == blockquote &&
        other.table == table &&
        other.list == list &&
        other.lead == lead &&
        other.large == large &&
        other.small == small &&
        other.muted == muted &&
        other.family == family &&
        other.googleFontBuilder == googleFontBuilder &&
        mapEquals(other.custom, custom);
  }

  @override
  int get hashCode {
    // [canMerge] is deliberately absent: `==` does not compare it either, and
    // including it here would violate the hashCode/== contract. `custom` is
    // hashed per entry because MapEntry hashes by identity, which would
    // disagree with the mapEquals used by `==`.
    return Object.hash(
      h1Large,
      h1,
      h2,
      h3,
      h4,
      p,
      blockquote,
      table,
      list,
      lead,
      large,
      small,
      muted,
      family,
      googleFontBuilder,
      Object.hashAllUnordered([
        for (final entry in custom.entries) Object.hash(entry.key, entry.value),
      ]),
    );
  }
}

/// The old name of [ShadFontBuilder].
@Deprecated(
  'Use ShadFontBuilder. Will be removed in the next major version.',
)
typedef GoogleFontBuilder = ShadFontBuilder;

/// The old name of [ShadBuilderTextStyle].
@Deprecated(
  'Use ShadBuilderTextStyle. Will be removed in the next major version.',
)
typedef GoogleFontTextStyle = ShadBuilderTextStyle;
