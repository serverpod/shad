import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/slider.dart';
import 'package:shad/src/theme/theme.dart';

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

  group('ShadRangeSlider', () {
    /// The thumbs, in the order they are painted (lowest value first).
    Finder thumbs() => find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
    );

    /// The filled part of the track: the only box with the primary colour.
    Rect activeTrack(WidgetTester tester, Color color) {
      final finder = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            (widget.decoration as BoxDecoration).color == color,
      );
      return tester.getRect(finder);
    }

    testWidgets('renders one thumb per value, spanning the range between '
        'the outermost two', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(initialValues: [25, 75], max: 100),
            ),
          ),
        ),
      );

      expect(thumbs(), findsNWidgets(2));

      final theme = ShadTheme.of(tester.element(find.byType(ShadRangeSlider)));
      final slider = tester.getRect(find.byType(ShadRangeSlider));
      final track = activeTrack(tester, theme.colorScheme.primary);

      // The fill starts at the low thumb rather than at the track's start,
      // and stops at the high one: a quarter in, half the width.
      expect(track.left - slider.left, moreOrLessEquals(100, epsilon: 1));
      expect(track.width, moreOrLessEquals(200, epsilon: 1));
    });

    testWidgets('a single value still fills from the start, like ShadSlider', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(initialValues: [25], max: 100),
            ),
          ),
        ),
      );

      final theme = ShadTheme.of(tester.element(find.byType(ShadRangeSlider)));
      final slider = tester.getRect(find.byType(ShadRangeSlider));
      final track = activeTrack(tester, theme.colorScheme.primary);

      expect(track.left, moreOrLessEquals(slider.left, epsilon: 1));
      expect(track.width, moreOrLessEquals(100, epsilon: 1));
    });

    testWidgets('dragging a thumb moves only that thumb', (tester) async {
      List<double>? changed;
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(
                initialValues: const [25, 75],
                max: 100,
                onChanged: (values) => changed = values,
              ),
            ),
          ),
        ),
      );

      // Grab the high thumb and drag it left by a quarter of the track.
      await tester.drag(thumbs().last, const Offset(-100, 0));
      await tester.pump();

      expect(changed!.first, 25);
      expect(changed!.last, moreOrLessEquals(50, epsilon: 1));
    });

    testWidgets('a thumb stops at its neighbour instead of crossing it', (
      tester,
    ) async {
      List<double>? changed;
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(
                initialValues: const [25, 75],
                max: 100,
                onChanged: (values) => changed = values,
              ),
            ),
          ),
        ),
      );

      // Drag the high thumb well past the low one.
      await tester.drag(thumbs().last, const Offset(-300, 0));
      await tester.pump();

      // It parks on its neighbour, keeping the values ascending.
      expect(changed, [25, 25]);
    });

    testWidgets('tapping the track moves the nearest thumb', (tester) async {
      List<double>? changed;
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(
                initialValues: const [25, 75],
                max: 100,
                onChanged: (values) => changed = values,
              ),
            ),
          ),
        ),
      );

      final slider = tester.getRect(find.byType(ShadRangeSlider));
      // A tenth in: closer to the low thumb.
      await tester.tapAt(Offset(slider.left + 40, slider.center.dy));
      await tester.pump();

      expect(changed!.first, moreOrLessEquals(10, epsilon: 1));
      expect(changed!.last, 75);
    });

    testWidgets('each thumb takes the arrow keys on its own', (tester) async {
      List<double>? changed;
      await tester.pumpWidget(
        createTestWidget(
          Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(
                initialValues: const [25, 75],
                max: 100,
                divisions: 100,
                onChanged: (values) => changed = values,
              ),
            ),
          ),
        ),
      );

      // Tab lands on the lowest thumb, then on the next one up.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(changed, [26, 75]);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(changed, [26, 74]);
    });

    testWidgets(
      'the low thumb stays draggable when both are pulled to the max',
      (
        tester,
      ) async {
        // Regression: tied thumbs stacked in a fixed order, so once both were
        // dragged to the maximum the high thumb — pinned in place by its
        // equal-valued neighbour and unable to move at all — sat on top and
        // absorbed every pointer event, leaving no way to grab the low thumb
        // and pull the range back.
        List<double>? changed;
        await tester.pumpWidget(
          createTestWidget(
            Center(
              child: SizedBox(
                width: 400,
                child: ShadRangeSlider(
                  initialValues: const [100, 100],
                  max: 100,
                  onChanged: (values) => changed = values,
                ),
              ),
            ),
          ),
        );

        // Both thumbs occupy the same pixel position, right at the slider's
        // trailing edge. Start a hair inside it — the exact edge pixel is
        // outside the Stack's own hit-testable bounds regardless of which
        // thumb should win — and drag left; it must still reach the low
        // thumb.
        final thumbRect = tester.getRect(thumbs().last);
        await tester.dragFrom(
          thumbRect.center.translate(-2, 0),
          const Offset(-100, 0),
        );
        await tester.pump();

        expect(changed, isNotNull);
        expect(changed!.first, moreOrLessEquals(75, epsilon: 1));
        expect(changed!.last, 100);
      },
    );

    testWidgets('only the hovered thumb rings', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Center(
            child: SizedBox(
              width: 400,
              child: ShadRangeSlider(initialValues: [25, 75], max: 100),
            ),
          ),
        ),
      );

      List<BoxShadow?> shadows() => tester
          .widgetList<Container>(thumbs())
          .map((c) => (c.decoration! as BoxDecoration).boxShadow?.single)
          .toList();

      expect(shadows(), [null, null]);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(thumbs().last));
      await tester.pump();

      expect(shadows().first, isNull);
      expect(shadows().last, isNotNull);
    });
  });
}
