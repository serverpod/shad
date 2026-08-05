import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// Pins the values generated from shadcn/ui's `registry/themes.ts`.
///
/// The generator converted each OKLCH literal to sRGB; these spot-checks catch
/// a conversion or transcription error, which would otherwise be invisible.
void main() {
  group('base colour schemes', () {
    test('mist light matches shadcn', () {
      const s = ShadMistColorScheme.light();
      // oklch(1 0 0)
      expect(s.background, const Color(0xffffffff));
      // oklch(0.145 0.008 240) -> a very slightly blue near-black
      expect(s.foreground, const Color(0xff090b0c));
    });

    test('the four new base palettes are reachable by name', () {
      for (final name in ['mauve', 'olive', 'mist', 'taupe']) {
        expect(
          ShadColorScheme.fromName(name),
          isNotNull,
          reason: '$name should resolve',
        );
        expect(
          ShadColorScheme.fromName(name, brightness: Brightness.dark),
          isNotNull,
        );
      }
    });

    test('a base palette carries its own chart ramp', () {
      const s = ShadMistColorScheme.light();
      // Explicit chart tokens, not the derived fallback.
      expect(s.charts, hasLength(5));
      expect(s.chart1, isNot(s.chart5));
    });
  });

  group('ShadAccentScheme', () {
    test('all seventeen shadcn accents are present', () {
      expect(ShadAccentScheme.all, hasLength(17));
      for (final entry in ShadAccentScheme.all.entries) {
        expect(entry.value.$1.name, entry.key);
        expect(entry.value.$2.name, entry.key);
      }
    });

    test('violet light matches shadcn', () {
      // themes.ts: oklch(0.491 0.27 292.581), i.e. Tailwind v4 violet-700.
      // Note these are the v4 OKLCH-native values, which differ slightly from
      // the v3 sRGB hexes.
      expect(ShadAccentScheme.violetLight.primary, const Color(0xff7008e7));
    });

    test('the OKLCH conversion is accurate', () {
      // shadcn's destructive is oklch(0.577 0.245 27.325) — Tailwind v4's
      // red-600, published as #e7000b. If the conversion drifts, this catches
      // it against a value that can be checked against Tailwind directly.
      expect(
        const ShadMistColorScheme.light().destructive,
        const Color(0xffe7000b),
      );
    });

    test('fromName resolves per brightness and rejects unknown names', () {
      expect(
        ShadAccentScheme.fromName('violet'),
        ShadAccentScheme.violetLight,
      );
      expect(
        ShadAccentScheme.fromName('violet', brightness: Brightness.dark),
        ShadAccentScheme.violetDark,
      );
      expect(
        () => ShadAccentScheme.fromName('chartreuse'),
        throwsArgumentError,
      );
    });
  });

  group('applyAccentScheme', () {
    const base = ShadZincColorScheme.light();

    test('takes the accent hue and keeps the neutral palette', () {
      final themed = base.applyAccentScheme(ShadAccentScheme.violetLight);

      expect(themed.primary, ShadAccentScheme.violetLight.primary);
      expect(themed.ring, ShadAccentScheme.violetLight.primary);
      // Neutrals untouched — the whole point of the base/accent split.
      expect(themed.background, base.background);
      expect(themed.border, base.border);
      expect(themed.muted, base.muted);
      expect(themed.destructive, base.destructive);
    });

    test('adopts the accent chart ramp', () {
      final themed = base.applyAccentScheme(ShadAccentScheme.violetLight);
      expect(themed.chart1, ShadAccentScheme.violetLight.chart1);
      expect(themed.chart5, ShadAccentScheme.violetLight.chart5);
    });

    test('every accent applies to every base without error', () {
      for (final name in ShadAccentScheme.all.keys) {
        for (final brightness in Brightness.values) {
          for (final baseName in [
            'neutral',
            'stone',
            'zinc',
            'mauve',
            'olive',
            'mist',
            'taupe',
          ]) {
            final scheme =
                ShadColorScheme.fromName(
                  baseName,
                  brightness: brightness,
                ).applyAccentScheme(
                  ShadAccentScheme.fromName(name, brightness: brightness),
                );
            expect(scheme.primary, isNotNull);
          }
        }
      }
    });
  });

  group('chart and sidebar fallbacks', () {
    test('a scheme without explicit tokens derives a usable ramp', () {
      // Slate predates the chart tokens and leaves them unset.
      const s = ShadSlateColorScheme.light();
      expect(s.chart1, s.primary);
      expect(s.chart5, s.mutedForeground);
      expect(s.charts, hasLength(5));
    });

    test('sidebar tokens fall back to their closest neighbour', () {
      const s = ShadSlateColorScheme.light();
      expect(s.sidebar, s.card);
      expect(s.sidebarForeground, s.cardForeground);
      expect(s.sidebarPrimary, s.primary);
      expect(s.sidebarBorder, s.border);
      expect(s.sidebarRing, s.ring);
    });

    test('explicit tokens win over the fallback', () {
      final s = const ShadSlateColorScheme.light().copyWith(
        chart1: const Color(0xff123456),
        sidebar: const Color(0xff654321),
      );
      expect(s.chart1, const Color(0xff123456));
      expect(s.sidebar, const Color(0xff654321));
    });

    test('the new tokens take part in equality', () {
      const a = ShadSlateColorScheme.light();
      final b = a.copyWith(chart1: const Color(0xff123456));
      expect(a, isNot(b));
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('lerp interpolates the new tokens', () {
      final a = const ShadSlateColorScheme.light().copyWith(
        chart1: const Color(0xff000000),
      );
      final b = const ShadSlateColorScheme.light().copyWith(
        chart1: const Color(0xffffffff),
      );
      final mid = ShadColorScheme.lerp(a, b, .5);
      expect(mid.chart1.r, closeTo(.5, .05));
    });
  });
}
