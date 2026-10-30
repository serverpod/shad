import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('tapping another menubar menu switches to it', (tester) async {
    await tester.pumpWidget(
      const ShadApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: ShadMenubar(
            items: [
              ShadMenubarItem(
                items: [ShadContextMenuItem(child: Text('New file'))],
                child: Text('File'),
              ),
              ShadMenubarItem(
                items: [ShadContextMenuItem(child: Text('Undo'))],
                child: Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    expect(find.text('New file'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('New file'), findsNothing);
  });
}
