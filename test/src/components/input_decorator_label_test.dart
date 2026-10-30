import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('a label with no label style and no fallback does not throw', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadApp(
        home: ShadInputDecorator(
          label: Text('Name'),
          decoration: ShadDecoration(fallbackToLabelStyle: false),
          child: SizedBox(height: 10),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Name'), findsOneWidget);
  });
}
