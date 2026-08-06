import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/toggle/toggle_basic.dart';
import 'package:example/docs/examples/toggle/toggle_outline.dart';

final toggleDoc = ComponentDoc(
  slug: 'toggle',
  title: 'Toggle',
  description: 'A two-state button that can be either on or off.',
  examples: [
    ComponentExample(
      id: 'toggle_basic',
      title: 'Default',
      builder: (_) => const ToggleBasicExample(),
    ),
    ComponentExample(
      id: 'toggle_outline',
      title: 'Outline',
      description: 'A bordered toggle with a subtle shadow.',
      builder: (_) => const ToggleOutlineExample(),
    ),
  ],
);
