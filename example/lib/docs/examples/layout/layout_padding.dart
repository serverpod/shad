import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// `ShadPadding` mirrors Tailwind step-based inset utilities.
class LayoutPaddingExample extends StatelessWidget {
  const LayoutPaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final spacing = theme.spacing;

    return ColoredBox(
      color: theme.colorScheme.muted,
      child: ShadPadding.symmetric(
        horizontal: 6,
        vertical: 4,
        child: ShadCard(
          child: Text(
            'Inset by ${spacing(6)} x ${spacing(4)}',
            style: theme.textTheme.small,
          ),
        ),
      ),
    );
  }
}
