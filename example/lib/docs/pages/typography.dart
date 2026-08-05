import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/typography/typography_roles.dart';

final typographyDoc = ComponentDoc(
  slug: 'typography',
  title: 'Typography',
  description:
      'The text styles of the theme: headings, body, lead, large, small and '
      'muted.',
  playgroundRoute: '/typography',
  examples: [
    ComponentExample(
      id: 'typography_roles',
      title: 'Styles',
      builder: (_) => const TypographyRolesExample(),
    ),
  ],
);
