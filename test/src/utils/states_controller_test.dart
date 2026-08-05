import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  group('ShadStatesController', () {
    test('emits a new Set instead of mutating in place', () {
      // Regression: update() mutated the Set held by the ValueNotifier and
      // then called notifyListeners, so a listener that captured the previous
      // value saw it change underneath and could not diff the two.
      final controller = ShadStatesController();
      addTearDown(controller.dispose);

      final before = controller.value;
      controller.update(ShadState.hovered, true);
      final after = controller.value;

      expect(identical(before, after), isFalse);
      expect(before, isEmpty, reason: 'the old Set must not be mutated');
      expect(after, contains(ShadState.hovered));
    });

    test('notifies only when the state actually changes', () {
      final controller = ShadStatesController();
      addTearDown(controller.dispose);

      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.update(ShadState.pressed, true);
      expect(notifications, 1);

      // Already pressed — nothing changed, so no notification.
      controller.update(ShadState.pressed, true);
      expect(notifications, 1);

      controller.update(ShadState.pressed, false);
      expect(notifications, 2);

      // Already not pressed.
      controller.update(ShadState.pressed, false);
      expect(notifications, 2);
    });

    test('seeds from the provided initial states', () {
      final controller = ShadStatesController({ShadState.disabled});
      addTearDown(controller.dispose);
      expect(controller.value, {ShadState.disabled});
    });
  });
}
