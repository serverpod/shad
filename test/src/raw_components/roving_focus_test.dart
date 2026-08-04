import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  group('ShadRovingFocusController', () {
    test('starts at the first item when moving forward from nothing', () {
      final c = ShadRovingFocusController(itemCount: 3);
      addTearDown(c.dispose);
      expect(c.highlightedIndex, isNull);
      c.move(1);
      expect(c.highlightedIndex, 0);
    });

    test('starts at the last item when moving backward from nothing', () {
      final c = ShadRovingFocusController(itemCount: 3);
      addTearDown(c.dispose);
      c.move(-1);
      expect(c.highlightedIndex, 2);
    });

    test('loops past both ends by default', () {
      final c = ShadRovingFocusController(itemCount: 3, highlightedIndex: 2);
      addTearDown(c.dispose);
      c.move(1);
      expect(c.highlightedIndex, 0);
      c.move(-1);
      expect(c.highlightedIndex, 2);
    });

    test('clamps at both ends when loop is false', () {
      final c = ShadRovingFocusController(
        itemCount: 3,
        highlightedIndex: 2,
        loop: false,
      );
      addTearDown(c.dispose);
      c.move(1);
      expect(c.highlightedIndex, 2);
      c
        ..highlightedIndex = 0
        ..move(-1);
      expect(c.highlightedIndex, 0);
    });

    test('Home and End jump to the ends', () {
      final c = ShadRovingFocusController(itemCount: 5, highlightedIndex: 2);
      addTearDown(c.dispose);
      c.moveToFirst();
      expect(c.highlightedIndex, 0);
      c.moveToLast();
      expect(c.highlightedIndex, 4);
    });

    test('shrinking the collection pulls the highlight back in range', () {
      final c = ShadRovingFocusController(itemCount: 5, highlightedIndex: 4);
      addTearDown(c.dispose);
      c.itemCount = 2;
      expect(c.highlightedIndex, 1);
      c.itemCount = 0;
      expect(c.highlightedIndex, isNull);
    });

    test('does nothing on an empty collection', () {
      final c = ShadRovingFocusController();
      addTearDown(c.dispose);
      c.move(1);
      expect(c.highlightedIndex, isNull);
    });
  });

  group('ShadRovingFocus', () {
    const labels = ['Apple', 'Banana', 'Cherry'];

    Future<ShadRovingFocusController> pump(
      WidgetTester tester, {
      ShadRovingFocusOrientation orientation =
          ShadRovingFocusOrientation.horizontal,
      TextDirection textDirection = TextDirection.ltr,
      ValueChanged<int>? onActivate,
      VoidCallback? onEscape,
      bool typeahead = false,
    }) async {
      final controller = ShadRovingFocusController(itemCount: labels.length);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        Directionality(
          textDirection: textDirection,
          child: ShadRovingFocus(
            controller: controller,
            orientation: orientation,
            autofocus: true,
            onActivate: onActivate,
            onEscape: onEscape,
            typeaheadLabelAt: typeahead ? (i) => labels[i] : null,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pump();
      return controller;
    }

    testWidgets('arrow right/left move the highlight when horizontal', (
      tester,
    ) async {
      final controller = await pump(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(controller.highlightedIndex, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(controller.highlightedIndex, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(controller.highlightedIndex, 0);
    });

    testWidgets('arrow up/down are ignored when horizontal', (tester) async {
      final controller = await pump(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(controller.highlightedIndex, isNull);
    });

    testWidgets('arrow up/down move the highlight when vertical', (
      tester,
    ) async {
      final controller = await pump(
        tester,
        orientation: ShadRovingFocusOrientation.vertical,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(controller.highlightedIndex, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      // Loops back around to the last item.
      expect(controller.highlightedIndex, 2);
    });

    testWidgets('left/right are mirrored in RTL', (tester) async {
      final controller = await pump(tester, textDirection: TextDirection.rtl);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(controller.highlightedIndex, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(controller.highlightedIndex, 1);
    });

    testWidgets('Home and End work in any orientation', (tester) async {
      final controller = await pump(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      expect(controller.highlightedIndex, 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      expect(controller.highlightedIndex, 0);
    });

    testWidgets('Enter activates the highlighted item', (tester) async {
      final activated = <int>[];
      final controller = await pump(tester, onActivate: activated.add);
      controller.highlightedIndex = 1;
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(activated, [1]);
    });

    testWidgets('Escape invokes onEscape', (tester) async {
      var escaped = false;
      await pump(tester, onEscape: () => escaped = true);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(escaped, isTrue);
    });

    testWidgets('typeahead jumps to the first match', (tester) async {
      final controller = await pump(tester, typeahead: true);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      expect(controller.highlightedIndex, 2); // Cherry
    });

    testWidgets('typeahead is off unless a label callback is given', (
      tester,
    ) async {
      final controller = await pump(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      expect(controller.highlightedIndex, isNull);
    });
  });
}
