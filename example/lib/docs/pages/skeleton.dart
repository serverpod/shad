import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/skeleton/skeleton_card.dart';

final skeletonDoc = ComponentDoc(
  slug: 'skeleton',
  title: 'Skeleton',
  description: 'A placeholder to show while content is loading.',
  examples: [
    ComponentExample(
      id: 'skeleton_card',
      title: 'Default',
      builder: (_) => const SkeletonCardExample(),
    ),
  ],
);
