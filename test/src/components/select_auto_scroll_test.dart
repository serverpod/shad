import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/shad.dart';

/// The chevron auto-scroll loops drive a single [ScrollController]. A second
/// `animateTo` on a scroll position disposes the first one's activity, and
/// that completes its future synchronously — so two concurrent loops cancel
/// each other as microtasks with the offset never moving. Dart drains the
/// whole microtask queue before returning to the embedder, which freezes the
/// app: no frames, no input, no resize. Only one loop may ever run.
void main() {
  Widget wrap(Widget child) => ShadApp(
    builder: (context, child) => ShadMaterial(child: child!),
    home: Scaffold(body: child),
  );

  Widget select(GlobalKey<ShadSelectState<String>> key) => ShadSelect<String>(
    key: key,
    placeholder: const Text('Pick one'),
    maxHeight: 120,
    selectedOptionBuilder: (context, value) => Text(value),
    options: List.generate(
      60,
      (i) => ShadOption<String>(value: 'item $i', child: Text('item $i')),
    ),
  );

  group('ShadSelect chevron auto-scroll', () {
    testWidgets('a second start does not spawn a second loop', (tester) async {
      final key = GlobalKey<ShadSelectState<String>>();
      await tester.pumpWidget(wrap(select(key)));

      final state = key.currentState!;
      expect(state.isAutoScrolling, isFalse);

      state.startAutoScroll(toTop: false);
      expect(state.isAutoScrolling, isTrue);

      // Hovering off and back on within the opening delay used to queue a
      // second loop, and the two then starved the event loop forever.
      state
        ..stopAutoScroll()
        ..startAutoScroll(toTop: false);
      expect(state.isAutoScrolling, isTrue);

      state.stopAutoScroll();
      // Past the 200ms opening delay, so the retired loop can observe its
      // stale token and release the guard.
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump();
      expect(state.isAutoScrolling, isFalse);
    });

    testWidgets('the loop releases its guard when the list is opened', (
      tester,
    ) async {
      final key = GlobalKey<ShadSelectState<String>>();
      await tester.pumpWidget(wrap(select(key)));

      await tester.tap(find.text('Pick one'));
      // Popover contents sit under an IgnorePointer during the entrance
      // animation, so pump it out rather than settling (the option list
      // never settles once a loop is running).
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final state = key.currentState!;
      final controller = state.scrollController;
      expect(controller.hasClients, isTrue);
      expect(controller.offset, 0);

      state.startAutoScroll(toTop: false);
      // Opening delay, then a few animation steps.
      await tester.pump(const Duration(milliseconds: 250));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(
        controller.offset,
        greaterThan(0),
        reason: 'the loop should still scroll the option list',
      );

      state.stopAutoScroll();
      // Let the in-flight step and its event-loop yield drain.
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 30));
      }
      expect(state.isAutoScrolling, isFalse);
    });
  });
}
