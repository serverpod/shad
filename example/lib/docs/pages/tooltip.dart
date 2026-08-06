import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/tooltip/tooltip_basic.dart';
import 'package:example/docs/examples/tooltip/tooltip_disabled.dart';
import 'package:example/docs/examples/tooltip/tooltip_formatted.dart';
import 'package:example/docs/examples/tooltip/tooltip_icon.dart';
import 'package:example/docs/examples/tooltip/tooltip_keyboard.dart';
import 'package:example/docs/examples/tooltip/tooltip_link.dart';
import 'package:example/docs/examples/tooltip/tooltip_long_content.dart';
import 'package:example/docs/examples/tooltip/tooltip_sides.dart';

final tooltipDoc = ComponentDoc(
  slug: 'tooltip',
  title: 'Tooltip',
  description:
      'A popup that displays information related to an element on hover or '
      'focus.',
  examples: [
    ComponentExample(
      id: 'tooltip_basic',
      title: 'Basic',
      builder: (_) => const TooltipBasicExample(),
    ),
    ComponentExample(
      id: 'tooltip_sides',
      title: 'Sides',
      description:
          'An anchor places the tooltip on any side of its trigger; the '
          'arrow direction follows it.',
      builder: (_) => const TooltipSidesExample(),
    ),
    ComponentExample(
      id: 'tooltip_icon',
      title: 'With icon',
      builder: (_) => const TooltipIconExample(),
    ),
    ComponentExample(
      id: 'tooltip_long_content',
      title: 'Long content',
      description: 'Long content wraps at the tooltip’s max width.',
      builder: (_) => const TooltipLongContentExample(),
    ),
    ComponentExample(
      id: 'tooltip_disabled',
      title: 'Disabled',
      description:
          'A disabled control absorbs pointer events, so a gesture wrapper '
          'reports the hover on its behalf.',
      builder: (_) => const TooltipDisabledExample(),
    ),
    ComponentExample(
      id: 'tooltip_keyboard',
      title: 'With keyboard shortcut',
      builder: (_) => const TooltipKeyboardExample(),
    ),
    ComponentExample(
      id: 'tooltip_link',
      title: 'On link',
      builder: (_) => const TooltipLinkExample(),
    ),
    ComponentExample(
      id: 'tooltip_formatted',
      title: 'Formatted content',
      builder: (_) => const TooltipFormattedExample(),
    ),
  ],
);
