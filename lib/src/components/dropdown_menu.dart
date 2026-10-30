import 'package:flutter/widgets.dart';
import 'package:shad/src/components/context_menu.dart';
import 'package:shad/src/raw_components/portal.dart';

/// Builds a [ShadDropdownMenu]'s trigger. Call `controller.toggle` from the
/// trigger's `onPressed`.
typedef ShadDropdownMenuTriggerBuilder =
    Widget Function(
      BuildContext context,
      ShadContextMenuController controller,
      Widget? child,
    );

/// {@template ShadDropdownMenu}
/// shadcn/ui's DropdownMenu: a menu that opens from a trigger, below it and
/// aligned to its start edge.
///
/// The menu is a [ShadContextMenu], so it takes the same items
/// ([ShadContextMenuItem], separators, labels, submenus), scrolls when long,
/// supports keyboard navigation and type-ahead, and flips to stay on screen:
/// to the trigger's end edge near the side of the screen, above it near the
/// bottom.
///
/// ```dart
/// ShadDropdownMenu(
///   items: [
///     ShadContextMenuItem(child: Text('Profile'), onPressed: () {}),
///     ShadContextMenuItem(child: Text('Log out'), onPressed: () {}),
///   ],
///   builder: (context, controller, _) => ShadButton.outline(
///     onPressed: controller.toggle,
///     child: const Text('Open'),
///   ),
/// )
/// ```
/// {@endtemplate}
class ShadDropdownMenu extends StatefulWidget {
  /// {@macro ShadDropdownMenu}
  const ShadDropdownMenu({
    super.key,
    required this.builder,
    this.items = const [],
    this.itemsBuilder,
    this.child,
    this.controller,
    this.anchor,
    this.constraints,
    this.padding,
    this.onOpenChange,
  });

  /// Builds the trigger. See [ShadDropdownMenuTriggerBuilder].
  final ShadDropdownMenuTriggerBuilder builder;

  /// {@macro ShadContextMenu.items}
  final List<Widget> items;

  /// {@macro ShadContextMenu.itemsBuilder}
  final List<Widget> Function(BuildContext context)? itemsBuilder;

  /// Passed to [builder] unchanged, for a part of the trigger that does not
  /// depend on the controller.
  final Widget? child;

  /// Controls whether the menu is open. One is created when not given.
  final ShadContextMenuController? controller;

  /// Where the menu opens. Defaults to below the trigger at its start edge,
  /// falling back to its end edge and then to above it.
  final ShadAnchorBase? anchor;

  /// {@macro ShadContextMenu.constraints}
  final BoxConstraints? constraints;

  /// {@macro ShadContextMenu.padding}
  final EdgeInsetsGeometry? padding;

  /// Called when the menu opens or closes.
  final ValueChanged<bool>? onOpenChange;

  /// The default anchor: Radix's `side="bottom" align="start"` with
  /// `sideOffset={4}`, trying the other alignment and then the other side
  /// when the menu would leave the screen.
  static const defaultAnchor = ShadAnchorAuto(
    offset: Offset(0, 4),
    targetAnchor: AlignmentDirectional.bottomStart,
    followerAnchor: AlignmentDirectional.bottomEnd,
    fallback: ShadAnchorAuto(
      offset: Offset(0, 4),
      targetAnchor: AlignmentDirectional.bottomEnd,
      followerAnchor: AlignmentDirectional.bottomStart,
      fallback: ShadAnchorAuto(
        offset: Offset(0, -4),
        targetAnchor: AlignmentDirectional.topStart,
        followerAnchor: AlignmentDirectional.topEnd,
        fallback: ShadAnchorAuto(
          offset: Offset(0, -4),
          targetAnchor: AlignmentDirectional.topEnd,
          followerAnchor: AlignmentDirectional.topStart,
        ),
      ),
    ),
  );

  @override
  State<ShadDropdownMenu> createState() => _ShadDropdownMenuState();
}

class _ShadDropdownMenuState extends State<ShadDropdownMenu> {
  ShadContextMenuController? _ownController;
  ShadContextMenuController get _controller =>
      widget.controller ?? (_ownController ??= ShadContextMenuController());

  ShadContextMenuController? _listened;
  bool _wasOpen = false;

  void _listen() {
    final controller = _controller;
    if (identical(controller, _listened)) return;
    _listened?.removeListener(_onChanged);
    _listened = controller..addListener(_onChanged);
    _wasOpen = controller.isOpen;
  }

  void _onChanged() {
    final open = _controller.isOpen;
    if (open == _wasOpen) return;
    _wasOpen = open;
    widget.onOpenChange?.call(open);
  }

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(ShadDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _listen();
  }

  @override
  void dispose() {
    _listened?.removeListener(_onChanged);
    _ownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadContextMenu(
      controller: _controller,
      anchor: widget.anchor ?? ShadDropdownMenu.defaultAnchor,
      items: widget.items,
      itemsBuilder: widget.itemsBuilder,
      constraints: widget.constraints,
      padding: widget.padding,
      child: widget.builder(context, _controller, widget.child),
    );
  }
}
