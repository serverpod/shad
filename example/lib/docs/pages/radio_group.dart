import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/radio_group/radio_group_basic.dart';

final radioGroupDoc = ComponentDoc(
  slug: 'radio_group',
  title: 'Radio Group',
  description:
      'A set of checkable buttons where only one can be checked at a time.',
  playgroundRoute: '/radio-group',
  examples: [
    ComponentExample(
      id: 'radio_group_basic',
      title: 'Default',
      builder: (_) => const RadioGroupBasicExample(),
    ),
  ],
);
