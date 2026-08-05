import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/select/select_basic.dart';
import 'package:example/docs/examples/select/select_search.dart';

final selectDoc = ComponentDoc(
  slug: 'select',
  title: 'Select',
  description:
      'Displays a list of options for the user to pick from, triggered by a '
      'button.',
  playgroundRoute: '/select',
  examples: [
    ComponentExample(
      id: 'select_basic',
      title: 'Default',
      builder: (_) => const SelectBasicExample(),
    ),
    ComponentExample(
      id: 'select_search',
      title: 'With search',
      builder: (_) => const SelectSearchExample(),
    ),
  ],
);
