import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/textarea/textarea_basic.dart';

final textareaDoc = ComponentDoc(
  slug: 'textarea',
  title: 'Textarea',
  description: 'A multi-line text input, optionally user-resizable.',
  playgroundRoute: '/textarea',
  examples: [
    ComponentExample(
      id: 'textarea_basic',
      title: 'Default',
      builder: (_) => const TextareaBasicExample(),
    ),
  ],
);
