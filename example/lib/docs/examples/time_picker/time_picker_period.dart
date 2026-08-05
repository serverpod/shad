import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TimePickerPeriodExample extends StatelessWidget {
  const TimePickerPeriodExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTimePicker.period(
      onChanged: (time) {},
    );
  }
}
