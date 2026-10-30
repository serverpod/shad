import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('a disabled button still shows its tooltip on hover', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadApp(
        home: Center(
          child: ShadTooltip(
            builder: (_) => const Text('why it is disabled'),
            child: const ShadButton(
              enabled: false,
              child: Text('save'),
            ),
          ),
        ),
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('save')));
    await tester.pumpAndSettle();

    expect(find.text('why it is disabled'), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(find.text('why it is disabled'), findsNothing);
  });
}
