import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/tabs/tabs_basic.dart';

final tabsDoc = ComponentDoc(
  slug: 'tabs',
  title: 'Tabs',
  description: 'A set of layered sections of content displayed one at a time.',
  playgroundRoute: '/tabs',
  examples: [
    ComponentExample(
      id: 'tabs_basic',
      title: 'Default',
      minPreviewHeight: 480,
      builder: (_) => const TabsBasicExample(),
    ),
  ],
);
