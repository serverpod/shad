import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/icon_button/icon_button_variants.dart';

final iconButtonDoc = ComponentDoc(
  slug: 'icon_button',
  title: 'Icon Button',
  description: 'A square button holding a single icon.',
  examples: [
    ComponentExample(
      id: 'icon_button_variants',
      title: 'Variants',
      builder: (_) => const IconButtonVariantsExample(),
    ),
  ],
);
