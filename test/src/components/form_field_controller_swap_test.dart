import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets('a form field follows a swapped-in controller', (tester) async {
    final external = TextEditingController(text: 'a');
    addTearDown(external.dispose);
    String? seen;
    Widget build(TextEditingController? controller) => ShadApp(
      home: ShadInputFormField(
        controller: controller,
        onChanged: (v) => seen = v,
      ),
    );

    await tester.pumpWidget(build(null));
    await tester.pumpWidget(build(external));
    external.text = 'typed';
    await tester.pump();
    expect(seen, 'typed');

    // Back to an internal controller, then gone: no listener left behind on
    // the external one, and nothing disposed twice.
    await tester.pumpWidget(build(null));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
    seen = null;
    external.text = 'later';
    expect(seen, isNull);
  });
}
