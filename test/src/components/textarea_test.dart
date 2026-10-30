import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/textarea.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ShadApp(
      builder: (context, child) => ShadMaterial(child: child!),
      home: Scaffold(body: child),
    );
  }

  group('ShadTextarea', () {
    testWidgets('ShadTextarea matches golden', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadTextarea(
            placeholder: Text('Enter your message'),
          ),
        ),
      );

      await expectLater(
        find.byType(ShadTextarea),
        matchesGoldenFile('goldens/textarea.png'),
      );
    });
  });
}
