import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _items = [
  (
    title: 'Is it accessible?',
    content: 'Yes. It adheres to the WAI-ARIA design pattern.',
  ),
  (
    title: 'Is it styled?',
    content:
        'Yes. It comes with default styles that match the other '
        "components' aesthetic.",
  ),
  (
    title: 'Is it animated?',
    content:
        "Yes. It's animated by default, but you can disable it if "
        'you prefer.',
  ),
];

class AccordionSingleExample extends StatelessWidget {
  const AccordionSingleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ShadAccordion<({String content, String title})>(
        children: [
          for (final item in _items)
            ShadAccordionItem(
              value: item,
              title: Text(item.title),
              child: Text(item.content),
            ),
        ],
      ),
    );
  }
}
