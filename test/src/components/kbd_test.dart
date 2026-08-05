import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/kbd.dart';
import 'package:shad/src/theme/theme.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('ShadKbd', () {
    testWidgets('keeps its own height inside a stretched row', (tester) async {
      // Regression: the key cap had no height of its own, so in a row that
      // stretches its children — a button's content row, for one — it grew to
      // the full height of the row instead of staying key-shaped.
      await tester.pumpWidget(
        createTestWidget(
          const SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [ShadKbd('K')],
            ),
          ),
        ),
      );

      final theme = ShadTheme.of(tester.element(find.byType(ShadKbd)));
      final cap = tester.getSize(
        find.descendant(
          of: find.byType(ShadKbd),
          matching: find.byType(Container),
        ),
      );

      expect(cap.height, theme.kbdTheme.height);
      expect(cap.height, lessThan(80));
    });

    testWidgets('height follows the theme', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: ShadKbd('K', height: 32))),
      );

      expect(tester.getSize(find.byType(ShadKbd)).height, 32);
    });
  });
}
