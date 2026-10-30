# Scroll Area

Scrolls its content with a thin themed scrollbar. ShadScrollbar puts the same scrollbar on any scrollable.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ScrollAreaBasicExample extends StatelessWidget {
  const ScrollAreaBasicExample({super.key});

  static final tags = [for (var i = 50; i > 0; i--) 'v1.2.0-beta.$i'];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      width: 192,
      height: 288,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: theme.radius,
      ),
      child: ShadScrollArea(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tags', style: theme.textTheme.small),
            const SizedBox(height: 16),
            for (final tag in tags) ...[
              Text(tag, style: theme.textTheme.muted),
              const ShadSeparator.horizontal(),
            ],
          ],
        ),
      ),
    );
  }
}
```

## Any scrollable

Wrap a ListView, GridView or CustomScrollView in ShadScrollbar.

```dart
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
```

