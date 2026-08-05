import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/sidebar/sidebar_basic.dart';
import 'package:example/docs/examples/sidebar/sidebar_submenu.dart';

final sidebarDoc = ComponentDoc(
  slug: 'sidebar',
  title: 'Sidebar',
  description:
      'A composable, collapsible side navigation panel. Collapses to an '
      'icon rail or off-canvas, floats or insets, and becomes a modal sheet '
      'under the mobile breakpoint. ⌘B toggles it.',
  examples: [
    ComponentExample(
      id: 'sidebar_basic',
      title: 'Icon rail',
      description:
          'With collapsible: icon the sidebar shrinks to a rail of icons; '
          'menu buttons show their label as a tooltip. This docs app itself '
          'runs on ShadSidebarScaffold.',
      minPreviewHeight: 480,
      builder: (_) => const SidebarBasicExample(),
    ),
    ComponentExample(
      id: 'sidebar_submenu',
      title: 'Floating, with sub-menus',
      minPreviewHeight: 480,
      builder: (_) => const SidebarSubmenuExample(),
    ),
  ],
);
