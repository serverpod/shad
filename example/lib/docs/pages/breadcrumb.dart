import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/breadcrumb/breadcrumb_basic.dart';
import 'package:example/docs/examples/breadcrumb/breadcrumb_ellipsis.dart';

final breadcrumbDoc = ComponentDoc(
  slug: 'breadcrumb',
  title: 'Breadcrumb',
  description:
      'Displays the path to the current resource using a hierarchy of links.',
  playgroundRoute: '/breadcrumb',
  examples: [
    ComponentExample(
      id: 'breadcrumb_basic',
      title: 'Default',
      builder: (_) => const BreadcrumbBasicExample(),
    ),
    ComponentExample(
      id: 'breadcrumb_ellipsis',
      title: 'Collapsed',
      description: 'An ellipsis stands in for the middle of a deep hierarchy.',
      builder: (_) => const BreadcrumbEllipsisExample(),
    ),
  ],
);
