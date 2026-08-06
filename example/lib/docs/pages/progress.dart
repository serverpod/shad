import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/progress/progress_basic.dart';

final progressDoc = ComponentDoc(
  slug: 'progress',
  title: 'Progress',
  description: 'An indicator that shows how much of a task is complete.',
  playgroundRoute: '/progress',
  examples: [
    ComponentExample(
      id: 'progress_basic',
      title: 'Determinate and indeterminate',
      builder: (_) => const ProgressBasicExample(),
    ),
  ],
);
