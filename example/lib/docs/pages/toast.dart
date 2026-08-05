import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/toast/toast_basic.dart';
import 'package:example/docs/examples/toast/toast_destructive.dart';

final toastDoc = ComponentDoc(
  slug: 'toast',
  title: 'Toast',
  description: 'A succinct message that is displayed temporarily.',
  playgroundRoute: '/toast',
  examples: [
    ComponentExample(
      id: 'toast_basic',
      title: 'Default',
      builder: (_) => const ToastBasicExample(),
    ),
    ComponentExample(
      id: 'toast_destructive',
      title: 'Destructive',
      builder: (_) => const ToastDestructiveExample(),
    ),
  ],
);
