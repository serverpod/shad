import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class LayoutSpacingExample extends StatelessWidget {
  const LayoutSpacingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ShadRow/ShadColumn space their children in *steps* of the theme's
        // spacing scale: 2 steps is 8px with the default 4px step.
        ShadCard(
          child: ShadRow(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              for (final label in ['One', 'Two', 'Three'])
                ShadBadge.secondary(child: Text(label)),
            ],
          ),
        ),
        const ShadGap(4),
        ShadCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stacked'),
              const ShadGap(2),
              const Text('with a two-step gap'),
              const ShadGap(4),
              Text(
                'theme.spacing(4) is ${theme.spacing(4)}px',
                style: theme.textTheme.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
