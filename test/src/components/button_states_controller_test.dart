import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets(
    'toggling enabled with a shared states controller does not notify '
    'listeners during build',
    (tester) async {
      final controller = ShadStatesController();
      addTearDown(controller.dispose);
      var enabled = true;
      late StateSetter setOuter;

      await tester.pumpWidget(
        ShadApp(
          home: Column(
            children: [
              // A listener on the same controller outside the subtree that
              // rebuilds, as a context menu item's trailing icon can be. A
              // notification from the button's didUpdateWidget marks it dirty
              // from outside its own build.
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, states, _) => Text(
                  states.contains(ShadState.disabled) ? 'off' : 'on',
                ),
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  setOuter = setState;
                  return ShadButton(
                    enabled: enabled,
                    statesController: controller,
                    onPressed: () {},
                    child: const Text('button'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      setOuter(() => enabled = false);
      await tester.pump();
      expect(tester.takeException(), isNull);
      // The listener catches up on the next frame.
      await tester.pump();
      expect(find.text('off'), findsOneWidget);

      setOuter(() => enabled = true);
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('on'), findsOneWidget);
    },
  );
}
