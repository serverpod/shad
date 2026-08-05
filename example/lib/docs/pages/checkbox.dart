import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/checkbox/checkbox_basic.dart';
import 'package:example/docs/examples/checkbox/checkbox_disabled.dart';

final checkboxDoc = ComponentDoc(
  slug: 'checkbox',
  title: 'Checkbox',
  description:
      'A control that allows the user to toggle between checked and not '
      'checked.',
  playgroundRoute: '/checkbox',
  examples: [
    ComponentExample(
      id: 'checkbox_basic',
      title: 'With label',
      builder: (_) => const CheckboxBasicExample(),
    ),
    ComponentExample(
      id: 'checkbox_disabled',
      title: 'Disabled',
      builder: (_) => const CheckboxDisabledExample(),
    ),
  ],
);
