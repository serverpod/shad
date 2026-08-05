import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/date_picker/date_picker_range.dart';
import 'package:example/docs/examples/date_picker/date_picker_single.dart';

final datePickerDoc = ComponentDoc(
  slug: 'date_picker',
  title: 'Date Picker',
  description: 'A date picker with the calendar in a popover.',
  playgroundRoute: '/date-picker',
  examples: [
    ComponentExample(
      id: 'date_picker_single',
      title: 'Single',
      builder: (_) => const DatePickerSingleExample(),
    ),
    ComponentExample(
      id: 'date_picker_range',
      title: 'Range',
      builder: (_) => const DatePickerRangeExample(),
    ),
  ],
);
