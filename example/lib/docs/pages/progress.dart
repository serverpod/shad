import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/progress/progress_basic.dart';

final progressDoc = ComponentDoc(
  slug: 'progress',
  title: 'Progress',
  description:
      'Displays an indicator showing the completion progress of a task.',
  playgroundRoute: '/progress',
  examples: [
    ComponentExample(
      id: 'progress_basic',
      title: 'Determinate and indeterminate',
      builder: (_) => const ProgressBasicExample(),
    ),
  ],
);
