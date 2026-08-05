import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/tooltip/tooltip_basic.dart';

final tooltipDoc = ComponentDoc(
  slug: 'tooltip',
  title: 'Tooltip',
  description:
      'A popup that displays information related to an element on hover or '
      'focus.',
  playgroundRoute: '/tooltip',
  examples: [
    ComponentExample(
      id: 'tooltip_basic',
      title: 'Default',
      builder: (_) => const TooltipBasicExample(),
    ),
  ],
);
