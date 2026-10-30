import 'package:flutter/widgets.dart';
import 'package:shad/src/utils/provider.dart';

/// Holds a mouse cursor that a [ShadMouseCursorProvider] shows over its whole
/// subtree.
///
/// The resizable panels use it to keep the resize cursor while a divider is
/// dragged, even when the pointer leaves the divider.
class ShadMouseCursorController extends ChangeNotifier {
  /// Creates a controller with [cursor]. Defaults to [MouseCursor.defer], which
  /// lets the widgets below choose the cursor.
  ShadMouseCursorController({MouseCursor cursor = MouseCursor.defer})
    : _cursor = cursor;

  late MouseCursor _cursor;

  /// The cursor shown over the subtree. Setting it notifies listeners.
  MouseCursor get cursor => _cursor;

  set cursor(MouseCursor cursor) {
    if (cursor == _cursor) return;
    _cursor = cursor;
    notifyListeners();
  }
}

/// Shows the cursor of a [ShadMouseCursorController] over its child, and
/// provides the controller to descendants.
///
/// Descendants read the controller with
/// `context.read<ShadMouseCursorController>()`.
class ShadMouseCursorProvider extends StatefulWidget {
  /// Creates a provider. When [controller] is null, it creates its own.
  const ShadMouseCursorProvider({
    super.key,
    this.controller,
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The controller to provide. When null, the provider creates its own.
  final ShadMouseCursorController? controller;

  @override
  State<ShadMouseCursorProvider> createState() =>
      ShadMouseCursorProviderState();
}

/// The state of a [ShadMouseCursorProvider].
class ShadMouseCursorProviderState extends State<ShadMouseCursorProvider> {
  ShadMouseCursorController? _internalController;

  /// The controller in use: [ShadMouseCursorProvider.controller], or an
  /// internal one when that is null.
  ShadMouseCursorController get controller {
    if (widget.controller != null) return widget.controller!;
    return _internalController ??= ShadMouseCursorController();
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadProvider(
      data: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return MouseRegion(
            cursor: controller.cursor,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
