import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/typography/typography_roles.dart';

final typographyDoc = ComponentDoc(
  slug: 'typography',
  title: 'Typography',
  description:
      'Every text style in the theme: the prose scale and the per-component '
      'styles derived from style roles.',
  examples: [
    ComponentExample(
      id: 'typography_roles',
      title: 'Styles',
      builder: (_) => const TypographyRolesExample(),
    ),
  ],
);
