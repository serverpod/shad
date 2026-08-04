import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/src/app.dart';
import 'package:shadcn_ui/src/components/slider.dart';
import 'package:shadcn_ui/src/theme/theme.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('ShadSlider', () {
    testWidgets('ShadSlider matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ShadSlider(initialValue: 33, max: 100)),
      );

      expect(
        find.byType(ShadSlider),
        matchesGoldenFile('goldens/slider.png'),
      );
    });

    testWidgets('reserves room for the thumb, not just the track', (
      tester,
    ) async {
      // Regression: the thumb was Positioned with a negative offset, so the
      // slider laid out at track height (6px) while painting a 16px thumb.
      // Anything stacked above or below it was overlapped.
      await tester.pumpWidget(
        createTestWidget(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [ShadSlider(initialValue: 33, max: 100)],
          ),
        ),
      );

      final theme = ShadTheme.of(
        tester.element(find.byType(ShadSlider)),
      );
      final thumbDiameter = theme.sliderTheme.thumbRadius! * 2;

      expect(tester.getSize(find.byType(ShadSlider)).height, thumbDiameter);
      expect(thumbDiameter, greaterThan(theme.sliderTheme.trackHeight!));
    });

    testWidgets("the thumb rings on hover, in the theme's ring colour", (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          // Half-way, so the thumb sits under the slider's centre point.
          const Center(child: ShadSlider(initialValue: 50, max: 100)),
        ),
      );

      BoxDecoration thumbDecoration() {
        final containers = tester
            .widgetList<Container>(find.byType(Container))
            .where((c) => c.decoration is BoxDecoration)
            .map((c) => c.decoration! as BoxDecoration)
            .where((d) => d.shape == BoxShape.circle);
        return containers.first;
      }

      expect(thumbDecoration().boxShadow, isNull);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(ShadSlider)));
      await tester.pump();

      final theme = ShadTheme.of(tester.element(find.byType(ShadSlider)));
      final ring = theme.decoration.secondaryFocusedBorder!.top!;
      final shadow = thumbDecoration().boxShadow!.single;

      // Same colour, opacity and width as a focused field's ring.
      expect(shadow.color, ring.color);
      expect(shadow.spreadRadius, ring.width);
      expect(shadow.blurRadius, 0);
    });

    testWidgets('the ring stays up while dragging, even off the slider', (
      tester,
    ) async {
      // A drag routinely takes the pointer outside the slider; the ring has to
      // survive the whole gesture, not just the hover.
      await tester.pumpWidget(
        createTestWidget(
          const Center(child: ShadSlider(initialValue: 50, max: 100)),
        ),
      );

      BoxDecoration thumb() => tester
          .widgetList<Container>(find.byType(Container))
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.shape == BoxShape.circle);

      final centre = tester.getCenter(find.byType(ShadSlider));
      final gesture = await tester.startGesture(centre);
      await tester.pump();
      expect(thumb().boxShadow, isNotNull);

      // Well outside the slider's bounds.
      await gesture.moveBy(const Offset(0, 400));
      await tester.pump();
      expect(thumb().boxShadow, isNotNull);

      await gesture.up();
      await tester.pump();
      expect(thumb().boxShadow, isNull);
    });

    testWidgets('a fat track wins over a small thumb', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadSlider(
                initialValue: 33,
                max: 100,
                trackHeight: 40,
                thumbRadius: 6,
              ),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(ShadSlider)).height, 40);
    });
  });
}
