import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/time_picker/time_picker_basic.dart';
import 'package:example/docs/examples/time_picker/time_picker_period.dart';

final timePickerDoc = ComponentDoc(
  slug: 'time_picker',
  title: 'Time Picker',
  description: 'A field for entering a time of day.',
  examples: [
    ComponentExample(
      id: 'time_picker_basic',
      title: '24-hour',
      builder: (_) => const TimePickerBasicExample(),
    ),
    ComponentExample(
      id: 'time_picker_period',
      title: 'With AM/PM period',
      builder: (_) => const TimePickerPeriodExample(),
    ),
  ],
);
