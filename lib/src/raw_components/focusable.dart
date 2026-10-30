import 'package:flutter/widgets.dart';

/// Builds a widget from the focus state of a [ShadFocusable].
///
/// [focused] is true while the node has focus. [child] is the
/// [ShadFocusable.child], passed through so it does not rebuild.
typedef ShadFocusWidgetBuilder =
    Widget Function(
      BuildContext context,
      bool focused,
      Widget? child,
    );

/// A [Focus] widget that rebuilds its [builder] when the focus changes.
class ShadFocusable extends StatefulWidget {
  /// Creates a focusable widget.
  const ShadFocusable({
    super.key,
    required this.builder,
    this.focusNode,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.child,
    this.onFocusChange,
    this.onKeyEvent,
    this.skipTraversal,
    this.descendantsAreFocusable,
    this.descendantsAreTraversable,
    this.includeSemantics = true,
    this.debugLabel,
  });

  /// Whether the node can take focus. Defaults to true.
  final bool canRequestFocus;

  /// Whether to take focus when first built, if nothing else has focus.
  /// Defaults to false.
  final bool autofocus;

  /// The focus node to use. When null, the widget creates its own.
  final FocusNode? focusNode;

  /// Builds the content with the current focus state.
  final ShadFocusWidgetBuilder builder;

  /// A widget passed to [builder] that does not depend on the focus state.
  final Widget? child;

  /// Called with the new focus state each time it changes.
  final ValueChanged<bool>? onFocusChange;

  /// Handles key events while the node has focus. See [Focus.onKeyEvent].
  final FocusOnKeyEventCallback? onKeyEvent;

  /// Whether focus traversal skips the node. See [Focus.skipTraversal].
  final bool? skipTraversal;

  /// Whether the descendants can take focus. See
  /// [Focus.descendantsAreFocusable].
  final bool? descendantsAreFocusable;

  /// Whether focus traversal can reach the descendants. See
  /// [Focus.descendantsAreTraversable].
  final bool? descendantsAreTraversable;

  /// Whether the node adds focus semantics. Defaults to true.
  final bool includeSemantics;

  /// A label for the focus node in debug output.
  final String? debugLabel;

  @override
  State<ShadFocusable> createState() => _ShadFocusableState();
}

class _ShadFocusableState extends State<ShadFocusable> {
  FocusNode? _internal;

  final isFocused = ValueNotifier(false);

  FocusNode get focusNode => widget.focusNode ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internal = FocusNode();
    isFocused
      ..value = focusNode.hasFocus
      ..addListener(onFocusChange);
  }

  @override
  void dispose() {
    isFocused.removeListener(onFocusChange);
    _internal?.dispose();
    isFocused.dispose();
    super.dispose();
  }

  void onFocusChange() {
    widget.onFocusChange?.call(isFocused.value);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      onFocusChange: (value) => isFocused.value = value,
      focusNode: focusNode,
      onKeyEvent: widget.onKeyEvent,
      skipTraversal: widget.skipTraversal,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      includeSemantics: widget.includeSemantics,
      debugLabel: widget.debugLabel,
      child: ValueListenableBuilder(
        valueListenable: isFocused,
        builder: (context, value, child) =>
            widget.builder(context, value, child),
        child: widget.child,
      ),
    );
  }
}
