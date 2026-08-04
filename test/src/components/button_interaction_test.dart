import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  Widget wrap(Widget child) => ShadApp(home: Center(child: child));

  group('hover is retained across a click', () {
    testWidgets('a mouse click does not clear the hover state', (tester) async {
      // Regression: the default hoverStrategies list onTapUp under `unhover`.
      // Those exist to synthesise hover on touch devices, but they fired for
      // mouse clicks too, so the highlight vanished mid-click even though the
      // cursor had not moved.
      final changes = <bool>[];
      await tester.pumpWidget(
        wrap(
          ShadButton(
            onPressed: () {},
            onHoverChange: changes.add,
            child: const Text('Click me'),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(ShadButton)));
      await tester.pumpAndSettle();
      expect(changes, [true]);

      // Click without moving the pointer.
      await gesture.down(tester.getCenter(find.byType(ShadButton)));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        changes,
        [true],
        reason: 'the pointer never left, so hover must still be true',
      );

      await gesture.moveTo(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(changes, [true, false]);
    });

    testWidgets('touch still gets synthesised hover', (tester) async {
      // With no mouse, the strategies remain the only source of hover.
      final changes = <bool>[];
      await tester.pumpWidget(
        wrap(
          ShadButton(
            onPressed: () {},
            onHoverChange: changes.add,
            child: const Text('Tap me'),
          ),
        ),
      );

      await tester.tap(find.byType(ShadButton));
      await tester.pumpAndSettle();

      expect(changes, contains(true));
      expect(changes.last, isFalse);
    });
  });

  group('press effect', () {
    Offset slideOffset(WidgetTester tester) {
      final slide = tester.widget<AnimatedSlide>(
        find
            .descendant(
              of: find.byType(ShadButton),
              matching: find.byType(AnimatedSlide),
            )
            .first,
      );
      return slide.offset;
    }

    testWidgets('the button shifts down while pressed', (tester) async {
      // shadcn/ui applies `active:translate-y-px`.
      await tester.pumpWidget(
        wrap(ShadButton(onPressed: () {}, child: const Text('Press'))),
      );
      expect(slideOffset(tester), Offset.zero);

      final gesture = await tester.press(find.byType(ShadButton));
      await tester.pump();
      expect(slideOffset(tester).dy, greaterThan(0));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(slideOffset(tester), Offset.zero);
    });

    testWidgets('pressedOffset can be overridden', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShadButton(
            onPressed: () {},
            pressedOffset: Offset.zero,
            child: const Text('Press'),
          ),
        ),
      );

      final gesture = await tester.press(find.byType(ShadButton));
      await tester.pump();
      expect(slideOffset(tester), Offset.zero);
      await gesture.up();
    });

    testWidgets('a disabled button does not shift', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShadButton(
            enabled: false,
            onPressed: () {},
            child: const Text('Press'),
          ),
        ),
      );
      final gesture = await tester.press(find.byType(ShadButton));
      await tester.pump();
      expect(slideOffset(tester), Offset.zero);
      await gesture.up();
    });

    testWidgets('a button with no handler does not shift', (tester) async {
      // Note: Offset.toString() rounds to one decimal, so a missed shift of
      // 1/height reads as "Offset(0.0, 0.0)" in a failure message. Compare dy
      // numerically.
      await tester.pumpWidget(
        wrap(const ShadButton(child: Text('Press'))),
      );
      final gesture = await tester.press(find.byType(ShadButton));
      await tester.pump();
      expect(slideOffset(tester).dy, 0);
      await gesture.up();
    });
  });
}
