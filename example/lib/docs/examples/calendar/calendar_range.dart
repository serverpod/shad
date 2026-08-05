import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CalendarRangeExample extends StatelessWidget {
  const CalendarRangeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCalendar.range(
      min: 2,
      max: 7,
    );
  }
}
