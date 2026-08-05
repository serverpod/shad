import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/dialog.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('showShadDialog', () {
    Future<void> open(
      WidgetTester tester, {
      bool barrierDismissible = true,
    }) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) => Center(
              child: GestureDetector(
                onTap: () => showShadDialog<void>(
                  context: context,
                  barrierDismissible: barrierDismissible,
                  builder: (context) => const ShadDialog(
                    title: Text('Title'),
                    child: Text('Body'),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping the barrier dismisses it', (tester) async {
      await open(tester);
      expect(find.byType(ShadDialog), findsOneWidget);

      // The corner is outside the centered dialog. The default barrier blur
      // layer sits above the ModalBarrier and must not swallow this tap.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.byType(ShadDialog), findsNothing);
    });

    testWidgets('barrierDismissible: false keeps it open', (tester) async {
      await open(tester, barrierDismissible: false);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.byType(ShadDialog), findsOneWidget);
    });
  });

  group('ShadDialog', () {
    testWidgets('ShadDialog matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadDialog(
            title: Text('Title'),
            description: Text('Description'),
            child: Text('Child'),
          ),
        ),
      );

      expect(
        find.byType(ShadDialog),
        matchesGoldenFile('goldens/dialog.png'),
      );
    });
  });
}
