import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _items = [
  (title: 'First section', content: 'Multiple sections can be open at once.'),
  (
    title: 'Second section',
    content: 'Opening this one does not close the first.',
  ),
];

class AccordionMultipleExample extends StatelessWidget {
  const AccordionMultipleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ShadAccordion<({String content, String title})>.multiple(
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
