import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/spinner/spinner_basic.dart';

final spinnerDoc = ComponentDoc(
  slug: 'spinner',
  title: 'Spinner',
  description: 'An animated loading indicator.',
  examples: [
    ComponentExample(
      id: 'spinner_basic',
      title: 'Sizes',
      builder: (_) => const SpinnerBasicExample(),
    ),
  ],
);
