import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/progress.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(
      builder: (context, child) => ShadMaterial(child: child!),
      home: Scaffold(body: child),
    );
  }

  group('ShadProgress', () {
    testWidgets('ShadProgress indeterminate matches goldens', (tester) async {
      await tester.pumpWidget(createTestWidget(const ShadProgress()));

      await expectLater(
        find.byType(ShadProgress),
        matchesGoldenFile('goldens/progress_indeterminate.png'),
      );
    });

    testWidgets('ShadProgress determinate matches goldens', (tester) async {
      await tester.pumpWidget(createTestWidget(const ShadProgress(value: 0.5)));

      await expectLater(
        find.byType(ShadProgress),
        matchesGoldenFile('goldens/progress_determinate.png'),
      );
    });
  });
}
