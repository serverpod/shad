import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/tooltip.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/style.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('ShadTooltip', () {
    testWidgets('ShadDatePicker matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ShadTooltip(
            builder: (context) {
              return const Text('Tooltip');
            },
            child: const Text('trigger'),
          ),
        ),
      );

      expect(
        find.byType(ShadTooltip),
        matchesGoldenFile('goldens/tooltip.png'),
      );
      await tester.pumpAndSettle();
    });
  });

  group('tooltip theme resolution', () {
    // `.cn-tooltip-content` is the inverted surface: `bg-foreground
    // text-background` at `text-xs`, borderless and shadowless, with a
    // per-style radius one notch under the popover's.
    test('the surface is inverted, shadowless, at text-xs', () {
      final theme = ShadThemeData();
      final tooltip = theme.tooltipTheme;
      expect(tooltip.decoration?.color, theme.colorScheme.foreground);
      expect(tooltip.decoration?.shadows, isNull);
      expect(tooltip.textStyle?.color, theme.colorScheme.background);
      expect(tooltip.textStyle?.fontSize, 12);
      expect(tooltip.showArrow, isTrue);
      expect(tooltip.arrowSize, 10);
      expect(tooltip.arrowRadius, 2);
    });

    test('the radius follows the style, and square styles sharpen the tip',
        () {
      BorderRadius radiusOf(ShadStyleTokens style) =>
          ShadThemeData(style: style)
              .tooltipTheme
              .decoration!
              .border!
              .radius!
              .resolve(TextDirection.ltr);

      // vega `rounded-md` 8, maia `rounded-2xl` 16, luma `rounded-xl` 14.
      expect(radiusOf(ShadStyleTokens.vega).topLeft.x, 8);
      expect(radiusOf(ShadStyleTokens.maia).topLeft.x, 16);
      expect(radiusOf(ShadStyleTokens.luma).topLeft.x, 14);
      expect(radiusOf(ShadStyleTokens.lyra), BorderRadius.zero);
      expect(radiusOf(ShadStyleTokens.sera), BorderRadius.zero);
      expect(ShadThemeData(style: ShadStyleTokens.lyra)
          .tooltipTheme.arrowRadius, 0);
    });
  });

  group('the arrow', () {
    // The arrow is the one widget rotated by exactly 45°.
    Finder diamond() => find.byWidgetPredicate((widget) {
      if (widget is! Transform) return false;
      final storage = widget.transform.storage;
      const sqrt2over2 = 0.7071;
      return (storage[0] - sqrt2over2).abs() < .01 &&
          (storage[1] - sqrt2over2).abs() < .01;
    });

    testWidgets('rides the bottom edge when the tooltip sits above', (
      tester,
    ) async {
      final controller = ShadTooltipController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: ShadTooltip(
              controller: controller,
              builder: (_) => const Text('Tooltip'),
              child: const Text('trigger'),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(diamond(), findsOneWidget);
      final tooltipCenter = tester.getCenter(find.text('Tooltip'));
      final arrowCenter = tester.getCenter(diamond());
      final triggerCenter = tester.getCenter(find.text('trigger'));
      // Tooltip above the trigger; the arrow between them.
      expect(tooltipCenter.dy, lessThan(triggerCenter.dy));
      expect(arrowCenter.dy, greaterThan(tooltipCenter.dy));
      expect(arrowCenter.dy, lessThan(triggerCenter.dy));
    });

    testWidgets('flips above when the portal falls back below', (
      tester,
    ) async {
      final controller = ShadTooltipController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        createTestWidget(
          Align(
            // No room above: the fallback anchor places the tooltip below.
            alignment: Alignment.topCenter,
            child: ShadTooltip(
              controller: controller,
              builder: (_) => const Text('Tooltip'),
              child: const Text('trigger'),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      final tooltipCenter = tester.getCenter(find.text('Tooltip'));
      final arrowCenter = tester.getCenter(diamond());
      final triggerCenter = tester.getCenter(find.text('trigger'));
      // Tooltip below the trigger; the arrow between them, above the bubble.
      expect(tooltipCenter.dy, greaterThan(triggerCenter.dy));
      expect(arrowCenter.dy, lessThan(tooltipCenter.dy));
    });

    testWidgets('can be turned off', (tester) async {
      final controller = ShadTooltipController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: ShadTooltip(
              controller: controller,
              showArrow: false,
              builder: (_) => const Text('Tooltip'),
              child: const Text('trigger'),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Tooltip'), findsOneWidget);
      expect(diamond(), findsNothing);
    });
  });
}
