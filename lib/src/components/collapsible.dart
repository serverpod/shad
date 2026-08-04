import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/theme.dart';
import 'package:shadcn_ui/src/utils/debug_check.dart';

/// Controls the open state of a [ShadCollapsible].
class ShadCollapsibleController extends ChangeNotifier {
  ShadCollapsibleController({bool open = false}) : _open = open;

  bool _open;

  /// Whether the collapsible's content is currently shown.
  bool get open => _open;

  set open(bool value) {
    if (_open == value) return;
    _open = value;
    notifyListeners();
  }

  void show() => open = true;

  void hide() => open = false;

  void toggle() => open = !_open;
}

/// Builds the trigger of a [ShadCollapsible].
///
/// [open] is the current state and [toggle] flips it.
typedef ShadCollapsibleTriggerBuilder =
    Widget Function(BuildContext context, bool open, VoidCallback toggle);

/// {@template ShadCollapsible}
/// An expandable/collapsible section.
///
/// Mirrors shadcn/ui's `Collapsible`: the primitive underneath an accordion,
/// for when you want a single independently-toggled region rather than a set
/// of them.
///
/// ```dart
/// ShadCollapsible(
///   trigger: (context, open, toggle) => ShadButton.ghost(
///     onPressed: toggle,
///     child: Text(open ? 'Hide' : 'Show'),
///   ),
///   child: const Text('Content'),
/// )
/// ```
///
/// For a group of sections where opening one closes the others, use
/// `ShadAccordion` instead.
/// {@endtemplate}
class ShadCollapsible extends StatefulWidget {
  /// {@macro ShadCollapsible}
  const ShadCollapsible({
    super.key,
    required this.child,
    this.trigger,
    this.controller,
    this.initiallyOpen = false,
    this.onOpenChange,
    this.duration,
    this.curve,
    this.reverseDuration,
    this.reverseCurve,
    this.crossAxisAlignment,
    this.maintainState = false,
  });

  /// The collapsible content.
  final Widget child;

  /// Builds the always-visible trigger.
  ///
  /// Receives the current open state and a callback that flips it, so a
  /// trigger placed here needs no [controller] of its own.
  ///
  /// Optional: leave it null and drive the collapsible from a [controller] when
  /// the trigger lives elsewhere in your layout.
  final ShadCollapsibleTriggerBuilder? trigger;

  /// An external controller for the open state.
  ///
  /// When null an internal one is created, seeded from [initiallyOpen].
  final ShadCollapsibleController? controller;

  /// Whether the collapsible starts open. Ignored when [controller] is set.
  final bool initiallyOpen;

  /// Called whenever the open state changes.
  final ValueChanged<bool>? onOpenChange;

  /// {@template ShadCollapsible.duration}
  /// The duration of the expand animation.
  /// {@endtemplate}
  final Duration? duration;

  /// {@template ShadCollapsible.curve}
  /// The curve of the expand animation.
  /// {@endtemplate}
  final Curve? curve;

  /// {@template ShadCollapsible.reverseDuration}
  /// The duration of the collapse animation, defaults to [duration].
  /// {@endtemplate}
  final Duration? reverseDuration;

  /// {@template ShadCollapsible.reverseCurve}
  /// The curve of the collapse animation, defaults to [curve].
  /// {@endtemplate}
  final Curve? reverseCurve;

  /// {@template ShadCollapsible.crossAxisAlignment}
  /// How the trigger and content are aligned horizontally.
  /// {@endtemplate}
  final CrossAxisAlignment? crossAxisAlignment;

  /// Whether the collapsed content stays in the tree.
  ///
  /// Defaults to `false`, which keeps state out of memory. Set to `true` when
  /// the content holds scroll position or form state worth preserving.
  final bool maintainState;

  @override
  State<ShadCollapsible> createState() => ShadCollapsibleState();
}

class ShadCollapsibleState extends State<ShadCollapsible>
    with SingleTickerProviderStateMixin {
  ShadCollapsibleController? _internalController;

  ShadCollapsibleController get controller =>
      widget.controller ?? _internalController!;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: controller.open ? 1 : 0,
  );

  late final Animation<double> _sizeFactor = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = ShadCollapsibleController(
        open: widget.initiallyOpen,
      );
    }
    controller.addListener(_onOpenChanged);
  }

  @override
  void didUpdateWidget(ShadCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _onOpenChanged,
      );
      controller.addListener(_onOpenChanged);
      _onOpenChanged();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onOpenChanged);
    _internalController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onOpenChanged() {
    if (controller.open) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onOpenChange?.call(controller.open);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final collapsibleTheme = theme.collapsibleTheme;

    _animationController
      ..duration =
          widget.duration ??
          collapsibleTheme.duration ??
          const Duration(milliseconds: 200)
      ..reverseDuration =
          widget.reverseDuration ?? collapsibleTheme.reverseDuration;

    final effectiveCrossAxisAlignment =
        widget.crossAxisAlignment ??
        collapsibleTheme.crossAxisAlignment ??
        CrossAxisAlignment.stretch;

    final open = controller.open;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: effectiveCrossAxisAlignment,
      children: [
        if (widget.trigger != null)
          Semantics(
            container: true,
            child: widget.trigger!(context, open, controller.toggle),
          ),
        ClipRect(
          child: AnimatedBuilder(
            animation: _sizeFactor,
            builder: (context, child) {
              // Skip building the content entirely while fully collapsed,
              // unless the caller asked to keep its state.
              if (_sizeFactor.value == 0 && !widget.maintainState) {
                return const SizedBox.shrink();
              }
              return Align(
                // Only the height factor animates; a default (center)
                // alignment would also centre the revealed content
                // horizontally whenever it is narrower than the collapsible.
                alignment: AlignmentDirectional.topStart,
                heightFactor: _sizeFactor.value.clamp(0.0, 1.0),
                child: child,
              );
            },
            child: ExcludeSemantics(
              excluding: !open,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
