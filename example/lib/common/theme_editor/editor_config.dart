import 'package:example/common/theme_editor/fonts.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

/// shadcn/ui's neutral *base colours*.
enum BaseColor {
  neutral('Neutral'),
  stone('Stone'),
  zinc('Zinc'),
  mauve('Mauve'),
  olive('Olive'),
  mist('Mist'),
  taupe('Taupe'),
  // Shipped by this package since before the base/accent split existed.
  slate('Slate'),
  gray('Gray');

  const BaseColor(this.label);

  final String label;

  ShadColorScheme scheme(Brightness brightness) =>
      ShadColorScheme.fromName(name, brightness: brightness);

  /// The dot shown in the picker.
  ///
  /// Not `primary`: in these neutral palettes that is near-black, which
  /// disappears against the customizer's dark surface. The muted foreground is
  /// the same hue at a lightness that reads on either background.
  Color get swatch => scheme(Brightness.light).mutedForeground;
}

/// shadcn/ui's accent *themes*, layered over a [BaseColor].
enum AccentColor {
  base('Base'),
  amber('Amber'),
  blue('Blue'),
  cyan('Cyan'),
  emerald('Emerald'),
  fuchsia('Fuchsia'),
  green('Green'),
  indigo('Indigo'),
  lime('Lime'),
  orange('Orange'),
  pink('Pink'),
  purple('Purple'),
  red('Red'),
  rose('Rose'),
  sky('Sky'),
  teal('Teal'),
  violet('Violet'),
  yellow('Yellow');

  const AccentColor(this.label);

  final String label;

  ShadAccentScheme? scheme(Brightness brightness) => this == AccentColor.base
      ? null
      : ShadAccentScheme.fromName(name, brightness: brightness);

  /// The dot shown in the picker.
  ///
  /// "Base" means "keep the base colour's own hue", so it shows that palette's
  /// swatch rather than its `primary`, which is near-black and reads as a
  /// missing image.
  Color swatch(Brightness brightness, BaseColor base) =>
      scheme(brightness)?.primary ?? base.swatch;
}

/// shadcn/ui's radius presets. The listed values are its `--radius`;
/// components use `--radius-md`, which is `--radius * 0.8`.
enum RadiusPreset {
  none('None', 0),
  small('Small', 7.2 * 0.8),
  medium('Medium', 10 * 0.8),
  large('Large', 14 * 0.8);

  const RadiusPreset(this.label, this.value);

  final String label;
  final double value;
}

/// shadcn/ui's eight named styles.
///
/// Each is a preset over [ShadStyleTokens] — corner radii, focus-ring
/// thickness and opacity, and label typography — so picking one reshapes every
/// component at once.
enum StylePreset {
  vega('Vega'),
  nova('Nova'),
  maia('Maia'),
  lyra('Lyra'),
  mira('Mira'),
  luma('Luma'),
  sera('Sera'),
  rhea('Rhea');

  const StylePreset(this.label);

  final String label;

  ShadStyleTokens get tokens => ShadStyleTokens.fromName(name);
}

/// The menu surface colour, mirroring shadcn's `menuColor` "Default/Inverted".
enum MenuSurfaceColor {
  standard('Default'),
  inverted('Inverted');

  const MenuSurfaceColor(this.label);

  final String label;
}

/// The menu surface finish, mirroring shadcn's "Solid/Translucent".
enum MenuSurfaceFinish {
  solid('Solid'),
  translucent('Translucent');

  const MenuSurfaceFinish(this.label);

  final String label;
}

/// How strongly a menu highlights its selected item.
enum MenuAccent {
  subtle('Subtle'),
  bold('Bold');

  const MenuAccent(this.label);

  final String label;
}

/// Everything the editor configures, and the [ShadThemeData] it produces.
@immutable
class ThemeEditorConfig {
  const ThemeEditorConfig({
    this.brightness = Brightness.light,
    this.style = StylePreset.nova,
    this.baseColor = BaseColor.neutral,
    this.accentColor = AccentColor.base,
    this.chartColor = AccentColor.base,
    this.headingFontTitle,
    this.fontTitle = 'Inter',
    this.radius = RadiusPreset.medium,
    this.customRadius,
    this.menuColor = MenuSurfaceColor.standard,
    this.menuFinish = MenuSurfaceFinish.solid,
    this.menuAccent = MenuAccent.subtle,
    this.textScale = 1,
    this.rtl = false,
    this.spacingStep = 4,
  });

  final Brightness brightness;
  final StylePreset style;
  final BaseColor baseColor;
  final AccentColor accentColor;

  /// The chart ramp's hue, pickable independently of the main accent.
  final AccentColor chartColor;

  /// Null means "same as body", shadcn's `fontHeading: "inherit"`.
  final String? headingFontTitle;
  final String fontTitle;

  final RadiusPreset radius;
  final double? customRadius;

  final MenuSurfaceColor menuColor;
  final MenuSurfaceFinish menuFinish;
  final MenuAccent menuAccent;

  final double textScale;
  final bool rtl;

  /// One step on the spacing scale, shadcn's `--spacing`.
  final double spacingStep;

  double get effectiveRadius => customRadius ?? radius.value;

  ShadSpacing get spacing => ShadSpacing(step: spacingStep);

  EditorFont get font => EditorFont.byTitle(fontTitle);

  EditorFont? get headingFont =>
      headingFontTitle == null ? null : EditorFont.byTitle(headingFontTitle!);

  ThemeEditorConfig copyWith({
    Brightness? brightness,
    StylePreset? style,
    BaseColor? baseColor,
    AccentColor? accentColor,
    AccentColor? chartColor,
    String? headingFontTitle,
    bool clearHeadingFont = false,
    String? fontTitle,
    RadiusPreset? radius,
    double? customRadius,
    bool clearCustomRadius = false,
    MenuSurfaceColor? menuColor,
    MenuSurfaceFinish? menuFinish,
    MenuAccent? menuAccent,
    double? textScale,
    bool? rtl,
    double? spacingStep,
  }) {
    return ThemeEditorConfig(
      brightness: brightness ?? this.brightness,
      style: style ?? this.style,
      baseColor: baseColor ?? this.baseColor,
      accentColor: accentColor ?? this.accentColor,
      chartColor: chartColor ?? this.chartColor,
      headingFontTitle: clearHeadingFont
          ? null
          : (headingFontTitle ?? this.headingFontTitle),
      fontTitle: fontTitle ?? this.fontTitle,
      radius: radius ?? this.radius,
      customRadius: clearCustomRadius
          ? null
          : (customRadius ?? this.customRadius),
      menuColor: menuColor ?? this.menuColor,
      menuFinish: menuFinish ?? this.menuFinish,
      menuAccent: menuAccent ?? this.menuAccent,
      textScale: textScale ?? this.textScale,
      rtl: rtl ?? this.rtl,
      spacingStep: spacingStep ?? this.spacingStep,
    );
  }

  /// The palette, fully resolved for [brightness]: base, accent, then chart.
  ShadColorScheme get colorScheme => _scheme(brightness);

  ShadColorScheme _scheme(Brightness b) {
    var scheme = baseColor.scheme(b);

    final accent = accentColor.scheme(b);
    if (accent != null) scheme = scheme.applyAccentScheme(accent);

    final chart = chartColor.scheme(b);
    if (chart != null) {
      scheme = scheme.copyWith(
        chart1: chart.chart1,
        chart2: chart.chart2,
        chart3: chart.chart3,
        chart4: chart.chart4,
        chart5: chart.chart5,
      );
    }

    return scheme;
  }

  /// The palette menus draw from, or null when they follow the page.
  ///
  /// shadcn implements "Inverted" by giving every menu surface the `dark`
  /// class — the whole dark token set, not a couple of recoloured slots — so
  /// an inverted menu is simply built from the dark counterpart of the same
  /// configuration. In dark mode that *is* the page palette, which matches
  /// the reference: inverted menus only differ in light mode.
  ShadColorScheme? get menuColorScheme =>
      menuColor == MenuSurfaceColor.inverted && brightness == Brightness.light
      ? _scheme(Brightness.dark)
      : null;

  /// The body text theme, with the heading styles swapped to the heading font
  /// when one is chosen.
  ///
  /// shadcn exposes body and heading fonts separately (`fontHeading:
  /// "inherit"` means "same as body"). A [ShadTextTheme] carries one family,
  /// so the heading font is applied by overriding just the h1..h4 styles.
  ShadTextTheme get textTheme {
    final body = font.textTheme();
    final heading = headingFont;
    if (heading == null || heading == font) return body;

    final headingBase = heading.textTheme();
    return body.copyWith(
      h1Large: headingBase.h1Large,
      h1: headingBase.h1,
      h2: headingBase.h2,
      h3: headingBase.h3,
      h4: headingBase.h4,
    );
  }

  ShadThemeData build() {
    final borderRadius = BorderRadius.all(Radius.circular(effectiveRadius));

    // The menu options are the library's own — the same semantics as
    // shadcn's create editor: inverted menus take the dark palette,
    // translucent ones the blurred 70% surface, and a bold accent rewrites
    // the scheme's accent pair with its primary.
    return ShadThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      radius: borderRadius,
      textTheme: textTheme,
      style: style.tokens,
      spacing: spacing,
      menuColorScheme: menuColorScheme,
      menuTranslucent: menuFinish == MenuSurfaceFinish.translucent,
      menuAccent: switch (menuAccent) {
        MenuAccent.subtle => ShadMenuAccent.subtle,
        MenuAccent.bold => ShadMenuAccent.bold,
      },
    );
  }

  /// A copy-pasteable snippet reproducing this configuration.
  String toDartSnippet() {
    final buffer = StringBuffer()
      ..writeln('ShadThemeData(')
      ..writeln('  brightness: Brightness.${brightness.name},');

    final cap =
        '${baseColor.name[0].toUpperCase()}${baseColor.name.substring(1)}';
    final ctor = 'const Shad${cap}ColorScheme.${brightness.name}()';

    if (accentColor == AccentColor.base) {
      buffer.writeln('  colorScheme: $ctor,');
    } else {
      buffer
        ..writeln('  colorScheme: $ctor.applyAccentScheme(')
        ..writeln(
          '    ShadAccentScheme.${accentColor.name}'
          '${brightness == Brightness.light ? 'Light' : 'Dark'},',
        )
        ..writeln('  ),');
    }

    buffer.writeln(
      '  radius: BorderRadius.circular(${effectiveRadius.toStringAsFixed(1)}),',
    );
    if (font.bundled) {
      buffer.writeln(
        "  textTheme: ShadTextTheme(family: '${font.family}', "
        "package: 'shad'),",
      );
    } else {
      buffer.writeln(
        '  textTheme: ShadTextTheme.fromGoogleFont('
        "GoogleFonts.${_camel(font.family)}),",
      );
    }
    buffer.writeln('  style: ShadStyleTokens.${style.name},');
    if (spacingStep != 4) {
      buffer.writeln(
        '  spacing: ShadSpacing(step: ${spacingStep.toStringAsFixed(1)}),',
      );
    }
    if (menuColor == MenuSurfaceColor.inverted &&
        brightness == Brightness.light) {
      final cap =
          '${baseColor.name[0].toUpperCase()}${baseColor.name.substring(1)}';
      final darkCtor = 'const Shad${cap}ColorScheme.dark()';
      if (accentColor == AccentColor.base) {
        buffer.writeln('  menuColorScheme: $darkCtor,');
      } else {
        buffer
          ..writeln('  menuColorScheme: $darkCtor.applyAccentScheme(')
          ..writeln('    ShadAccentScheme.${accentColor.name}Dark,')
          ..writeln('  ),');
      }
    }
    if (menuFinish == MenuSurfaceFinish.translucent) {
      buffer.writeln('  menuTranslucent: true,');
    }
    if (menuAccent == MenuAccent.bold) {
      buffer.writeln('  menuAccent: ShadMenuAccent.bold,');
    }
    buffer.write(')');
    return buffer.toString();
  }

  /// "Space Grotesk" -> "spaceGrotesk", matching google_fonts' accessors.
  static String _camel(String family) {
    final parts = family.split(RegExp(r'[\s_]+'));
    return [
      parts.first.toLowerCase(),
      ...parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)),
    ].join();
  }
}
