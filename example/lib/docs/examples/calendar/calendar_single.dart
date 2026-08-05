import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CalendarSingleExample extends StatefulWidget {
  const CalendarSingleExample({super.key});

  @override
  State<CalendarSingleExample> createState() => _CalendarSingleExampleState();
}

class _CalendarSingleExampleState extends State<CalendarSingleExample> {
  DateTime? selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ShadCalendar(
      selected: selected,
      onChanged: (date) => setState(() => selected = date),
    );
  }
}
