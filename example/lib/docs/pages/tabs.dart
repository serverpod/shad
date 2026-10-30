import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/tabs/tabs_basic.dart';
import 'package:example/docs/examples/tabs/tabs_list.dart';

final tabsDoc = ComponentDoc(
  slug: 'tabs',
  title: 'Tabs',
  description: 'A set of layered sections of content displayed one at a time.',
  examples: [
    ComponentExample(
      id: 'tabs_basic',
      title: 'Default',
      minPreviewHeight: 480,
      builder: (_) => const TabsBasicExample(),
    ),
    ComponentExample(
      id: 'tabs_list',
      title: 'Tabs list',
      description:
          'With no content, only the list renders: a segmented control.',
      minPreviewHeight: 160,
      builder: (_) => const TabsListExample(),
    ),
  ],
);
