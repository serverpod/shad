import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/layout/layout_spacing.dart';

final layoutDoc = ComponentDoc(
  slug: 'layout',
  title: 'Layout',
  description:
      'Spacing-scale primitives: ShadRow, ShadColumn, ShadGap, and '
      'ShadPadding lay out in steps of the theme spacing.',
  playgroundRoute: '/layout',
  examples: [
    ComponentExample(
      id: 'layout_spacing',
      title: 'Spacing scale',
      builder: (_) => const LayoutSpacingExample(),
    ),
  ],
);
