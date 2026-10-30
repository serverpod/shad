import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('tabs without content render only the list', (tester) async {
    String? changed;
    await tester.pumpWidget(
      ShadApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: ShadTabs<String>(
            value: 'day',
            onChanged: (v) => changed = v,
            tabs: const [
              ShadTab(value: 'day', child: Text('Day')),
              ShadTab(value: 'week', child: Text('Week')),
            ],
          ),
        ),
      ),
    );

    final tabs = tester.getRect(find.byType(ShadTabs<String>));
    final list = tester.getRect(
      find
          .descendant(
            of: find.byType(ShadTabs<String>),
            matching: find.byType(ShadDecorator),
          )
          .first,
    );
    // No gap and no panel area below the list.
    expect(tabs.height, list.height);

    await tester.tap(find.text('Week'));
    await tester.pump();
    expect(changed, 'week');
  });
}
