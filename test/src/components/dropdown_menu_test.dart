import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  Future<void> pump(WidgetTester tester, Alignment alignment) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ShadApp(
        home: Align(
          alignment: alignment,
          child: ShadDropdownMenu(
            items: const [
              ShadContextMenuItem(child: Text('Profile')),
              ShadContextMenuItem(child: Text('Log out')),
            ],
            builder: (context, controller, _) => ShadButton(
              onPressed: controller.toggle,
              child: const Text('Account'),
            ),
          ),
        ),
      ),
    );
  }

  Rect menu(WidgetTester tester) => tester.getRect(
    find
        .ancestor(
          of: find.text('Profile'),
          matching: find.byType(ShadDecorator),
        )
        .last,
  );

  testWidgets('opens below the trigger at its start edge, and toggles', (
    tester,
  ) async {
    await pump(tester, Alignment.topLeft);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    final trigger = tester.getRect(find.byType(ShadButton).first);
    final rect = menu(tester);
    expect(rect.left, moreOrLessEquals(trigger.left, epsilon: 1));
    expect(rect.top, moreOrLessEquals(trigger.bottom + 4, epsilon: 1));

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('flips to stay on screen in the bottom-right corner', (
    tester,
  ) async {
    await pump(tester, Alignment.bottomRight);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    final trigger = tester.getRect(find.byType(ShadButton).first);
    final rect = menu(tester);
    expect(rect.right, lessThanOrEqualTo(800));
    expect(rect.bottom, moreOrLessEquals(trigger.top - 4, epsilon: 1));
    expect(rect.right, moreOrLessEquals(trigger.right, epsilon: 1));
  });
}
