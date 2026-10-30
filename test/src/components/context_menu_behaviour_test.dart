import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  Future<void> pumpMenu(
    WidgetTester tester, {
    required ShadContextMenuController controller,
    List<Widget> items = const [],
    List<Widget> Function(BuildContext)? itemsBuilder,
    Size size = const Size(800, 600),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ShadApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: ShadContextMenu(
            controller: controller,
            items: items,
            itemsBuilder: itemsBuilder,
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      ),
    );
  }

  Rect menuRect(WidgetTester tester, String firstItem) {
    // The outermost decorator above an item is the menu's own surface.
    final surface = find.ancestor(
      of: find.text(firstItem),
      matching: find.byType(ShadDecorator),
    );
    return tester.getRect(surface.last);
  }

  group('showAt', () {
    testWidgets('opens with its corner at the point', (tester) async {
      final controller = ShadContextMenuController();
      addTearDown(controller.dispose);
      await pumpMenu(
        tester,
        controller: controller,
        items: const [ShadContextMenuItem(child: Text('Copy'))],
      );

      controller.showAt(const Offset(200, 150));
      await tester.pumpAndSettle();
      final rect = menuRect(tester, 'Copy');
      expect(rect.topLeft.dx, moreOrLessEquals(200, epsilon: 1));
      expect(rect.topLeft.dy, moreOrLessEquals(150, epsilon: 1));
    });

    testWidgets('mirrors to stay on screen near the far corner', (
      tester,
    ) async {
      final controller = ShadContextMenuController();
      addTearDown(controller.dispose);
      await pumpMenu(
        tester,
        controller: controller,
        items: const [ShadContextMenuItem(child: Text('Copy'))],
      );

      controller.showAt(const Offset(795, 595));
      await tester.pumpAndSettle();
      final rect = menuRect(tester, 'Copy');
      expect(rect.right, lessThanOrEqualTo(800));
      expect(rect.bottom, lessThanOrEqualTo(600));
      // Mirrored, not merely clamped: the menu ends at the point.
      expect(rect.right, moreOrLessEquals(795, epsilon: 1));
      expect(rect.bottom, moreOrLessEquals(595, epsilon: 1));
    });
  });

  testWidgets('a long menu is capped to the screen and scrolls', (
    tester,
  ) async {
    final controller = ShadContextMenuController();
    addTearDown(controller.dispose);
    await pumpMenu(
      tester,
      controller: controller,
      size: const Size(400, 300),
      items: [
        for (var i = 0; i < 40; i++)
          ShadContextMenuItem(child: Text('Item $i')),
      ],
    );
    controller.showAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(menuRect(tester, 'Item 0').height, lessThanOrEqualTo(300));
    expect(
      find.ancestor(
        of: find.text('Item 0'),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
  });

  testWidgets('itemsBuilder runs only while the menu is open', (
    tester,
  ) async {
    final controller = ShadContextMenuController();
    addTearDown(controller.dispose);
    var builds = 0;
    await pumpMenu(
      tester,
      controller: controller,
      itemsBuilder: (_) {
        builds++;
        return const [ShadContextMenuItem(child: Text('Lazy'))];
      },
    );
    expect(builds, 0);

    controller.show();
    await tester.pumpAndSettle();
    expect(builds, greaterThan(0));
    expect(find.text('Lazy'), findsOneWidget);
  });

  group('keyboard', () {
    Future<ShadContextMenuController> openMenu(WidgetTester tester) async {
      final controller = ShadContextMenuController();
      addTearDown(controller.dispose);
      await pumpMenu(
        tester,
        controller: controller,
        items: const [
          // A leading icon renders a glyph as text; type-ahead must skip it.
          ShadContextMenuItem(
            leading: Icon(IconData(0x41)),
            child: Text('Back'),
          ),
          ShadContextMenuItem(child: Text('Copy')),
          ShadContextMenuItem(child: Text('Cut')),
          ShadContextMenuItem(child: Text('Paste')),
        ],
      );
      controller.show();
      // Past the entrance animation, which ignores pointers and keys.
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      return controller;
    }

    String? focusedLabel(WidgetTester tester) {
      final focus = FocusManager.instance.primaryFocus?.context;
      if (focus == null) return null;
      for (final label in ['Back', 'Copy', 'Cut', 'Paste']) {
        if (find
            .descendant(
              of: find.byElementPredicate((e) => e == focus),
              matching: find.text(label),
            )
            .evaluate()
            .isNotEmpty) {
          return label;
        }
      }
      return null;
    }

    testWidgets('type-ahead jumps to the matching item', (tester) async {
      await openMenu(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
      await tester.pump();
      expect(focusedLabel(tester), 'Paste');
    });

    testWidgets('type-ahead matches the label, not a leading icon', (
      tester,
    ) async {
      await openMenu(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.pump();
      expect(focusedLabel(tester), 'Back');
    });

    testWidgets('repeating a letter cycles through its items', (tester) async {
      await openMenu(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      await tester.pump();
      expect(focusedLabel(tester), 'Copy');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      await tester.pump();
      expect(focusedLabel(tester), 'Cut');
    });

    testWidgets('Home and End jump to the ends', (tester) async {
      await openMenu(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(focusedLabel(tester), 'Paste');
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(focusedLabel(tester), 'Back');
    });

    testWidgets('ArrowDown from the opened menu enters the list', (
      tester,
    ) async {
      await openMenu(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusedLabel(tester), 'Back');
    });
  });

  testWidgets('a submenu near the right edge opens on the left', (
    tester,
  ) async {
    final controller = ShadContextMenuController();
    addTearDown(controller.dispose);
    await pumpMenu(
      tester,
      controller: controller,
      items: const [
        ShadContextMenuItem(
          items: [ShadContextMenuItem(child: Text('Nested'))],
          child: Text('More'),
        ),
      ],
    );
    controller.showAt(const Offset(780, 100));
    await tester.pumpAndSettle();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('More')));
    await tester.pumpAndSettle();

    // A submenu's overlay is a logical descendant of its parent menu, so
    // each menu is measured by its own (nearest) scroll view.
    Rect listOf(String item) => tester.getRect(
      find
          .ancestor(
            of: find.text(item),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
    );
    final parent = listOf('More');
    final submenu = listOf('Nested');
    expect(submenu.right, lessThanOrEqualTo(800));
    // Beside the parent on its left, not slid over it.
    expect(submenu.right, lessThanOrEqualTo(parent.left + 9));
  });
}
