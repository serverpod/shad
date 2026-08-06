import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/badge/badge_variants.dart';

final badgeDoc = ComponentDoc(
  slug: 'badge',
  title: 'Badge',
  description: 'Displays a badge or a component that looks like a badge.',
  examples: [
    ComponentExample(
      id: 'badge_variants',
      title: 'Variants',
      builder: (_) => const BadgeVariantsExample(),
    ),
  ],
);
