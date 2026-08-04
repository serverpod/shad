import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Locks the value-equality chain behind [ShadThemeData].
///
/// [ShadApp] wraps its child in a [ShadAnimatedTheme], an
/// [ImplicitlyAnimatedWidget] that starts a 200ms transition whenever the new
/// theme is not `==` the old one. Every field of [ShadThemeData] therefore has
/// to be a proper value type, or an app that constructs its theme inline
/// re-lerps all 54 component themes on every single rebuild.
void main() {
  ShadThemeData buildTheme() => ShadThemeData(
    colorScheme: const ShadSlateColorScheme.light(),
    brightness: Brightness.light,
  );

  group('ShadThemeData equality', () {
    test('two identically-constructed themes are equal', () {
      final a = buildTheme();
      final b = buildTheme();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('decoration is a value type (ShadBorder ==)', () {
      // Regression: ShadBorder had no operator==, so ShadDecoration.== fell
      // back to identity and every ShadThemeData was unequal.
      expect(buildTheme().decoration, equals(buildTheme().decoration));
    });

    test('breakpoints is a value type (ShadBreakpoints ==)', () {
      // Regression: ShadBreakpoints had no operator== and the factory
      // allocates a fresh instance per ShadThemeData.
      expect(buildTheme().breakpoints, equals(buildTheme().breakpoints));
      expect(ShadBreakpoints(), equals(ShadBreakpoints()));
      expect(ShadBreakpoints().hashCode, equals(ShadBreakpoints().hashCode));
    });

    test('breakpoints of different sizes are not equal', () {
      expect(ShadBreakpoints(), isNot(equals(ShadBreakpoints(md: 900))));
    });

    test('copyWith with no arguments returns an equal theme', () {
      final theme = buildTheme();
      expect(theme.copyWith(), equals(theme));
    });

    test('copyWith preserves a custom variant', () {
      // Regression: `variant` was constructor-only and never stored, so
      // copyWith silently reset it to ShadDefaultThemeVariant. ShadDialog,
      // ShadTooltip and ShadSonner all call copyWith in build().
      final variant = ShadDefaultThemeNoSecondaryBorderVariant(
        colorScheme: const ShadSlateColorScheme.light(),
        radius: const BorderRadius.all(Radius.circular(6)),
        effectiveTextTheme: ShadDefaultThemeVariant.defaultTextTheme,
      );
      final theme = ShadThemeData(
        colorScheme: const ShadSlateColorScheme.light(),
        brightness: Brightness.light,
        variant: variant,
      );

      expect(theme.variant, same(variant));
      expect(theme.copyWith().variant, same(variant));
      expect(theme.copyWith(disabledOpacity: .3).variant, same(variant));
    });

    test('a genuine difference still compares unequal', () {
      final a = buildTheme();
      final b = ShadThemeData(
        colorScheme: const ShadSlateColorScheme.dark(),
        brightness: Brightness.dark,
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('ShadBorder / ShadBorderSide equality', () {
    test('identical border sides are equal and hash alike', () {
      // Regression: `==` and `hashCode` referenced the `merge` METHOD tear-off
      // instead of the `canMerge` field, so every instance hashed uniquely.
      const a = ShadBorderSide(color: Color(0xFF00FF00), width: 2);
      const b = ShadBorderSide(color: Color(0xFF00FF00), width: 2);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('border sides differing only in canMerge are not equal', () {
      const a = ShadBorderSide(color: Color(0xFF00FF00), canMerge: false);
      const b = ShadBorderSide(color: Color(0xFF00FF00));
      expect(a, isNot(equals(b)));
    });

    test('identical borders are equal and hash alike', () {
      final a = ShadBorder.all(color: const Color(0xFF0000FF), width: 1);
      final b = ShadBorder.all(color: const Color(0xFF0000FF), width: 1);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('borders differing in a single field are not equal', () {
      expect(
        ShadBorder.all(width: 1),
        isNot(equals(ShadBorder.all(width: 2))),
      );
    });

    test('copyWith preserves canMerge', () {
      expect(ShadBorder.none.copyWith(offset: 2).canMerge, isFalse);
    });

    test('== is symmetric against the superellipse subclass', () {
      const base = ShadBorder(offset: 2);
      const sub = ShadRoundedSuperellipseBorder(canMerge: false);

      expect(base == sub, isFalse);
      expect(sub == base, isFalse);
    });

    test('superellipse borders compare all fields', () {
      const a = ShadRoundedSuperellipseBorder(
        radius: BorderRadius.all(Radius.circular(4)),
      );
      const b = ShadRoundedSuperellipseBorder(
        radius: BorderRadius.all(Radius.circular(4)),
      );
      const c = ShadRoundedSuperellipseBorder(
        radius: BorderRadius.all(Radius.circular(8)),
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      // Regression: hashCode was `side.hashCode`, ignoring radius.
      expect(a, isNot(equals(c)));
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });
  });

  group('ShadColorScheme', () {
    test('swapping two colors changes the hash', () {
      // Regression: hashCode was a chain of `^`, which is commutative.
      const a = ShadSlateColorScheme.light();
      final swapped = a.copyWith(primary: a.secondary, secondary: a.primary);

      expect(a, isNot(equals(swapped)));
      expect(a.hashCode, isNot(equals(swapped.hashCode)));
    });

    test('copyWith preserves canMerge', () {
      // Regression: copyWith dropped canMerge, and merge() is built on
      // copyWith, so the "replace, don't merge" opt-out was unrecoverable.
      final scheme = const ShadSlateColorScheme.light().copyWith(
        canMerge: false,
      );
      expect(scheme.copyWith(primary: const Color(0xFFFF0000)).canMerge, false);
    });

    test('equal custom maps hash alike', () {
      // Regression: hashed MapEntry objects, which hash by identity, while
      // `==` used mapEquals.
      final a = const ShadSlateColorScheme.light().copyWith(
        custom: {'brand': const Color(0xFF123456)},
      );
      final b = const ShadSlateColorScheme.light().copyWith(
        custom: {'brand': const Color(0xFF123456)},
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('ShadTextTheme', () {
    // copyWith has no canMerge parameter, so rebuild through .custom.
    ShadTextTheme withCanMerge(ShadTextTheme base, {required bool canMerge}) =>
        ShadTextTheme.custom(
          canMerge: canMerge,
          h1Large: base.h1Large,
          h1: base.h1,
          h2: base.h2,
          h3: base.h3,
          h4: base.h4,
          p: base.p,
          blockquote: base.blockquote,
          table: base.table,
          list: base.list,
          lead: base.lead,
          large: base.large,
          small: base.small,
          muted: base.muted,
          family: base.family,
          googleFontBuilder: base.googleFontBuilder,
          custom: base.custom,
        );

    test('themes differing only in canMerge are equal and hash alike', () {
      // Regression: canMerge was in hashCode but not in ==, so two themes
      // could be equal while hashing differently.
      final a = ShadTextTheme(family: 'Geist');
      final b = withCanMerge(a, canMerge: false);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('lerp preserves canMerge', () {
      final a = withCanMerge(ShadTextTheme(family: 'Geist'), canMerge: false);
      final b = withCanMerge(ShadTextTheme(family: 'Geist'), canMerge: false);

      expect(ShadTextTheme.lerp(a, b, 0)!.canMerge, isFalse);
      expect(ShadTextTheme.lerp(a, b, 1)!.canMerge, isFalse);
    });

    test('lerp of two nulls returns null instead of throwing', () {
      expect(ShadTextTheme.lerp(null, null, .5), isNull);
    });
  });

  testWidgets('an inline theme does not re-animate on every rebuild', (
    tester,
  ) async {
    // The end-to-end symptom: ShadApp rebuilding with an equal-but-new
    // ShadThemeData used to restart a 200ms lerp across all component themes,
    // republishing a new theme every frame.
    final rebuild = ValueNotifier(0);
    addTearDown(rebuild.dispose);
    final seen = <ShadThemeData>[];

    await tester.pumpWidget(
      ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, value, _) {
          return ShadApp(
            theme: ShadThemeData(
              colorScheme: const ShadSlateColorScheme.light(),
              brightness: Brightness.light,
            ),
            home: Builder(
              builder: (context) {
                seen.add(ShadTheme.of(context));
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final settled = seen.last;
    seen.clear();

    rebuild.value = 1;
    await tester.pump();
    // Advance past where a 200ms theme transition would have run.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      seen.every((theme) => theme == settled),
      isTrue,
      reason: 'the theme should not be animated when it did not change',
    );
  });
}
