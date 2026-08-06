import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/switch/switch_basic.dart';

final switchDoc = ComponentDoc(
  slug: 'switch',
  title: 'Switch',
  description:
      'A control that allows the user to toggle between checked and not '
      'checked.',
  examples: [
    ComponentExample(
      id: 'switch_basic',
      title: 'Default',
      builder: (_) => const SwitchBasicExample(),
    ),
  ],
);
