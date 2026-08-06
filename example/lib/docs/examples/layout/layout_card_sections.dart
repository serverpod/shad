import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// A card interior laid out with `ShadColumn` spacing and separators.
class LayoutCardSectionsExample extends StatefulWidget {
  const LayoutCardSectionsExample({super.key});

  @override
  State<LayoutCardSectionsExample> createState() =>
      _LayoutCardSectionsExampleState();
}

class _LayoutCardSectionsExampleState extends State<LayoutCardSectionsExample> {
  bool email = true;
  bool push = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadCard(
        title: const Text('Notifications'),
        description: const Text('Choose what you want to be notified about'),
        child: ShadColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            ShadCheckbox(
              value: email,
              onChanged: (v) => setState(() => email = v),
              label: const Text('Email'),
            ),
            ShadCheckbox(
              value: push,
              onChanged: (v) => setState(() => push = v),
              label: const Text('Push'),
            ),
            const ShadSeparator.horizontal(
              margin: EdgeInsets.symmetric(vertical: 4),
            ),
            ShadButton(onPressed: () {}, child: const Text('Save preferences')),
          ],
        ),
      ),
    );
  }
}
