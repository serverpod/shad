import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// ShadScrollbar gives any scrollable — here a lazily built list — the same
/// scrollbar as ShadScrollArea.
class ScrollAreaListExample extends StatefulWidget {
  const ScrollAreaListExample({super.key});

  @override
  State<ScrollAreaListExample> createState() => _ScrollAreaListExampleState();
}

class _ScrollAreaListExampleState extends State<ScrollAreaListExample> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 240,
      height: 240,
      child: ShadScrollbar(
        controller: controller,
        thumbVisibility: true,
        child: ListView.builder(
          controller: controller,
          itemCount: 1000,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text('Row ${i + 1}', style: theme.textTheme.small),
          ),
        ),
      ),
    );
  }
}
