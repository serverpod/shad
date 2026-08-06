# Card

Displays a card with title, description, content, and footer.

## With a form

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _frameworks = {
  'next': 'Next.js',
  'react': 'React',
  'astro': 'Astro',
  'nuxt': 'Nuxt.js',
};

class CardProjectExample extends StatelessWidget {
  const CardProjectExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      width: 350,
      title: const Text('Create project'),
      description: const Text('Deploy your new project in one-click.'),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShadButton.outline(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
          ShadButton(
            onPressed: () {},
            child: const Text('Deploy'),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Name'),
          const SizedBox(height: 6),
          const ShadInput(placeholder: Text('Name of your project')),
          const SizedBox(height: 16),
          const Text('Framework'),
          const SizedBox(height: 6),
          ShadSelect<String>(
            placeholder: const Text('Select'),
            options: [
              for (final entry in _frameworks.entries)
                ShadOption(value: entry.key, child: Text(entry.value)),
            ],
            selectedOptionBuilder: (context, value) =>
                Text(_frameworks[value]!),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
```

