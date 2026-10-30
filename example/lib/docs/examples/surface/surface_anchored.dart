import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// showShadPopover anchors a popover to a rectangle rather than a widget:
/// here, wherever the canvas was clicked.
class SurfaceAnchoredExample extends StatelessWidget {
  const SurfaceAnchoredExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return GestureDetector(
      onTapUp: (details) => showShadPopover<void>(
        context: context,
        anchorRect: Rect.fromCenter(
          center: details.globalPosition,
          width: 1,
          height: 1,
        ),
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text('Point', style: theme.textTheme.small),
            Text(
              '${details.localPosition.dx.round()}, '
              '${details.localPosition.dy.round()}',
              style: theme.textTheme.muted,
            ),
          ],
        ),
      ),
      child: Container(
        width: 320,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.muted,
          borderRadius: theme.radius,
        ),
        child: Text('Click anywhere', style: theme.textTheme.muted),
      ),
    );
  }
}
