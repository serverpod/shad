import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/toggle_group/toggle_group_basic.dart';
import 'package:example/docs/examples/toggle_group/toggle_group_multiple.dart';
import 'package:example/docs/examples/toggle_group/toggle_group_outline.dart';

final toggleGroupDoc = ComponentDoc(
  slug: 'toggle_group',
  title: 'Toggle Group',
  description: 'A set of two-state buttons that can be toggled on or off.',
  examples: [
    ComponentExample(
      id: 'toggle_group_basic',
      title: 'Single',
      description: 'Selecting one value clears the others.',
      builder: (_) => const ToggleGroupBasicExample(),
    ),
    ComponentExample(
      id: 'toggle_group_multiple',
      title: 'Multiple',
      builder: (_) => const ToggleGroupMultipleExample(),
    ),
    ComponentExample(
      id: 'toggle_group_outline',
      title: 'Outline',
      description: 'Every item uses the outline toggle style.',
      builder: (_) => const ToggleGroupOutlineExample(),
    ),
  ],
);
