import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipSidesExample extends StatelessWidget {
  const TooltipSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SideTooltip(label: 'Left', direction: AxisDirection.left),
        _SideTooltip(label: 'Top', direction: AxisDirection.up),
        _SideTooltip(label: 'Bottom', direction: AxisDirection.down),
        _SideTooltip(label: 'Right', direction: AxisDirection.right),
      ],
    );
  }
}

class _SideTooltip extends StatelessWidget {
  const _SideTooltip({required this.label, required this.direction});

  final String label;

  /// The side of the trigger the tooltip appears on.
  final AxisDirection direction;

  @override
  Widget build(BuildContext context) {
    final anchor = switch (direction) {
      AxisDirection.up => const ShadAnchor(
        childAlignment: Alignment.topCenter,
        overlayAlignment: Alignment.bottomCenter,
        offset: Offset(0, -4),
      ),
      AxisDirection.down => const ShadAnchor(
        childAlignment: Alignment.bottomCenter,
        overlayAlignment: Alignment.topCenter,
        offset: Offset(0, 4),
      ),
      AxisDirection.left => const ShadAnchor(
        childAlignment: Alignment.centerLeft,
        overlayAlignment: Alignment.centerRight,
        offset: Offset(-4, 0),
      ),
      AxisDirection.right => const ShadAnchor(
        childAlignment: Alignment.centerRight,
        overlayAlignment: Alignment.centerLeft,
        offset: Offset(4, 0),
      ),
    };

    return ShadTooltip(
      anchor: anchor,
      // The arrow points back at the trigger, opposite the placement side.
      arrowDirection: switch (direction) {
        AxisDirection.up => AxisDirection.down,
        AxisDirection.down => AxisDirection.up,
        AxisDirection.left => AxisDirection.right,
        AxisDirection.right => AxisDirection.left,
      },
      builder: (context) => const Text('Add to library'),
      child: ShadButton.outline(onPressed: () {}, child: Text(label)),
    );
  }
}
