import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/calendar/calendar_range.dart';
import 'package:example/docs/examples/calendar/calendar_single.dart';

final calendarDoc = ComponentDoc(
  slug: 'calendar',
  title: 'Calendar',
  description:
      'A component that allows users to select dates: single, multiple or a '
      'range.',
  playgroundRoute: '/calendar',
  examples: [
    ComponentExample(
      id: 'calendar_single',
      title: 'Single',
      builder: (_) => const CalendarSingleExample(),
    ),
    ComponentExample(
      id: 'calendar_range',
      title: 'Range',
      description: 'Constrain the selection with min and max lengths.',
      builder: (_) => const CalendarRangeExample(),
    ),
  ],
);
