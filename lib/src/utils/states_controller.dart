import 'package:flutter/widgets.dart';

/// An interaction state of a widget.
enum ShadState {
  /// The widget has focus.
  focused,

  /// A pointer is over the widget.
  hovered,

  /// The widget is being pressed.
  pressed,

  /// The widget does not react to input.
  disabled,
}

/// Holds the set of [ShadState]s of a widget and notifies listeners when it
/// changes.
class ShadStatesController extends ValueNotifier<Set<ShadState>> {
  /// Creates a controller with the given states. Defaults to no states.
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
