import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/empty/empty_basic.dart';

final emptyDoc = ComponentDoc(
  slug: 'empty',
  title: 'Empty',
  description:
      'A placeholder for an empty state: icon, title, description and '
      'actions.',
  playgroundRoute: '/empty',
  examples: [
    ComponentExample(
      id: 'empty_basic',
      title: 'Default',
      builder: (_) => const EmptyBasicExample(),
    ),
  ],
);
