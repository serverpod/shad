# Portal

The raw overlay primitive underneath popover, select, tooltip, and menus: it renders a follower widget anchored to its child, above everything else.

`ShadPortal` is a building block rather than an end-user component. Reach for `ShadPopover`, `ShadTooltip`, or the menu components first. Use the portal directly only when you build a new floating surface.

## Anchoring modes

`ShadAnchorAuto` flips and shifts the follower to stay on screen, the same anchor mode every built-in floating component uses.

```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// Cycles `ShadAnchorAuto` follower anchors on a hover-triggered portal.
class PortalAnchoringExample extends StatefulWidget {
  const PortalAnchoringExample({super.key});

  @override
  State<PortalAnchoringExample> createState() => _PortalAnchoringExampleState();
}

class _PortalAnchoringExampleState extends State<PortalAnchoringExample> {
  var visible = false;
  late final Timer timer;
  var alignmentIndex = 0;

  static const _alignments = [
    AlignmentGeometry.topStart,
    AlignmentGeometry.topCenter,
    AlignmentGeometry.topEnd,
    AlignmentGeometry.centerStart,
    AlignmentGeometry.center,
    AlignmentGeometry.centerEnd,
    AlignmentGeometry.bottomStart,
    AlignmentGeometry.bottomCenter,
    AlignmentGeometry.bottomEnd,
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        alignmentIndex = (alignmentIndex + 1) % _alignments.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final alignment = _alignments[alignmentIndex];

    return Align(
      child: ShadPortal(
        anchor: ShadAnchorAuto(followerAnchor: alignment),
        visible: visible,
        portalBuilder: (context) {
          return ShadMouseArea(
            groupId: 'portal-demo',
            child: ColoredBox(
              color: theme.colorScheme.primary,
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Center(child: Text('200x200')),
              ),
            ),
          );
        },
        child: ShadMouseArea(
          groupId: 'portal-demo',
          onEnter: (_) => setState(() => visible = true),
          onExit: (_) => setState(() => visible = false),
          child: ColoredBox(
            color: theme.colorScheme.destructive,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: Text('100x100')),
            ),
          ),
        ),
      ),
    );
  }
}
```

The two `ShadMouseArea` widgets share a `groupId` so hovering the portal's own content counts as still hovering the trigger, which is what keeps a popover open while the pointer moves from the trigger onto the popover surface.
