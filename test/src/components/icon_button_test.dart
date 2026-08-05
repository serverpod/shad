import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/button.dart';
import 'package:shad/src/components/icon_button.dart';
import 'package:shad/src/theme/color_scheme/zinc.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/spacing.dart';
import 'package:shad/src/theme/style.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('ShadIconButton', () {
    testWidgets('ShadIconButton matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(
        find.byType(ShadIconButton),
        matchesGoldenFile('goldens/icon_button.png'),
      );
    });

    testWidgets('ShadIconButton.destructive matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton.destructive(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(
        find.byType(ShadIconButton),
        matchesGoldenFile('goldens/icon_button_destructive.png'),
      );
    });

    testWidgets('ShadIconButton.outline matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton.outline(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(
        find.byType(ShadIconButton),
        matchesGoldenFile('goldens/icon_button_outline.png'),
      );
    });
    testWidgets('ShadIconButton.secondary matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton.secondary(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(
        find.byType(ShadIconButton),
        matchesGoldenFile('goldens/icon_button_secondary.png'),
      );
    });

    testWidgets('ShadIconButton.ghost matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton.ghost(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(
        find.byType(ShadIconButton),
        matchesGoldenFile('goldens/icon_button_ghost.png'),
      );
    });

    testWidgets('ShadIconButton.iconSize updates icon size', (tester) async {
      const customIconSize = 10.0;
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton(
            icon: Icon(Icons.add),
            iconSize: customIconSize,
          ),
        ),
      );

      final iconSize = tester.getSize(find.byType(Icon));
      expect(iconSize, const Size.square(customIconSize));
    });

    testWidgets("the icon defaults to the style, not to Flutter's 24", (
      tester,
    ) async {
      // `.cn-button` is `[&_svg:not([class*='size-'])]:size-4`; without a
      // size the IconTheme fallback used to render every icon at 24.
      await tester.pumpWidget(
        createTestWidget(const ShadIconButton(icon: Icon(Icons.add))),
      );

      expect(tester.getSize(find.byType(Icon)), const Size.square(16));
      // nova's `.cn-button-size-icon` is `size-8`.
      expect(
        tester.getSize(find.byType(ShadIconButton)),
        const Size.square(32),
      );
    });

    testWidgets('an icon carrying its own size still wins', (tester) async {
      // The reference's `:not([class*='size-'])`.
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton(icon: Icon(Icons.add, size: 20)),
        ),
      );

      expect(tester.getSize(find.byType(Icon)), const Size.square(20));
    });

    testWidgets('the square sizes come from the icon slots', (tester) async {
      // `.cn-button-size-icon-sm` keeps the 16px glyph that
      // `.cn-button-size-sm` shrinks to 14 — icon buttons are sized
      // independently of text buttons at the same step.
      await tester.pumpWidget(
        createTestWidget(
          const ShadIconButton(
            icon: Icon(Icons.add),
            size: ShadButtonSize.sm,
          ),
        ),
      );

      expect(tester.getSize(find.byType(Icon)), const Size.square(16));
      expect(
        tester.getSize(find.byType(ShadIconButton)),
        const Size.square(28),
      );
    });
  });

  group('the styles size their glyphs', () {
    // Read off `[&_svg:not([class*='size-'])]:size-*` in
    // apps/v4/registry/styles/style-*.css: most styles keep 16 everywhere,
    // `mira` follows the step down and `sera`'s base is `size-3.5`.
    const expected = {
      'vega': (16.0, 16.0, 16.0),
      'nova': (14.0, 16.0, 16.0),
      'maia': (16.0, 16.0, 16.0),
      'lyra': (14.0, 16.0, 16.0),
      'mira': (12.0, 14.0, 16.0),
      'luma': (16.0, 16.0, 16.0),
      'sera': (14.0, 14.0, 14.0),
      'rhea': (16.0, 16.0, 16.0),
    };

    test('text buttons', () {
      for (final entry in expected.entries) {
        final sizes = ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
          style: ShadStyleTokens.fromName(entry.key),
        ).buttonSizesTheme;

        expect(
          (sizes.sm!.iconSize, sizes.regular!.iconSize, sizes.lg!.iconSize),
          entry.value,
          reason: entry.key,
        );
      }
    });

    test('icon buttons keep the base glyph except in mira and sera', () {
      const iconExpected = {
        'vega': (16.0, 16.0, 16.0),
        'nova': (16.0, 16.0, 16.0),
        'maia': (16.0, 16.0, 16.0),
        'lyra': (16.0, 16.0, 16.0),
        'mira': (12.0, 14.0, 16.0),
        'luma': (16.0, 16.0, 16.0),
        'sera': (14.0, 14.0, 14.0),
        'rhea': (16.0, 16.0, 16.0),
      };

      for (final entry in iconExpected.entries) {
        final sizes = ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
          style: ShadStyleTokens.fromName(entry.key),
        ).buttonSizesTheme;

        expect(
          (
            sizes.iconSm!.iconSize,
            sizes.icon!.iconSize,
            sizes.iconLg!.iconSize,
          ),
          entry.value,
          reason: entry.key,
        );
      }
    });

    test('the spacing unit scales them', () {
      // `size-4` is `calc(var(--spacing) * 4)`, so a wider unit widens the
      // glyph with everything else.
      final theme = ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
        spacing: const ShadSpacing(step: 5),
      );
      expect(theme.buttonSizesTheme.icon!.iconSize, 20);
    });
  });
}
