import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AvatarDefaultExample extends StatelessWidget {
  const AvatarDefaultExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ShadAvatar(
          'https://avatars.githubusercontent.com/u/124599?v=4',
          placeholder: Text('CN'),
        ),
        // The placeholder shows while loading, or if the image fails.
        ShadAvatar('', placeholder: Text('AB')),
      ],
    );
  }
}
