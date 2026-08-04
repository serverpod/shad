import 'package:flutter/widgets.dart';

enum ShadState {
  focused,
  hovered,
  pressed,
  disabled,
}

class ShadStatesController extends ValueNotifier<Set<ShadState>> {
  ShadStatesController([Set<ShadState>? value]) : super(<ShadState>{...?value});

  /// Adds [state] to [value] if [add] is true, and removes it otherwise,
  /// and notifies listeners if [value] has changed.
  void update(ShadState state, bool add) {
    // Emit a new Set rather than mutating in place. A ValueNotifier is
    // expected to replace its value; mutating it meant a listener that cached
    // the previous value saw that value change underneath it, so no listener
    // could tell which state had actually flipped.
    final next = <ShadState>{...value};
    final valueChanged = add ? next.add(state) : next.remove(state);
    if (valueChanged) {
      value = next;
    }
  }
}
