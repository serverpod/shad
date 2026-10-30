import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// The popover and menu surfaces, around any widget: for floating UI that
/// shad has no component for.
class SurfaceBasicExample extends StatelessWidget {
  const SurfaceBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        ShadSurface(
          child: SizedBox(
            width: 200,
            child: Text(
              'A popover surface: the outline, radius, padding and shadow '
              'of ShadPopover.',
              style: theme.textTheme.small,
            ),
          ),
        ),
        ShadSurface(
          kind: ShadSurfaceKind.menu,
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final label in ['Cut', 'Copy', 'Paste'])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(label, style: theme.textTheme.small),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
