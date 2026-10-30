import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/toast.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(
      builder: (context, child) => ShadMaterial(child: child!),
      home: Scaffold(body: child),
    );
  }

  group('ShadToast', () {
    testWidgets('ShadToast matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadToast(
            title: Text('Title'),
            description: Text('Description'),
            action: Icon(Icons.create),
            closeIconData: Icons.close,
          ),
        ),
      );

      await expectLater(
        find.byType(ShadToast),
        matchesGoldenFile('goldens/toast.png'),
      );
    });
  });
}
