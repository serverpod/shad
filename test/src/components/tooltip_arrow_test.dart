import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/shad.dart';

/// The arrow points at the trigger, not at the middle of the bubble.
///
/// A tooltip whose bubble would overflow the viewport is slid back inside by
/// the portal's position delegate. Keeping the arrow centred on the bubble
/// then aims it at empty space beside the trigger, which is what this locks
/// down.
void main() {
  const arrow = ValueKey('shad_tooltip_arrow');
  const viewport = Size(400, 400);

  /// Pumps a tooltip whose trigger sits at [triggerAlignment], already open.
  Future<void> pumpTooltip(
    WidgetTester tester,
    Alignment triggerAlignment, {
    double contentWidth = 240,
    double triggerInset = 0,
  }) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final controller = ShadTooltipController(isOpen: true);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ShadApp(
        builder: (context, child) => ShadMaterial(child: child!),
        home: Scaffold(
          body: Align(
            alignment: triggerAlignment,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: triggerInset),
              child: ShadTooltip(
                controller: controller,
                builder: (context) => SizedBox(width: contentWidth, height: 20),
                child: const SizedBox(
                  key: ValueKey('trigger'),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // The portal measures the overlay, then repositions on the next frame, and
    // the arrow reads the resulting shift on a third. The entrance animation
    // has to finish too — it scales the bubble about its own centre, which
    // drags a shifted arrow back toward the middle until it settles.
    for (var i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Rect bubbleRect(WidgetTester tester) =>
      tester.getRect(find.byType(ShadDecorator).last);

  testWidgets('the arrow stays over a trigger the bubble was pushed off', (
    tester,
  ) async {
    // A 264px bubble centred on a trigger whose centre is 52px from the right
    // edge runs 80px off screen, so the delegate slides it back in — far
    // enough to be obvious, near enough that the arrow can still reach.
    await pumpTooltip(tester, Alignment.centerRight, triggerInset: 40);

    final trigger = tester.getCenter(find.byKey(const ValueKey('trigger'))).dx;
    final bubble = bubbleRect(tester);
    expect(
      bubble.center.dx,
      lessThan(trigger - 20),
      reason: 'the bubble should have been pushed well off the trigger',
    );

    expect(tester.getCenter(find.byKey(arrow)).dx, closeTo(trigger, 1));
  });

  testWidgets('the arrow stays centred when nothing had to move', (
    tester,
  ) async {
    await pumpTooltip(tester, Alignment.center);

    final bubble = bubbleRect(tester);
    final arrowCentre = tester.getCenter(find.byKey(arrow)).dx;
    expect(arrowCentre, closeTo(bubble.center.dx, 1));
  });

  testWidgets('the arrow stops short of the bubble corner', (tester) async {
    // The trigger is hard against the edge and the bubble nearly fills the
    // viewport, so pointing straight at the trigger would put the arrow in the
    // rounded corner. It has to stop before that.
    await pumpTooltip(tester, Alignment.centerRight, contentWidth: 380);

    final bubble = bubbleRect(tester);
    final theme = ShadTheme.of(tester.element(find.byType(ShadTooltip)));
    final cornerRadius = theme.tooltipTheme.decoration!.border!.radius!
        .resolve(TextDirection.ltr)
        .topRight
        .x;
    final arrowSize = theme.tooltipTheme.arrowSize!;
    final keepClear = cornerRadius + arrowSize * 1.4142135623730951 / 2;

    final arrowCentre = tester.getCenter(find.byKey(arrow)).dx;
    expect(arrowCentre, lessThanOrEqualTo(bubble.right - keepClear + 0.5));
    expect(arrowCentre, greaterThan(bubble.center.dx));
  });
}
