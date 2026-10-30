import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('a popover surface matches a ShadPopover', (tester) async {
    final controller = ShadPopoverController(isOpen: true);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      ShadApp(
        home: Column(
          children: [
            const ShadSurface(child: Text('surface')),
            ShadPopover(
              controller: controller,
              popover: (_) => const Text('popover'),
              child: const SizedBox(width: 10, height: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    ShadDecoration decorationAbove(String text) => tester
        .widget<ShadDecorator>(
          find
              .ancestor(
                of: find.text(text),
                matching: find.byType(ShadDecorator),
              )
              .first,
        )
        .decoration!;

    final surface = decorationAbove('surface');
    final popover = decorationAbove('popover');
    expect(surface.color, popover.color);
    expect(surface.border, popover.border);
    expect(surface.shadows, popover.shadows);
  });

  group('showShadPopover', () {
    Future<void> open(WidgetTester tester, Rect anchor) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ShadApp(
          home: Builder(
            builder: (context) => ShadButton(
              onPressed: () => showShadPopover<void>(
                context: context,
                anchorRect: anchor,
                builder: (_) => const SizedBox(
                  width: 120,
                  height: 80,
                  child: Text('content'),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    Rect surfaceRect(WidgetTester tester) => tester.getRect(
      find
          .ancestor(
            of: find.text('content'),
            matching: find.byType(ShadDecorator),
          )
          .first,
    );

    testWidgets('opens below the rectangle, centred on it', (tester) async {
      const anchor = Rect.fromLTWH(300, 100, 40, 20);
      await open(tester, anchor);
      final rect = surfaceRect(tester);
      expect(rect.top, moreOrLessEquals(anchor.bottom + 4, epsilon: .5));
      expect(rect.center.dx, moreOrLessEquals(anchor.center.dx, epsilon: .5));
    });

    testWidgets('moves above when there is no room below', (tester) async {
      const anchor = Rect.fromLTWH(300, 560, 40, 20);
      await open(tester, anchor);
      final rect = surfaceRect(tester);
      expect(rect.bottom, moreOrLessEquals(anchor.top - 4, epsilon: .5));
    });

    testWidgets('closes on Escape and on a tap outside', (tester) async {
      await open(tester, const Rect.fromLTWH(300, 100, 40, 20));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('content'), findsNothing);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('content'), findsOneWidget);
      await tester.tapAt(const Offset(700, 500));
      await tester.pumpAndSettle();
      expect(find.text('content'), findsNothing);
    });
  });
}
