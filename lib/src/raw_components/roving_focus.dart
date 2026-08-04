import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The axis along which a [ShadRovingFocus] group moves its highlight.
enum ShadRovingFocusOrientation {
  /// Left/Right move the highlight; Up/Down are left to the framework.
  horizontal,

  /// Up/Down move the highlight; Left/Right are left to the framework.
  vertical,

  /// All four arrow keys move the highlight.
  both,
}

/// A controller for a roving-highlight collection such as a tab bar, menu,
/// toggle group or command palette.
///
/// "Roving" is the WAI-ARIA pattern the shadcn/ui components inherit from
/// Radix: the collection is a single tab stop, and the arrow keys move an
/// internal highlight between items rather than moving focus item by item.
class ShadRovingFocusController extends ChangeNotifier {
  ShadRovingFocusController({
    int itemCount = 0,
    int? highlightedIndex,
    this.loop = true,
  }) : _itemCount = itemCount,
       _highlightedIndex = highlightedIndex;

  /// Whether moving past either end wraps around to the other.
  final bool loop;

  int _itemCount;

  /// The number of items currently in the collection.
  int get itemCount => _itemCount;

  set itemCount(int value) {
    if (_itemCount == value) return;
    _itemCount = value;
    if (_highlightedIndex != null && _highlightedIndex! >= value) {
      _highlightedIndex = value == 0 ? null : value - 1;
    }
    notifyListeners();
  }

  int? _highlightedIndex;

  /// The currently highlighted item, or null when nothing is highlighted.
  int? get highlightedIndex => _highlightedIndex;

  set highlightedIndex(int? value) {
    final clamped = (value == null || _itemCount == 0)
        ? null
        : value.clamp(0, _itemCount - 1);
    if (_highlightedIndex == clamped) return;
    _highlightedIndex = clamped;
    notifyListeners();
  }

  /// Moves the highlight by [delta], honouring [loop].
  ///
  /// With nothing highlighted, moving forward starts at the first item and
  /// moving backward starts at the last, which is what a user pressing Down
  /// (or Up) on a freshly focused collection expects.
  void move(int delta) {
    if (_itemCount == 0) return;
    final current = _highlightedIndex;
    if (current == null) {
      highlightedIndex = delta > 0 ? 0 : _itemCount - 1;
      return;
    }
    final next = current + delta;
    if (next < 0) {
      highlightedIndex = loop ? _itemCount - 1 : 0;
    } else if (next >= _itemCount) {
      highlightedIndex = loop ? 0 : _itemCount - 1;
    } else {
      highlightedIndex = next;
    }
  }

  void moveToFirst() {
    if (_itemCount == 0) return;
    highlightedIndex = 0;
  }

  void moveToLast() {
    if (_itemCount == 0) return;
    highlightedIndex = _itemCount - 1;
  }
}

/// Wraps a collection of items with arrow-key, Home/End and typeahead
/// navigation over a [ShadRovingFocusController].
///
/// This is the shared keyboard substrate for the components that Radix
/// guarantees arrow navigation on — tabs, menus, menubars, selects, toggle
/// groups and the command palette — none of which handled arrow keys before.
///
/// The widget only interprets keys and updates the controller; painting the
/// highlight and reacting to activation is up to the caller, which reads
/// [ShadRovingFocusController.highlightedIndex].
class ShadRovingFocus extends StatefulWidget {
  const ShadRovingFocus({
    super.key,
    required this.controller,
    required this.child,
    this.orientation = ShadRovingFocusOrientation.horizontal,
    this.onActivate,
    this.onEscape,
    this.textDirection,
    this.typeaheadLabelAt,
    this.typeaheadResetDelay = const Duration(milliseconds: 1000),
    this.autofocus = false,
    this.focusNode,
  });

  /// The controller holding the highlighted index.
  final ShadRovingFocusController controller;

  final Widget child;

  /// Which arrow keys move the highlight.
  final ShadRovingFocusOrientation orientation;

  /// Called with the highlighted index when Enter or Space is pressed.
  final ValueChanged<int>? onActivate;

  /// Called when Escape is pressed.
  final VoidCallback? onEscape;

  /// Used to flip Left/Right in RTL. Defaults to the ambient direction.
  final TextDirection? textDirection;

  /// Supplies the label used for type-to-select.
  ///
  /// Return null for items that should not be matched. When this is null,
  /// typeahead is disabled.
  final String? Function(int index)? typeaheadLabelAt;

  /// How long typed characters accumulate before the buffer resets.
  final Duration typeaheadResetDelay;

  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<ShadRovingFocus> createState() => _ShadRovingFocusState();
}

class _ShadRovingFocusState extends State<ShadRovingFocus> {
  String _typeahead = '';
  DateTime? _lastKeystroke;

  bool get _handlesHorizontal =>
      widget.orientation != ShadRovingFocusOrientation.vertical;

  bool get _handlesVertical =>
      widget.orientation != ShadRovingFocusOrientation.horizontal;

  TextDirection get _textDirection =>
      widget.textDirection ?? Directionality.of(context);

  /// Advances the type-to-select buffer and returns the matching index.
  ///
  /// Repeating a single character cycles through the items starting with it,
  /// which is the behaviour of a native listbox.
  int? _matchTypeahead(String character, DateTime now) {
    final labelAt = widget.typeaheadLabelAt;
    if (labelAt == null) return null;

    final expired =
        _lastKeystroke == null ||
        now.difference(_lastKeystroke!) > widget.typeaheadResetDelay;
    _lastKeystroke = now;
    _typeahead = expired ? character : _typeahead + character;

    final repeatedSingleChar =
        _typeahead.length > 1 &&
        _typeahead.split('').every((c) => c == _typeahead[0]);
    final query = (repeatedSingleChar ? _typeahead[0] : _typeahead)
        .toLowerCase();

    final count = widget.controller.itemCount;
    if (count == 0) return null;

    // Start the scan just after the current item so repeats advance.
    final current = widget.controller.highlightedIndex ?? -1;
    final start = repeatedSingleChar || _typeahead.length == 1
        ? current + 1
        : current;

    for (var offset = 0; offset < count; offset++) {
      final index = (start + offset) % count;
      final label = labelAt(index)?.toLowerCase();
      if (label != null && label.startsWith(query)) return index;
    }
    return null;
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final controller = widget.controller;
    final key = event.logicalKey;
    final rtl = _textDirection == TextDirection.rtl;

    if (_handlesHorizontal && key == LogicalKeyboardKey.arrowLeft) {
      controller.move(rtl ? 1 : -1);
      return KeyEventResult.handled;
    }
    if (_handlesHorizontal && key == LogicalKeyboardKey.arrowRight) {
      controller.move(rtl ? -1 : 1);
      return KeyEventResult.handled;
    }
    if (_handlesVertical && key == LogicalKeyboardKey.arrowUp) {
      controller.move(-1);
      return KeyEventResult.handled;
    }
    if (_handlesVertical && key == LogicalKeyboardKey.arrowDown) {
      controller.move(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      controller.moveToFirst();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      controller.moveToLast();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (widget.onEscape == null) return KeyEventResult.ignored;
      widget.onEscape!();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      final index = controller.highlightedIndex;
      if (index == null || widget.onActivate == null) {
        return KeyEventResult.ignored;
      }
      widget.onActivate!(index);
      return KeyEventResult.handled;
    }

    // Typeahead. Only single printable characters take part; anything with a
    // control modifier is left alone so shortcuts keep working.
    final character = event.character;
    if (widget.typeaheadLabelAt != null &&
        character != null &&
        character.length == 1 &&
        character.trim().isNotEmpty &&
        !HardwareKeyboard.instance.isControlPressed &&
        !HardwareKeyboard.instance.isMetaPressed &&
        !HardwareKeyboard.instance.isAltPressed) {
      final match = _matchTypeahead(character, DateTime.now());
      if (match != null) {
        controller.highlightedIndex = match;
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _onKeyEvent,
      child: widget.child,
    );
  }
}
