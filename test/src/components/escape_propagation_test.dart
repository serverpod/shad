import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// A closed tooltip, popover or select must not swallow Escape: it has to
/// reach the dialog around it. An open one closes itself and stops there.
void main() {
  Future<void> openDialog(WidgetTester tester, Widget content) async {
    await tester.pumpWidget(
      ShadApp(
        home: Builder(
          builder: (context) => Center(
            child: ShadButton(
              onPressed: () => showShadDialog<void>(
                context: context,
                builder: (context) => ShadDialog(
                  title: const Text('Dialog'),
                  child: content,
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
    expect(find.text('Dialog'), findsOneWidget);
  }

  Future<void> pressEscape(WidgetTester tester) async {
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
  }

  testWidgets('Escape on a closed tooltip trigger closes the dialog', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await openDialog(
      tester,
      ShadTooltip(
        builder: (_) => const Text('tip'),
        child: ShadButton(
          focusNode: focusNode,
          onPressed: () {},
          child: const Text('trigger'),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();

    await pressEscape(tester);
    expect(find.text('Dialog'), findsNothing);
  });

  testWidgets('Escape closes an open popover first, then the dialog', (
    tester,
  ) async {
    final controller = ShadPopoverController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    await openDialog(
      tester,
      ShadPopover(
        controller: controller,
        popover: (_) => const Text('content'),
        child: ShadButton(
          focusNode: focusNode,
          onPressed: controller.toggle,
          child: const Text('trigger'),
        ),
      ),
    );
    focusNode.requestFocus();
    controller.show();
    await tester.pumpAndSettle();
    expect(controller.isOpen, isTrue);

    await pressEscape(tester);
    expect(controller.isOpen, isFalse);
    expect(find.text('Dialog'), findsOneWidget);

    focusNode.requestFocus();
    await tester.pump();
    await pressEscape(tester);
    expect(find.text('Dialog'), findsNothing);
  });
}
