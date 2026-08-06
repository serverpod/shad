import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/avatar/avatar_default.dart';

final avatarDoc = ComponentDoc(
  slug: 'avatar',
  title: 'Avatar',
  description: 'An image element with a fallback for representing the user.',
  examples: [
    ComponentExample(
      id: 'avatar_default',
      title: 'Default',
      description:
          'The placeholder shows while the image loads, or when it fails.',
      builder: (_) => const AvatarDefaultExample(),
    ),
  ],
);
