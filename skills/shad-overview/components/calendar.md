# Calendar

A component that allows users to select dates: single, multiple, or a range.

## Single

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

## Range

Constrain the selection with min and max lengths.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

