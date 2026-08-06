import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/keyboard_toolbar/keyboard_toolbar_basic.dart';

final keyboardToolbarDoc = ComponentDoc(
  slug: 'keyboard_toolbar',
  title: 'Keyboard Toolbar',
  description:
      'A toolbar shown above the software keyboard on mobile, with focus '
      'navigation and a done button.',
  examples: [
    ComponentExample(
      id: 'keyboard_toolbar_basic',
      title: 'Default',
      description: 'Run on a mobile device to see the toolbar.',
      builder: (_) => const KeyboardToolbarBasicExample(),
    ),
  ],
);
