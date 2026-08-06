import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/context_menu/context_menu_basic.dart';

final contextMenuDoc = ComponentDoc(
  slug: 'context_menu',
  title: 'Context Menu',
  description:
      'Displays a menu at the pointer, triggered by a right click or a long '
      'press.',
  examples: [
    ComponentExample(
      id: 'context_menu_basic',
      title: 'Default',
      minPreviewHeight: 280,
      builder: (_) => const ContextMenuBasicExample(),
    ),
  ],
);
