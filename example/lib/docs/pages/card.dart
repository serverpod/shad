import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/card/card_project.dart';

final cardDoc = ComponentDoc(
  slug: 'card',
  title: 'Card',
  description: 'Displays a card with title, description, content and footer.',
  playgroundRoute: '/card',
  examples: [
    ComponentExample(
      id: 'card_project',
      title: 'With a form',
      builder: (_) => const CardProjectExample(),
    ),
  ],
);
