import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/accordion/accordion_multiple.dart';
import 'package:example/docs/examples/accordion/accordion_single.dart';

final accordionDoc = ComponentDoc(
  slug: 'accordion',
  title: 'Accordion',
  description:
      'A vertically stacked set of interactive headings that each reveal a '
      'section of content.',
  examples: [
    ComponentExample(
      id: 'accordion_single',
      title: 'Single',
      description: 'Opening a section closes the previous one.',
      builder: (_) => const AccordionSingleExample(),
    ),
    ComponentExample(
      id: 'accordion_multiple',
      title: 'Multiple',
      description: 'Sections open and close independently.',
      builder: (_) => const AccordionMultipleExample(),
    ),
  ],
);
