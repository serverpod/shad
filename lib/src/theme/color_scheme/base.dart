import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/color_scheme/accent.dart';
import 'package:shadcn_ui/src/theme/color_scheme/blue.dart';
import 'package:shadcn_ui/src/theme/color_scheme/gray.dart';
import 'package:shadcn_ui/src/theme/color_scheme/green.dart';
import 'package:shadcn_ui/src/theme/color_scheme/mauve.dart';
import 'package:shadcn_ui/src/theme/color_scheme/mist.dart';
import 'package:shadcn_ui/src/theme/color_scheme/neutral.dart';
import 'package:shadcn_ui/src/theme/color_scheme/olive.dart';
import 'package:shadcn_ui/src/theme/color_scheme/orange.dart';
import 'package:shadcn_ui/src/theme/color_scheme/red.dart';
import 'package:shadcn_ui/src/theme/color_scheme/rose.dart';
import 'package:shadcn_ui/src/theme/color_scheme/slate.dart';
import 'package:shadcn_ui/src/theme/color_scheme/stone.dart';
import 'package:shadcn_ui/src/theme/color_scheme/taupe.dart';
import 'package:shadcn_ui/src/theme/color_scheme/violet.dart';
import 'package:shadcn_ui/src/theme/color_scheme/yellow.dart';
import 'package:shadcn_ui/src/theme/color_scheme/zinc.dart';

@immutable
class ShadColorScheme {
  const ShadColorScheme({
    bool canMerge = true,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.selection,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
    this.custom = const {},
  }) : _canMerge = canMerge,
       _chart1 = chart1,
       _chart2 = chart2,
       _chart3 = chart3,
       _chart4 = chart4,
       _chart5 = chart5,
       _sidebar = sidebar,
       _sidebarForeground = sidebarForeground,
       _sidebarPrimary = sidebarPrimary,
       _sidebarPrimaryForeground = sidebarPrimaryForeground,
       _sidebarAccent = sidebarAccent,
       _sidebarAccentForeground = sidebarAccentForeground,
       _sidebarBorder = sidebarBorder,
       _sidebarRing = sidebarRing;

  factory ShadColorScheme.fromName(
    String name, {
    Brightness brightness = Brightness.light,
  }) {
    return switch (name) {
      'blue' =>
        brightness == Brightness.light
            ? const ShadBlueColorScheme.light()
            : const ShadBlueColorScheme.dark(),
      'gray' =>
        brightness == Brightness.light
            ? const ShadGrayColorScheme.light()
            : const ShadGrayColorScheme.dark(),
      'green' =>
        brightness == Brightness.light
            ? const ShadGreenColorScheme.light()
            : const ShadGreenColorScheme.dark(),
      'neutral' =>
        brightness == Brightness.light
            ? const ShadNeutralColorScheme.light()
            : const ShadNeutralColorScheme.dark(),
      'orange' =>
        brightness == Brightness.light
            ? const ShadOrangeColorScheme.light()
            : const ShadOrangeColorScheme.dark(),
      'red' =>
        brightness == Brightness.light
            ? const ShadRedColorScheme.light()
            : const ShadRedColorScheme.dark(),
      'rose' =>
        brightness == Brightness.light
            ? const ShadRoseColorScheme.light()
            : const ShadRoseColorScheme.dark(),
      'slate' =>
        brightness == Brightness.light
            ? const ShadSlateColorScheme.light()
            : const ShadSlateColorScheme.dark(),
      'stone' =>
        brightness == Brightness.light
            ? const ShadStoneColorScheme.light()
            : const ShadStoneColorScheme.dark(),
      'violet' =>
        brightness == Brightness.light
            ? const ShadVioletColorScheme.light()
            : const ShadVioletColorScheme.dark(),
      'yellow' =>
        brightness == Brightness.light
            ? const ShadYellowColorScheme.light()
            : const ShadYellowColorScheme.dark(),
      'zinc' =>
        brightness == Brightness.light
            ? const ShadZincColorScheme.light()
            : const ShadZincColorScheme.dark(),
      'mauve' =>
        brightness == Brightness.light
            ? const ShadMauveColorScheme.light()
            : const ShadMauveColorScheme.dark(),
      'mist' =>
        brightness == Brightness.light
            ? const ShadMistColorScheme.light()
            : const ShadMistColorScheme.dark(),
      'olive' =>
        brightness == Brightness.light
            ? const ShadOliveColorScheme.light()
            : const ShadOliveColorScheme.dark(),
      'taupe' =>
        brightness == Brightness.light
            ? const ShadTaupeColorScheme.light()
            : const ShadTaupeColorScheme.dark(),
      _ => throw Exception('Invalid color scheme name'),
    };
  }

  final bool _canMerge;

  bool get canMerge => _canMerge;

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color selection;
  final Map<String, Color> custom;

  // shadcn/ui's `--chart-1`..`--chart-5` and `--sidebar-*` tokens.
  //
  // Stored nullable and resolved through the getters below so that the twelve
  // colour schemes that predate them — and any scheme a caller wrote by hand —
  // keep compiling. A null token falls back to the closest existing one, which
  // is what shadcn's own neutral themes do anyway.
  final Color? _chart1;
  final Color? _chart2;
  final Color? _chart3;
  final Color? _chart4;
  final Color? _chart5;
  final Color? _sidebar;
  final Color? _sidebarForeground;
  final Color? _sidebarPrimary;
  final Color? _sidebarPrimaryForeground;
  final Color? _sidebarAccent;
  final Color? _sidebarAccentForeground;
  final Color? _sidebarBorder;
  final Color? _sidebarRing;

  /// The first categorical chart colour.
  ///
  /// Defaults to [primary]; the remaining four step towards [mutedForeground]
  /// so an unspecified scheme still yields a usable, ordered ramp.
  Color get chart1 => _chart1 ?? primary;

  Color get chart2 => _chart2 ?? Color.lerp(primary, mutedForeground, .25)!;

  Color get chart3 => _chart3 ?? Color.lerp(primary, mutedForeground, .5)!;

  Color get chart4 => _chart4 ?? Color.lerp(primary, mutedForeground, .75)!;

  Color get chart5 => _chart5 ?? mutedForeground;

  /// The chart ramp in order, handy for feeding a series list.
  List<Color> get charts => [chart1, chart2, chart3, chart4, chart5];

  /// The sidebar surface. Defaults to [card].
  Color get sidebar => _sidebar ?? card;

  Color get sidebarForeground => _sidebarForeground ?? cardForeground;

  Color get sidebarPrimary => _sidebarPrimary ?? primary;

  Color get sidebarPrimaryForeground =>
      _sidebarPrimaryForeground ?? primaryForeground;

  Color get sidebarAccent => _sidebarAccent ?? accent;

  Color get sidebarAccentForeground =>
      _sidebarAccentForeground ?? accentForeground;

  Color get sidebarBorder => _sidebarBorder ?? border;

  Color get sidebarRing => _sidebarRing ?? ring;

  static ShadColorScheme lerp(
    ShadColorScheme a,
    ShadColorScheme b,
    double t,
  ) {
    return ShadColorScheme(
      canMerge: t < 0.5 ? a.canMerge : b.canMerge,
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      card: Color.lerp(a.card, b.card, t)!,
      cardForeground: Color.lerp(a.cardForeground, b.cardForeground, t)!,
      popover: Color.lerp(a.popover, b.popover, t)!,
      popoverForeground: Color.lerp(
        a.popoverForeground,
        b.popoverForeground,
        t,
      )!,
      primary: Color.lerp(a.primary, b.primary, t)!,
      primaryForeground: Color.lerp(
        a.primaryForeground,
        b.primaryForeground,
        t,
      )!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      secondaryForeground: Color.lerp(
        a.secondaryForeground,
        b.secondaryForeground,
        t,
      )!,
      muted: Color.lerp(a.muted, b.muted, t)!,
      mutedForeground: Color.lerp(a.mutedForeground, b.mutedForeground, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentForeground: Color.lerp(a.accentForeground, b.accentForeground, t)!,
      destructive: Color.lerp(a.destructive, b.destructive, t)!,
      destructiveForeground: Color.lerp(
        a.destructiveForeground,
        b.destructiveForeground,
        t,
      )!,
      border: Color.lerp(a.border, b.border, t)!,
      input: Color.lerp(a.input, b.input, t)!,
      ring: Color.lerp(a.ring, b.ring, t)!,
      selection: Color.lerp(a.selection, b.selection, t)!,
      chart1: Color.lerp(a._chart1, b._chart1, t),
      chart2: Color.lerp(a._chart2, b._chart2, t),
      chart3: Color.lerp(a._chart3, b._chart3, t),
      chart4: Color.lerp(a._chart4, b._chart4, t),
      chart5: Color.lerp(a._chart5, b._chart5, t),
      sidebar: Color.lerp(a._sidebar, b._sidebar, t),
      sidebarForeground: Color.lerp(
        a._sidebarForeground,
        b._sidebarForeground,
        t,
      ),
      sidebarPrimary: Color.lerp(a._sidebarPrimary, b._sidebarPrimary, t),
      sidebarPrimaryForeground: Color.lerp(
        a._sidebarPrimaryForeground,
        b._sidebarPrimaryForeground,
        t,
      ),
      sidebarAccent: Color.lerp(a._sidebarAccent, b._sidebarAccent, t),
      sidebarAccentForeground: Color.lerp(
        a._sidebarAccentForeground,
        b._sidebarAccentForeground,
        t,
      ),
      sidebarBorder: Color.lerp(a._sidebarBorder, b._sidebarBorder, t),
      sidebarRing: Color.lerp(a._sidebarRing, b._sidebarRing, t),
      custom: {
        for (final key in {...a.custom.keys, ...b.custom.keys})
          key: Color.lerp(
            a.custom[key] ?? a.foreground,
            b.custom[key] ?? b.foreground,
            t,
          )!,
      },
    );
  }

  /// Creates a copy of this [ShadColorScheme] but with the given fields
  /// replaced with the new values.
  ShadColorScheme copyWith({
    bool? canMerge,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? selection,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
    Map<String, Color>? custom,
  }) {
    return ShadColorScheme(
      canMerge: canMerge ?? this.canMerge,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      selection: selection ?? this.selection,
      chart1: chart1 ?? _chart1,
      chart2: chart2 ?? _chart2,
      chart3: chart3 ?? _chart3,
      chart4: chart4 ?? _chart4,
      chart5: chart5 ?? _chart5,
      sidebar: sidebar ?? _sidebar,
      sidebarForeground: sidebarForeground ?? _sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? _sidebarPrimary,
      sidebarPrimaryForeground:
          sidebarPrimaryForeground ?? _sidebarPrimaryForeground,
      sidebarAccent: sidebarAccent ?? _sidebarAccent,
      sidebarAccentForeground:
          sidebarAccentForeground ?? _sidebarAccentForeground,
      sidebarBorder: sidebarBorder ?? _sidebarBorder,
      sidebarRing: sidebarRing ?? _sidebarRing,
      custom: custom ?? this.custom,
    );
  }

  /// Returns a copy of this scheme with [accent] applied as the accent hue,
  /// leaving the neutral palette (backgrounds, borders, muted tones) intact.
  ///
  /// shadcn/ui's theme editor treats the neutral *base colour* and the
  /// *accent* as two independent choices: pick `zinc` for the greys, then
  /// `blue` for the primary and focus ring. A [ShadColorScheme] bundles both,
  /// so this re-tints only the parts that follow the accent — [primary],
  /// [ring] and [selection] — and derives a readable [primaryForeground] when
  /// one is not supplied.
  ///
  /// ```dart
  /// ShadThemeData(
  ///   colorScheme: const ShadZincColorScheme.light()
  ///       .applyAccent(const Color(0xff3b82f6)),
  /// )
  /// ```
  ShadColorScheme applyAccent(
    Color accent, {
    Color? accentForeground,
    bool tintSelection = true,
  }) {
    final foreground = accentForeground ?? contrastingForeground(accent);
    return copyWith(
      primary: accent,
      primaryForeground: foreground,
      ring: accent,
      selection: tintSelection ? accent.withValues(alpha: .3) : null,
    );
  }

  /// Returns a copy of this scheme with [accent]'s hue-carrying tokens applied.
  ///
  /// This is shadcn/ui's base-colour + accent composition: the neutral palette
  /// is this scheme's, while the primary pair, secondary pair, chart ramp and
  /// sidebar primary come from the accent. Tokens the accent leaves unset stay
  /// as they are.
  ///
  /// [ring] follows the accent's primary, matching `focus-visible:ring-ring/50`
  /// picking up the themed hue.
  ///
  /// ```dart
  /// const ShadZincColorScheme.light()
  ///     .applyAccentScheme(ShadAccentScheme.violetLight)
  /// ```
  ShadColorScheme applyAccentScheme(ShadAccentScheme accent) {
    return copyWith(
      primary: accent.primary,
      primaryForeground: accent.primaryForeground,
      secondary: accent.secondary,
      secondaryForeground: accent.secondaryForeground,
      ring: accent.primary,
      selection: accent.primary.withValues(alpha: .3),
      chart1: accent.chart1,
      chart2: accent.chart2,
      chart3: accent.chart3,
      chart4: accent.chart4,
      chart5: accent.chart5,
      sidebarPrimary: accent.sidebarPrimary,
      sidebarPrimaryForeground: accent.sidebarPrimaryForeground,
    );
  }

  /// Picks black or white — whichever reads better on [background].
  ///
  /// Uses the relative luminance rather than a naive average so that, say,
  /// a saturated yellow correctly gets dark text.
  static Color contrastingForeground(Color background) {
    return background.computeLuminance() > 0.45
        ? const Color(0xff09090b)
        : const Color(0xfffafafa);
  }

  /// Merges this [ShadColorScheme] with [other].
  ///
  /// If [other] is null, returns this instance unchanged.
  /// The [custom] maps are combined, with [other]'s values taking precedence
  /// for duplicate keys.
  ShadColorScheme merge(ShadColorScheme? other) {
    if (other == null) return this;
    if (!other.canMerge) return other;
    return copyWith(
      // [other] opted into the merge, so the combined scheme stays open to
      // further overrides regardless of this scheme's own [canMerge].
      canMerge: true,
      background: other.background,
      foreground: other.foreground,
      card: other.card,
      cardForeground: other.cardForeground,
      popover: other.popover,
      popoverForeground: other.popoverForeground,
      primary: other.primary,
      primaryForeground: other.primaryForeground,
      secondary: other.secondary,
      secondaryForeground: other.secondaryForeground,
      muted: other.muted,
      mutedForeground: other.mutedForeground,
      accent: other.accent,
      accentForeground: other.accentForeground,
      destructive: other.destructive,
      destructiveForeground: other.destructiveForeground,
      border: other.border,
      input: other.input,
      ring: other.ring,
      selection: other.selection,
      chart1: other._chart1 ?? _chart1,
      chart2: other._chart2 ?? _chart2,
      chart3: other._chart3 ?? _chart3,
      chart4: other._chart4 ?? _chart4,
      chart5: other._chart5 ?? _chart5,
      sidebar: other._sidebar ?? _sidebar,
      sidebarForeground: other._sidebarForeground ?? _sidebarForeground,
      sidebarPrimary: other._sidebarPrimary ?? _sidebarPrimary,
      sidebarPrimaryForeground:
          other._sidebarPrimaryForeground ?? _sidebarPrimaryForeground,
      sidebarAccent: other._sidebarAccent ?? _sidebarAccent,
      sidebarAccentForeground:
          other._sidebarAccentForeground ?? _sidebarAccentForeground,
      sidebarBorder: other._sidebarBorder ?? _sidebarBorder,
      sidebarRing: other._sidebarRing ?? _sidebarRing,
      custom: {...custom, ...other.custom},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadColorScheme &&
        other.background == background &&
        other.foreground == foreground &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.selection == selection &&
        other._chart1 == _chart1 &&
        other._chart2 == _chart2 &&
        other._chart3 == _chart3 &&
        other._chart4 == _chart4 &&
        other._chart5 == _chart5 &&
        other._sidebar == _sidebar &&
        other._sidebarForeground == _sidebarForeground &&
        other._sidebarPrimary == _sidebarPrimary &&
        other._sidebarPrimaryForeground == _sidebarPrimaryForeground &&
        other._sidebarAccent == _sidebarAccent &&
        other._sidebarAccentForeground == _sidebarAccentForeground &&
        other._sidebarBorder == _sidebarBorder &&
        other._sidebarRing == _sidebarRing &&
        mapEquals(other.custom, custom);
  }

  @override
  int get hashCode {
    // Object.hash rather than a chain of `^`: XOR is commutative, so swapping
    // any two colors would collide. `custom` is hashed per entry because
    // MapEntry hashes by identity, which would disagree with the mapEquals
    // used by `==`.
    return Object.hashAll([
      background,
      foreground,
      card,
      cardForeground,
      popover,
      popoverForeground,
      primary,
      primaryForeground,
      secondary,
      secondaryForeground,
      muted,
      mutedForeground,
      accent,
      accentForeground,
      destructive,
      destructiveForeground,
      border,
      input,
      ring,
      selection,
      _chart1,
      _chart2,
      _chart3,
      _chart4,
      _chart5,
      _sidebar,
      _sidebarForeground,
      _sidebarPrimary,
      _sidebarPrimaryForeground,
      _sidebarAccent,
      _sidebarAccentForeground,
      _sidebarBorder,
      _sidebarRing,
      Object.hashAllUnordered([
        for (final entry in custom.entries) Object.hash(entry.key, entry.value),
      ]),
    ]);
  }
}
