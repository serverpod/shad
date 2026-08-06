import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/collapsible/collapsible_basic.dart';

final collapsibleDoc = ComponentDoc(
  slug: 'collapsible',
  title: 'Collapsible',
  description: 'An interactive component that expands and collapses a panel.',
  playgroundRoute: '/collapsible',
  examples: [
    ComponentExample(
      id: 'collapsible_basic',
      title: 'Default',
      builder: (_) => const CollapsibleBasicExample(),
    ),
  ],
);
