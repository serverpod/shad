import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/color_scheme/base.dart';

/// An accent overlay for a [ShadColorScheme].
///
/// shadcn/ui splits a theme in two. A *base colour* — neutral, stone, zinc,
/// mauve, olive, mist or taupe — supplies the full neutral palette:
/// backgrounds, borders, muted tones. An *accent* then overrides only the
/// tokens that carry the hue: the primary pair, the secondary pair, the chart
/// ramp and the sidebar primary. Its themes file reflects this exactly — the
/// accent entries define those keys and nothing else.
///
/// [ShadColorScheme] bundles both halves, so this type carries the overlay and
/// [ShadColorScheme.applyAccentScheme] merges it in.
///
/// ```dart
/// ShadThemeData(
///   colorScheme: const ShadZincColorScheme.light()
///       .applyAccentScheme(ShadAccentScheme.violetLight),
/// )
/// ```
///
/// For a one-off hue with no curated ramp, [ShadColorScheme.applyAccent]
/// takes a plain [Color] instead.
@immutable
class ShadAccentScheme {
  const ShadAccentScheme({
    required this.name,
    required this.primary,
    required this.primaryForeground,
    this.secondary,
    this.secondaryForeground,
    this.chart1,
    this.chart2,
    this.chart3,
    this.chart4,
    this.chart5,
    this.sidebarPrimary,
    this.sidebarPrimaryForeground,
  });

  /// The shadcn/ui name of this accent, e.g. `violet`.
  final String name;

  final Color primary;
  final Color primaryForeground;

  /// Overridden only by accents that also restyle the secondary pair.
  final Color? secondary;
  final Color? secondaryForeground;

  final Color? chart1;
  final Color? chart2;
  final Color? chart3;
  final Color? chart4;
  final Color? chart5;

  final Color? sidebarPrimary;
  final Color? sidebarPrimaryForeground;

  /// Every accent, in the order shadcn/ui lists them.
  static const all = <String, (ShadAccentScheme, ShadAccentScheme)>{
    'amber': (amberLight, amberDark),
    'blue': (blueLight, blueDark),
    'cyan': (cyanLight, cyanDark),
    'emerald': (emeraldLight, emeraldDark),
    'fuchsia': (fuchsiaLight, fuchsiaDark),
    'green': (greenLight, greenDark),
    'indigo': (indigoLight, indigoDark),
    'lime': (limeLight, limeDark),
    'orange': (orangeLight, orangeDark),
    'pink': (pinkLight, pinkDark),
    'purple': (purpleLight, purpleDark),
    'red': (redLight, redDark),
    'rose': (roseLight, roseDark),
    'sky': (skyLight, skyDark),
    'teal': (tealLight, tealDark),
    'violet': (violetLight, violetDark),
    'yellow': (yellowLight, yellowDark),
  };

  /// Looks an accent up by shadcn/ui name.
  ///
  /// Throws [ArgumentError] for an unknown name; use `all.containsKey` first
  /// when the name comes from user input.
  static ShadAccentScheme fromName(
    String name, {
    Brightness brightness = Brightness.light,
  }) {
    final pair = all[name];
    if (pair == null) {
      throw ArgumentError.value(name, 'name', 'Unknown accent scheme');
    }
    return brightness == Brightness.light ? pair.$1 : pair.$2;
  }

  /// The shadcn/ui `amber` accent, light mode.
  static const amberLight = ShadAccentScheme(
    name: 'amber',
    primary: Color(0xffbb4d00),
    primaryForeground: Color(0xfffffbeb),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffffd230),
    chart2: Color(0xfffe9a00),
    chart3: Color(0xffe17100),
    chart4: Color(0xffbb4d00),
    chart5: Color(0xff973c00),
    sidebarPrimary: Color(0xffe17100),
    sidebarPrimaryForeground: Color(0xfffffbeb),
  );

  /// The shadcn/ui `amber` accent, dark mode.
  static const amberDark = ShadAccentScheme(
    name: 'amber',
    primary: Color(0xff973c00),
    primaryForeground: Color(0xfffffbeb),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffffd230),
    chart2: Color(0xfffe9a00),
    chart3: Color(0xffe17100),
    chart4: Color(0xffbb4d00),
    chart5: Color(0xff973c00),
    sidebarPrimary: Color(0xfffe9a00),
    sidebarPrimaryForeground: Color(0xff461901),
  );

  /// The shadcn/ui `blue` accent, light mode.
  static const blueLight = ShadAccentScheme(
    name: 'blue',
    primary: Color(0xff1447e6),
    primaryForeground: Color(0xffeff6ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff8ec5ff),
    chart2: Color(0xff2b7fff),
    chart3: Color(0xff155dfc),
    chart4: Color(0xff1447e6),
    chart5: Color(0xff193cb8),
    sidebarPrimary: Color(0xff155dfc),
    sidebarPrimaryForeground: Color(0xffeff6ff),
  );

  /// The shadcn/ui `blue` accent, dark mode.
  static const blueDark = ShadAccentScheme(
    name: 'blue',
    primary: Color(0xff193cb8),
    primaryForeground: Color(0xffeff6ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff8ec5ff),
    chart2: Color(0xff2b7fff),
    chart3: Color(0xff155dfc),
    chart4: Color(0xff1447e6),
    chart5: Color(0xff193cb8),
    sidebarPrimary: Color(0xff2b7fff),
    sidebarPrimaryForeground: Color(0xffeff6ff),
  );

  /// The shadcn/ui `cyan` accent, light mode.
  static const cyanLight = ShadAccentScheme(
    name: 'cyan',
    primary: Color(0xff007595),
    primaryForeground: Color(0xffecfeff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff53eafd),
    chart2: Color(0xff00b8db),
    chart3: Color(0xff0092b8),
    chart4: Color(0xff007595),
    chart5: Color(0xff005f78),
    sidebarPrimary: Color(0xff0092b8),
    sidebarPrimaryForeground: Color(0xffecfeff),
  );

  /// The shadcn/ui `cyan` accent, dark mode.
  static const cyanDark = ShadAccentScheme(
    name: 'cyan',
    primary: Color(0xff005f78),
    primaryForeground: Color(0xffecfeff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff53eafd),
    chart2: Color(0xff00b8db),
    chart3: Color(0xff0092b8),
    chart4: Color(0xff007595),
    chart5: Color(0xff005f78),
    sidebarPrimary: Color(0xff00b8db),
    sidebarPrimaryForeground: Color(0xff053345),
  );

  /// The shadcn/ui `emerald` accent, light mode.
  static const emeraldLight = ShadAccentScheme(
    name: 'emerald',
    primary: Color(0xff007a55),
    primaryForeground: Color(0xffecfdf5),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff5ee9b5),
    chart2: Color(0xff00bc7d),
    chart3: Color(0xff009966),
    chart4: Color(0xff007a55),
    chart5: Color(0xff006045),
    sidebarPrimary: Color(0xff009966),
    sidebarPrimaryForeground: Color(0xffecfdf5),
  );

  /// The shadcn/ui `emerald` accent, dark mode.
  static const emeraldDark = ShadAccentScheme(
    name: 'emerald',
    primary: Color(0xff006045),
    primaryForeground: Color(0xffecfdf5),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff5ee9b5),
    chart2: Color(0xff00bc7d),
    chart3: Color(0xff009966),
    chart4: Color(0xff007a55),
    chart5: Color(0xff006045),
    sidebarPrimary: Color(0xff00bc7d),
    sidebarPrimaryForeground: Color(0xff002c22),
  );

  /// The shadcn/ui `fuchsia` accent, light mode.
  static const fuchsiaLight = ShadAccentScheme(
    name: 'fuchsia',
    primary: Color(0xffa800b7),
    primaryForeground: Color(0xfffdf4ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xfff4a8ff),
    chart2: Color(0xffe12afb),
    chart3: Color(0xffc800de),
    chart4: Color(0xffa800b7),
    chart5: Color(0xff8a0194),
    sidebarPrimary: Color(0xffc800de),
    sidebarPrimaryForeground: Color(0xfffdf4ff),
  );

  /// The shadcn/ui `fuchsia` accent, dark mode.
  static const fuchsiaDark = ShadAccentScheme(
    name: 'fuchsia',
    primary: Color(0xff8a0194),
    primaryForeground: Color(0xfffdf4ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xfff4a8ff),
    chart2: Color(0xffe12afb),
    chart3: Color(0xffc800de),
    chart4: Color(0xffa800b7),
    chart5: Color(0xff8a0194),
    sidebarPrimary: Color(0xffe12afb),
    sidebarPrimaryForeground: Color(0xfffdf4ff),
  );

  /// The shadcn/ui `green` accent, light mode.
  static const greenLight = ShadAccentScheme(
    name: 'green',
    primary: Color(0xff008236),
    primaryForeground: Color(0xfff0fdf4),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff7bf1a8),
    chart2: Color(0xff00c950),
    chart3: Color(0xff00a63e),
    chart4: Color(0xff008236),
    chart5: Color(0xff016630),
    sidebarPrimary: Color(0xff00a63e),
    sidebarPrimaryForeground: Color(0xfff0fdf4),
  );

  /// The shadcn/ui `green` accent, dark mode.
  static const greenDark = ShadAccentScheme(
    name: 'green',
    primary: Color(0xff016630),
    primaryForeground: Color(0xfff0fdf4),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff7bf1a8),
    chart2: Color(0xff00c950),
    chart3: Color(0xff00a63e),
    chart4: Color(0xff008236),
    chart5: Color(0xff016630),
    sidebarPrimary: Color(0xff00c950),
    sidebarPrimaryForeground: Color(0xfff0fdf4),
  );

  /// The shadcn/ui `indigo` accent, light mode.
  static const indigoLight = ShadAccentScheme(
    name: 'indigo',
    primary: Color(0xff432dd7),
    primaryForeground: Color(0xffeef2ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffa3b3ff),
    chart2: Color(0xff615fff),
    chart3: Color(0xff4f39f6),
    chart4: Color(0xff432dd7),
    chart5: Color(0xff372aac),
    sidebarPrimary: Color(0xff4f39f6),
    sidebarPrimaryForeground: Color(0xffeef2ff),
  );

  /// The shadcn/ui `indigo` accent, dark mode.
  static const indigoDark = ShadAccentScheme(
    name: 'indigo',
    primary: Color(0xff372aac),
    primaryForeground: Color(0xffeef2ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffa3b3ff),
    chart2: Color(0xff615fff),
    chart3: Color(0xff4f39f6),
    chart4: Color(0xff432dd7),
    chart5: Color(0xff372aac),
    sidebarPrimary: Color(0xff615fff),
    sidebarPrimaryForeground: Color(0xffeef2ff),
  );

  /// The shadcn/ui `lime` accent, light mode.
  static const limeLight = ShadAccentScheme(
    name: 'lime',
    primary: Color(0xff9ae600),
    primaryForeground: Color(0xff35530e),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffbbf451),
    chart2: Color(0xff7ccf00),
    chart3: Color(0xff5ea500),
    chart4: Color(0xff497d00),
    chart5: Color(0xff3c6300),
    sidebarPrimary: Color(0xff5ea500),
    sidebarPrimaryForeground: Color(0xfff7fee7),
  );

  /// The shadcn/ui `lime` accent, dark mode.
  static const limeDark = ShadAccentScheme(
    name: 'lime',
    primary: Color(0xff7ccf00),
    primaryForeground: Color(0xff35530e),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffbbf451),
    chart2: Color(0xff7ccf00),
    chart3: Color(0xff5ea500),
    chart4: Color(0xff497d00),
    chart5: Color(0xff3c6300),
    sidebarPrimary: Color(0xff7ccf00),
    sidebarPrimaryForeground: Color(0xff192e03),
  );

  /// The shadcn/ui `orange` accent, light mode.
  static const orangeLight = ShadAccentScheme(
    name: 'orange',
    primary: Color(0xffca3500),
    primaryForeground: Color(0xfffff7ed),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffffb86a),
    chart2: Color(0xffff6900),
    chart3: Color(0xfff54900),
    chart4: Color(0xffca3500),
    chart5: Color(0xff9f2d00),
    sidebarPrimary: Color(0xfff54900),
    sidebarPrimaryForeground: Color(0xfffff7ed),
  );

  /// The shadcn/ui `orange` accent, dark mode.
  static const orangeDark = ShadAccentScheme(
    name: 'orange',
    primary: Color(0xff9f2d00),
    primaryForeground: Color(0xfffff7ed),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffffb86a),
    chart2: Color(0xffff6900),
    chart3: Color(0xfff54900),
    chart4: Color(0xffca3500),
    chart5: Color(0xff9f2d00),
    sidebarPrimary: Color(0xffff6900),
    sidebarPrimaryForeground: Color(0xfffff7ed),
  );

  /// The shadcn/ui `pink` accent, light mode.
  static const pinkLight = ShadAccentScheme(
    name: 'pink',
    primary: Color(0xffc6005c),
    primaryForeground: Color(0xfffdf2f8),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xfffda5d5),
    chart2: Color(0xfff6339a),
    chart3: Color(0xffe60076),
    chart4: Color(0xffc6005c),
    chart5: Color(0xffa3004c),
    sidebarPrimary: Color(0xffe60076),
    sidebarPrimaryForeground: Color(0xfffdf2f8),
  );

  /// The shadcn/ui `pink` accent, dark mode.
  static const pinkDark = ShadAccentScheme(
    name: 'pink',
    primary: Color(0xffa3004c),
    primaryForeground: Color(0xfffdf2f8),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xfffda5d5),
    chart2: Color(0xfff6339a),
    chart3: Color(0xffe60076),
    chart4: Color(0xffc6005c),
    chart5: Color(0xffa3004c),
    sidebarPrimary: Color(0xfff6339a),
    sidebarPrimaryForeground: Color(0xfffdf2f8),
  );

  /// The shadcn/ui `purple` accent, light mode.
  static const purpleLight = ShadAccentScheme(
    name: 'purple',
    primary: Color(0xff8200db),
    primaryForeground: Color(0xfffaf5ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffdab2ff),
    chart2: Color(0xffad46ff),
    chart3: Color(0xff9810fa),
    chart4: Color(0xff8200db),
    chart5: Color(0xff6e11b0),
    sidebarPrimary: Color(0xff9810fa),
    sidebarPrimaryForeground: Color(0xfffaf5ff),
  );

  /// The shadcn/ui `purple` accent, dark mode.
  static const purpleDark = ShadAccentScheme(
    name: 'purple',
    primary: Color(0xff6e11b0),
    primaryForeground: Color(0xfffaf5ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffdab2ff),
    chart2: Color(0xffad46ff),
    chart3: Color(0xff9810fa),
    chart4: Color(0xff8200db),
    chart5: Color(0xff6e11b0),
    sidebarPrimary: Color(0xffad46ff),
    sidebarPrimaryForeground: Color(0xfffaf5ff),
  );

  /// The shadcn/ui `red` accent, light mode.
  static const redLight = ShadAccentScheme(
    name: 'red',
    primary: Color(0xffc10007),
    primaryForeground: Color(0xfffef2f2),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffffa2a2),
    chart2: Color(0xfffb2c36),
    chart3: Color(0xffe7000b),
    chart4: Color(0xffc10007),
    chart5: Color(0xff9f0712),
    sidebarPrimary: Color(0xffe7000b),
    sidebarPrimaryForeground: Color(0xfffef2f2),
  );

  /// The shadcn/ui `red` accent, dark mode.
  static const redDark = ShadAccentScheme(
    name: 'red',
    primary: Color(0xff9f0712),
    primaryForeground: Color(0xfffef2f2),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffffa2a2),
    chart2: Color(0xfffb2c36),
    chart3: Color(0xffe7000b),
    chart4: Color(0xffc10007),
    chart5: Color(0xff9f0712),
    sidebarPrimary: Color(0xfffb2c36),
    sidebarPrimaryForeground: Color(0xfffef2f2),
  );

  /// The shadcn/ui `rose` accent, light mode.
  static const roseLight = ShadAccentScheme(
    name: 'rose',
    primary: Color(0xffc70036),
    primaryForeground: Color(0xfffff1f2),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffffa1ad),
    chart2: Color(0xffff2056),
    chart3: Color(0xffec003f),
    chart4: Color(0xffc70036),
    chart5: Color(0xffa50036),
    sidebarPrimary: Color(0xffec003f),
    sidebarPrimaryForeground: Color(0xfffff1f2),
  );

  /// The shadcn/ui `rose` accent, dark mode.
  static const roseDark = ShadAccentScheme(
    name: 'rose',
    primary: Color(0xffa50036),
    primaryForeground: Color(0xfffff1f2),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffffa1ad),
    chart2: Color(0xffff2056),
    chart3: Color(0xffec003f),
    chart4: Color(0xffc70036),
    chart5: Color(0xffa50036),
    sidebarPrimary: Color(0xffff2056),
    sidebarPrimaryForeground: Color(0xfffff1f2),
  );

  /// The shadcn/ui `sky` accent, light mode.
  static const skyLight = ShadAccentScheme(
    name: 'sky',
    primary: Color(0xff0069a8),
    primaryForeground: Color(0xfff0f9ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff74d4ff),
    chart2: Color(0xff00a6f4),
    chart3: Color(0xff0084d1),
    chart4: Color(0xff0069a8),
    chart5: Color(0xff00598a),
    sidebarPrimary: Color(0xff0084d1),
    sidebarPrimaryForeground: Color(0xfff0f9ff),
  );

  /// The shadcn/ui `sky` accent, dark mode.
  static const skyDark = ShadAccentScheme(
    name: 'sky',
    primary: Color(0xff00598a),
    primaryForeground: Color(0xfff0f9ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff74d4ff),
    chart2: Color(0xff00a6f4),
    chart3: Color(0xff0084d1),
    chart4: Color(0xff0069a8),
    chart5: Color(0xff00598a),
    sidebarPrimary: Color(0xff00a6f4),
    sidebarPrimaryForeground: Color(0xff052f4a),
  );

  /// The shadcn/ui `teal` accent, light mode.
  static const tealLight = ShadAccentScheme(
    name: 'teal',
    primary: Color(0xff00786f),
    primaryForeground: Color(0xfff0fdfa),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xff46ecd5),
    chart2: Color(0xff00bba7),
    chart3: Color(0xff009689),
    chart4: Color(0xff00786f),
    chart5: Color(0xff005f5a),
    sidebarPrimary: Color(0xff009689),
    sidebarPrimaryForeground: Color(0xfff0fdfa),
  );

  /// The shadcn/ui `teal` accent, dark mode.
  static const tealDark = ShadAccentScheme(
    name: 'teal',
    primary: Color(0xff005f5a),
    primaryForeground: Color(0xfff0fdfa),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xff46ecd5),
    chart2: Color(0xff00bba7),
    chart3: Color(0xff009689),
    chart4: Color(0xff00786f),
    chart5: Color(0xff005f5a),
    sidebarPrimary: Color(0xff00bba7),
    sidebarPrimaryForeground: Color(0xff022f2e),
  );

  /// The shadcn/ui `violet` accent, light mode.
  static const violetLight = ShadAccentScheme(
    name: 'violet',
    primary: Color(0xff7008e7),
    primaryForeground: Color(0xfff5f3ff),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffc4b4ff),
    chart2: Color(0xff8e51ff),
    chart3: Color(0xff7f22fe),
    chart4: Color(0xff7008e7),
    chart5: Color(0xff5d0ec0),
    sidebarPrimary: Color(0xff7f22fe),
    sidebarPrimaryForeground: Color(0xfff5f3ff),
  );

  /// The shadcn/ui `violet` accent, dark mode.
  static const violetDark = ShadAccentScheme(
    name: 'violet',
    primary: Color(0xff5d0ec0),
    primaryForeground: Color(0xfff5f3ff),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffc4b4ff),
    chart2: Color(0xff8e51ff),
    chart3: Color(0xff7f22fe),
    chart4: Color(0xff7008e7),
    chart5: Color(0xff5d0ec0),
    sidebarPrimary: Color(0xff8e51ff),
    sidebarPrimaryForeground: Color(0xfff5f3ff),
  );

  /// The shadcn/ui `yellow` accent, light mode.
  static const yellowLight = ShadAccentScheme(
    name: 'yellow',
    primary: Color(0xfffdc700),
    primaryForeground: Color(0xff733e0a),
    secondary: Color(0xfff4f4f5),
    secondaryForeground: Color(0xff18181b),
    chart1: Color(0xffffdf20),
    chart2: Color(0xfff0b100),
    chart3: Color(0xffd08700),
    chart4: Color(0xffa65f00),
    chart5: Color(0xff894b00),
    sidebarPrimary: Color(0xffd08700),
    sidebarPrimaryForeground: Color(0xfffefce8),
  );

  /// The shadcn/ui `yellow` accent, dark mode.
  static const yellowDark = ShadAccentScheme(
    name: 'yellow',
    primary: Color(0xfff0b100),
    primaryForeground: Color(0xff733e0a),
    secondary: Color(0xff27272a),
    secondaryForeground: Color(0xfffafafa),
    chart1: Color(0xffffdf20),
    chart2: Color(0xfff0b100),
    chart3: Color(0xffd08700),
    chart4: Color(0xffa65f00),
    chart5: Color(0xff894b00),
    sidebarPrimary: Color(0xfff0b100),
    sidebarPrimaryForeground: Color(0xfffefce8),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShadAccentScheme &&
        other.name == name &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.chart1 == chart1 &&
        other.chart2 == chart2 &&
        other.chart3 == chart3 &&
        other.chart4 == chart4 &&
        other.chart5 == chart5 &&
        other.sidebarPrimary == sidebarPrimary &&
        other.sidebarPrimaryForeground == sidebarPrimaryForeground;
  }

  @override
  int get hashCode => Object.hash(
    name,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
    sidebarPrimary,
    sidebarPrimaryForeground,
  );
}
