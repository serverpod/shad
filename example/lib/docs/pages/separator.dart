import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/separator/separator_basic.dart';

final separatorDoc = ComponentDoc(
  slug: 'separator',
  title: 'Separator',
  description: 'Visually or semantically separates content.',
  playgroundRoute: '/divider',
  examples: [
    ComponentExample(
      id: 'separator_basic',
      title: 'Default',
      builder: (_) => const SeparatorBasicExample(),
    ),
  ],
);
