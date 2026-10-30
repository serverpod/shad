import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/context_menu/context_menu_basic.dart';
import 'package:example/docs/examples/context_menu/context_menu_submenus.dart';

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
    ComponentExample(
      id: 'context_menu_submenus',
      title: 'Submenus',
      description:
          'Eight rows in a row open a submenu, and two of them nest a '
          'second level. Sweep the pointer down the list: each submenu '
          'closes the moment the next row is reached.',
      minPreviewHeight: 280,
      builder: (_) => const ContextMenuSubmenusExample(),
    ),
  ],
);
