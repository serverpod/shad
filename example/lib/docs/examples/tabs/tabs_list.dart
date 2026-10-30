import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// Tabs with no content render only their list: a segmented control that
/// switches something elsewhere on the page.
class TabsListExample extends StatefulWidget {
  const TabsListExample({super.key});

  @override
  State<TabsListExample> createState() => _TabsListExampleState();
}

class _TabsListExampleState extends State<TabsListExample> {
  var range = 'week';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        ShadTabs<String>(
          value: range,
          onChanged: (value) => setState(() => range = value),
          tabs: const [
            ShadTab(value: 'day', child: Text('Day')),
            ShadTab(value: 'week', child: Text('Week')),
            ShadTab(value: 'month', child: Text('Month')),
          ],
        ),
        Text(
          'Showing one $range',
          style: ShadTheme.of(context).textTheme.muted,
        ),
      ],
    );
  }
}
