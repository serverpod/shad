import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/button/button_icon.dart';
import 'package:example/docs/examples/button/button_loading.dart';
import 'package:example/docs/examples/button/button_sizes.dart';
import 'package:example/docs/examples/button/button_variants.dart';

final buttonDoc = ComponentDoc(
  slug: 'button',
  title: 'Button',
  description:
      'Displays a button or a component that looks like a button. Six '
      'variants share one API: pick the one matching the action\'s weight.',
  examples: [
    ComponentExample(
      id: 'button_variants',
      title: 'Variants',
      description:
          'Primary for the main action, secondary and outline for '
          'everything else, destructive for irreversible actions, ghost for '
          'toolbars, and link for inline navigation.',
      builder: (_) => const ButtonVariantsExample(),
    ),
    ComponentExample(
      id: 'button_sizes',
      title: 'Sizes',
      builder: (_) => const ButtonSizesExample(),
    ),
    ComponentExample(
      id: 'button_icon',
      title: 'With icon',
      description: 'Use leading and trailing to place icons around the label.',
      builder: (_) => const ButtonIconExample(),
    ),
    ComponentExample(
      id: 'button_loading',
      title: 'Loading',
      builder: (_) => const ButtonLoadingExample(),
    ),
  ],
);
