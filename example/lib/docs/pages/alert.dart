import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/alert/alert_default.dart';
import 'package:example/docs/examples/alert/alert_destructive.dart';

final alertDoc = ComponentDoc(
  slug: 'alert',
  title: 'Alert',
  description: 'Displays a callout for user attention.',
  examples: [
    ComponentExample(
      id: 'alert_default',
      title: 'Default',
      builder: (_) => const AlertDefaultExample(),
    ),
    ComponentExample(
      id: 'alert_destructive',
      title: 'Destructive',
      builder: (_) => const AlertDestructiveExample(),
    ),
  ],
);
