import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// `copyWith` re-derives the component themes from the theme's inputs, so a
/// copy is indistinguishable from a theme built with those inputs directly.
void main() {
  final base = ShadThemeData(
    colorScheme: const ShadZincColorScheme.light(),
    brightness: Brightness.light,
  );

  test('copyWith(radius:) moves the component themes too', () {
    const radius = BorderRadius.all(Radius.circular(2));
    final copy = base.copyWith(radius: radius);
    final direct = ShadThemeData(
      colorScheme: const ShadZincColorScheme.light(),
      brightness: Brightness.light,
      radius: radius,
    );

    expect(copy.radius, radius);
    expect(copy.primaryButtonTheme, direct.primaryButtonTheme);
    expect(copy.inputTheme, direct.inputTheme);
    expect(copy, direct);
  });

  test('copyWith(colorScheme:) recolours the component themes', () {
    final copy = base.copyWith(colorScheme: const ShadRoseColorScheme.light());
    final direct = ShadThemeData(
      colorScheme: const ShadRoseColorScheme.light(),
      brightness: Brightness.light,
    );
    expect(copy.primaryButtonTheme, direct.primaryButtonTheme);
    expect(copy, direct);
  });

  test('copyWith(style:) and copyWith(spacing:) re-derive metrics', () {
    final copy = base.copyWith(
      style: ShadStyleTokens.mira,
      spacing: const ShadSpacing(step: 3),
    );
    final direct = ShadThemeData(
      colorScheme: const ShadZincColorScheme.light(),
      brightness: Brightness.light,
      style: ShadStyleTokens.mira,
      spacing: const ShadSpacing(step: 3),
    );
    expect(copy.style, ShadStyleTokens.mira);
    expect(copy.spacing.step, 3);
    expect(copy, direct);
  });

  test('copyWith(disableSecondaryBorder: true) switches the variant', () {
    final copy = base.copyWith(disableSecondaryBorder: true);
    expect(copy.variant, isA<ShadDefaultThemeNoSecondaryBorderVariant>());
  });

  test('component overrides survive a copy', () {
    final themed = ShadThemeData(
      colorScheme: const ShadZincColorScheme.light(),
      brightness: Brightness.light,
      cardTheme: const ShadCardTheme(padding: EdgeInsets.all(3)),
    );
    final copy = themed.copyWith(radius: BorderRadius.circular(1));
    expect(copy.cardTheme.padding, const EdgeInsets.all(3));
  });

  test('a copy with no arguments equals the original', () {
    expect(base.copyWith(), base);
  });

  group('brightness', () {
    test('follows a dark scheme when not given', () {
      final theme = ShadThemeData(
        colorScheme: const ShadZincColorScheme.dark(),
      );
      expect(theme.brightness, Brightness.dark);
    });

    test('follows a light scheme when not given', () {
      final theme = ShadThemeData(
        colorScheme: const ShadZincColorScheme.light(),
      );
      expect(theme.brightness, Brightness.light);
    });

    test('an explicit brightness wins', () {
      final theme = ShadThemeData(
        colorScheme: const ShadZincColorScheme.dark(),
        brightness: Brightness.light,
      );
      expect(theme.brightness, Brightness.light);
    });
  });
}
