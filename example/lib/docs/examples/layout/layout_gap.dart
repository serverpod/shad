import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// `ShadGap` inserts space along the flex axis in spacing steps.
class LayoutGapExample extends StatelessWidget {
  const LayoutGapExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Account', style: theme.textTheme.h4),
            const ShadGap(1),
            Text(
              'Manage your profile and security settings.',
              style: theme.textTheme.muted,
            ),
            const ShadGap(4),
            ShadButton.outline(
              onPressed: () {},
              child: const Text('Open settings'),
            ),
          ],
        ),
      ),
    );
  }
}
