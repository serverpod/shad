import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/command/command_dialog.dart';
import 'package:example/docs/examples/command/command_inline.dart';

final commandDoc = ComponentDoc(
  slug: 'command',
  title: 'Command',
  description:
      'A composable command menu with filtering and full keyboard '
      'navigation.',
  playgroundRoute: '/command',
  examples: [
    ComponentExample(
      id: 'command_inline',
      title: 'Inline',
      description:
          'Arrow keys move the highlight, Enter selects. Keywords let '
          'items match terms their label does not contain.',
      builder: (_) => const CommandInlineExample(),
    ),
    ComponentExample(
      id: 'command_dialog',
      title: 'Dialog',
      builder: (_) => const CommandDialogExample(),
    ),
  ],
);
