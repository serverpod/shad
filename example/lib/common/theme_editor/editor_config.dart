import 'package:example/common/theme_editor/fonts.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    this.style = StylePreset.vega,
    this.baseColor = BaseColor.neutral,
    this.accentColor = AccentColor.base,
    this.chartColor = AccentColor.base,
    this.headingFontTitle,
    this.fontTitle = 'Geist',
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

  /// shadcn forces the subtle accent while a menu is translucent — a bold
  /// highlight behind a see-through surface reads as muddy.
  MenuAccent get effectiveMenuAccent =>
      menuFinish == MenuSurfaceFinish.translucent
      ? MenuAccent.subtle
      : menuAccent;

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

  /// The palette, fully resolved: base, then accent, then chart, then the
  /// menu surface overrides.
  ///
  /// The menu overrides have to be folded in *here* rather than after the
  /// theme is built. `ShadThemeVariant` bakes `colorScheme.popover` into
  /// `popoverTheme.decoration` when it is constructed, so overriding the
  /// scheme afterwards changed only the text colour and left the surface
  /// alone — which is exactly the "inverted only inverts the text" bug.
  ShadColorScheme get colorScheme {
    var scheme = baseColor.scheme(brightness);

    final accent = accentColor.scheme(brightness);
    if (accent != null) scheme = scheme.applyAccentScheme(accent);

    final chart = chartColor.scheme(brightness);
    if (chart != null) {
      scheme = scheme.copyWith(
        chart1: chart.chart1,
        chart2: chart.chart2,
        chart3: chart.chart3,
        chart4: chart.chart4,
        chart5: chart.chart5,
      );
    }

    return scheme.copyWith(
      popover: menuSurface(scheme),
      popoverForeground: menuForeground(scheme),
    );
  }

  /// The menu's surface, before any translucency.
  ///
  /// Kept opaque and separate from the published `popover` so the selection
  /// colours below can be derived by blending. Blending against a
  /// half-transparent colour is what made the selected row disappear on a
  /// translucent menu.
  Color menuOpaqueSurface(ShadColorScheme scheme) =>
      menuColor == MenuSurfaceColor.inverted
      ? scheme.foreground
      : scheme.popover;

  Color menuSurface(ShadColorScheme scheme) =>
      menuFinish == MenuSurfaceFinish.translucent
      ? menuOpaqueSurface(scheme).withValues(alpha: .85)
      : menuOpaqueSurface(scheme);

  /// Text on the menu surface.
  Color menuForeground(ShadColorScheme scheme) =>
      menuColor == MenuSurfaceColor.inverted
      ? scheme.background
      : scheme.popoverForeground;

  /// The highlight behind the hovered or selected row.
  ///
  /// Subtle blends the surface a little way towards its own text, so it works
  /// on a light, dark, inverted or translucent menu alike; bold is the primary
  /// colour. Neither is `--accent`, which belongs to the *page* palette and
  /// vanishes on an inverted or translucent surface.
  Color menuSelectedBackground(ShadColorScheme scheme) =>
      effectiveMenuAccent == MenuAccent.bold
      ? _boldPair(scheme).$1
      : Color.lerp(
          menuOpaqueSurface(scheme),
          menuForeground(scheme),
          .14,
        )!;

  Color menuSelectedForeground(ShadColorScheme scheme) =>
      effectiveMenuAccent == MenuAccent.bold
      ? _boldPair(scheme).$2
      : menuForeground(scheme);

  /// The (background, foreground) a bold highlight uses.
  ///
  /// Normally the primary pair. On a menu whose surface is already that
  /// colour — a neutral palette inverted in light mode puts a near-black
  /// surface under a near-black primary — the pair is flipped, so the
  /// highlight is always visible and its label always readable.
  (Color, Color) _boldPair(ShadColorScheme scheme) {
    final surface = menuOpaqueSurface(scheme);
    double distance(Color c) =>
        (c.computeLuminance() - surface.computeLuminance()).abs();
    return distance(scheme.primary) >= distance(scheme.primaryForeground)
        ? (scheme.primary, scheme.primaryForeground)
        : (scheme.primaryForeground, scheme.primary);
  }

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
    final scheme = colorScheme;
    final borderRadius = BorderRadius.all(Radius.circular(effectiveRadius));
    final text = textTheme;

    // Built from the final scheme so the popover surface follows the menu
    // settings, and from the style tokens so every component's radius, ring
    // and label typography come from one place.
    final variant = ShadDefaultThemeVariant(
      colorScheme: scheme,
      radius: borderRadius,
      effectiveTextTheme: text,
      style: style.tokens,
      spacing: spacing,
    );

    // Every menu surface — select, context menu, command, menubar — takes its
    // colours from the same four, so no mode can leave a row unreadable.
    final menuText = menuForeground(scheme);
    final selectedBackground = menuSelectedBackground(scheme);
    final selectedForeground = menuSelectedForeground(scheme);

    return ShadThemeData(
      brightness: brightness,
      colorScheme: scheme,
      radius: borderRadius,
      textTheme: text,
      variant: variant,
      optionTheme: ShadOptionTheme(
        hoveredBackgroundColor: selectedBackground,
        selectedBackgroundColor: selectedBackground,
        selectedTextStyle: text.small.copyWith(color: selectedForeground),
        textStyle: text.small.copyWith(color: menuText),
        selectedIconColor: selectedForeground,
      ),
      contextMenuTheme: ShadContextMenuTheme(
        selectedBackgroundColor: selectedBackground,
        textStyle: text.small.copyWith(color: menuText),
        selectedTextStyle: text.small.copyWith(color: selectedForeground),
        trailingTextStyle: text.muted.copyWith(
          color: menuText.withValues(alpha: .7),
        ),
      ),
      commandTheme: ShadCommandTheme(
        itemTextStyle: text.small.copyWith(color: menuText),
        groupHeadingStyle: text.muted.copyWith(
          color: menuText.withValues(alpha: .7),
        ),
        itemSelectedBackgroundColor: selectedBackground,
        itemSelectedForegroundColor: selectedForeground,
        itemForegroundColor: menuText,
      ),
      popoverTheme: ShadPopoverTheme(
        textStyle: text.small.copyWith(color: menuText),
      ),
      // A menubar trigger sits on the page, but its highlight has to be the
      // menu's, or opening a menu changes colour halfway down.
      menubarTheme: ShadMenubarTheme(
        buttonSelectedBackgroundColor: selectedBackground,
        buttonHoverBackgroundColor: selectedBackground,
        buttonHoverForegroundColor: selectedForeground,
        buttonForegroundColor: scheme.foreground,
      ),
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
        "package: 'shadcn_ui'),",
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
