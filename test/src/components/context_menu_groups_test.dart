import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// Every context menu used to share one tap-region group, so a tap on another
/// menu's trigger counted as "inside" and the open menu never closed.
void main() {
  Future<void> pumpMenus(
    WidgetTester tester,
    ShadContextMenuController a,
    ShadContextMenuController b,
  ) async {
    await tester.pumpWidget(
      ShadApp(
        home: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ShadContextMenu(
              controller: a,
              items: const [ShadContextMenuItem(child: Text('a item'))],
              child: const SizedBox(width: 80, height: 40, child: Text('A')),
            ),
            ShadContextMenu(
              controller: b,
              items: const [ShadContextMenuItem(child: Text('b item'))],
              child: const SizedBox(width: 80, height: 40, child: Text('B')),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets("a tap on another menu's trigger closes the open menu", (
    tester,
  ) async {
    final a = ShadContextMenuController();
    final b = ShadContextMenuController();
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    await pumpMenus(tester, a, b);

    a.show();
    await tester.pumpAndSettle();
    expect(find.text('a item'), findsOneWidget);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(a.isOpen, isFalse);
  });
}
