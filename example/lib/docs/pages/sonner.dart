import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/sonner/sonner_basic.dart';

final sonnerDoc = ComponentDoc(
  slug: 'sonner',
  title: 'Sonner',
  description:
      'An opinionated toast stack: notifications collect and expand '
      'on hover.',
  playgroundRoute: '/sonner',
  examples: [
    ComponentExample(
      id: 'sonner_basic',
      title: 'Default',
      builder: (_) => const SonnerBasicExample(),
    ),
  ],
);
