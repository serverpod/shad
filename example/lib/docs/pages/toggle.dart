import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/toggle/toggle_basic.dart';

final toggleDoc = ComponentDoc(
  slug: 'toggle',
  title: 'Toggle',
  description: 'A two-state button that can be either on or off.',
  playgroundRoute: '/toggle',
  examples: [
    ComponentExample(
      id: 'toggle_basic',
      title: 'Default',
      builder: (_) => const ToggleBasicExample(),
    ),
  ],
);
