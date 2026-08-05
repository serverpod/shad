import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  Widget wrap(Widget child, {ShadSpacing spacing = const ShadSpacing()}) {
    return ShadTheme(
      data: ShadThemeData(spacing: spacing),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    );
  }

  group('ShadGap', () {
    testWidgets('sizes along the axis of the enclosing flex', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap(4)],
          ),
        ),
      );

      final size = tester.getSize(find.byType(ShadGap));
      expect(size.height, 16);
      expect(size.width, 0);
    });

    testWidgets('turns horizontal inside a Row', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap(4)],
          ),
        ),
      );

      final size = tester.getSize(find.byType(ShadGap));
      expect(size.width, 16);
      expect(size.height, 0);
    });

    testWidgets('follows the theme spacing step', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap(4)],
          ),
          spacing: const ShadSpacing(step: 2),
        ),
      );

      expect(tester.getSize(find.byType(ShadGap)).height, 8);
    });

    testWidgets('raw bypasses the scale', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap.raw(7)],
          ),
        ),
      );

      expect(tester.getSize(find.byType(ShadGap)).height, 7);
    });

    testWidgets('takes cross-axis space when asked', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [ShadGap(4, crossAxisSteps: 5)],
          ),
        ),
      );

      final size = tester.getSize(find.byType(ShadGap));
      expect(size.height, 16);
      expect(size.width, 20);
    });

    testWidgets('outside a flex it is square', (tester) async {
      await tester.pumpWidget(wrap(const ShadGap(4)));
      expect(tester.getSize(find.byType(ShadGap)), const Size(16, 16));
    });

    testWidgets('resizes when the step changes', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap(4)],
          ),
        ),
      );
      expect(tester.getSize(find.byType(ShadGap)).height, 16);

      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox.square(dimension: 10), ShadGap(4)],
          ),
          spacing: const ShadSpacing(step: 10),
        ),
      );
      expect(tester.getSize(find.byType(ShadGap)).height, 40);
    });
  });

  group('ShadPadding', () {
    testWidgets('all, symmetric and only are measured in steps', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadPadding.all(6, child: SizedBox.shrink()),
              ShadPadding.symmetric(
                horizontal: 4,
                vertical: 2,
                child: SizedBox.shrink(),
              ),
              ShadPadding.only(top: 3, child: SizedBox.shrink()),
            ],
          ),
        ),
      );

      final paddings = tester
          .widgetList<Padding>(find.byType(Padding))
          .map((p) => p.padding)
          .toList();

      expect(paddings, contains(const EdgeInsets.all(24)));
      expect(
        paddings,
        contains(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      );
      expect(paddings, contains(const EdgeInsets.only(top: 12)));
    });

    testWidgets('directional resolves against the text direction', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const ShadPadding.directional(
            start: 5,
            child: SizedBox.shrink(),
          ),
        ),
      );

      expect(
        tester.widgetList<Padding>(find.byType(Padding)).map((p) => p.padding),
        contains(const EdgeInsetsDirectional.only(start: 20)),
      );
    });
  });

  group('ShadColumn / ShadRow', () {
    testWidgets('spacing is expressed in steps', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ShadColumn(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              SizedBox.square(dimension: 10),
              SizedBox.square(dimension: 10),
            ],
          ),
        ),
      );

      // Two 10px children plus one 16px gap.
      expect(tester.getSize(find.byType(ShadColumn)).height, 36);
    });

    testWidgets('ShadRow spaces horizontally', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ShadRow(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              SizedBox.square(dimension: 10),
              SizedBox.square(dimension: 10),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(ShadRow)).width, 28);
    });
  });
}
