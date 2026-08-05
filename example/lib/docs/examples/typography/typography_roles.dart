import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TypographyRolesExample extends StatelessWidget {
  const TypographyRolesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = ShadTheme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('Taxing Laughter', style: textTheme.h1),
          Text('The People of the Kingdom', style: textTheme.h2),
          Text('The Joke Tax', style: textTheme.h3),
          Text('People stopped telling jokes', style: textTheme.h4),
          Text(
            'The king, seeing how much happier his subjects were, realized '
            'the error of his ways and repealed the joke tax.',
            style: textTheme.p,
          ),
          Text(
            '"After all," he said, "everyone enjoys a good joke, so it\'s '
            'only fair that they should pay for the privilege."',
            style: textTheme.blockquote,
          ),
          Text('A modest tax increase', style: textTheme.lead),
          Text('Are you absolutely sure?', style: textTheme.large),
          Text('Email address', style: textTheme.small),
          Text('Enter your email address.', style: textTheme.muted),
        ],
      ),
    );
  }
}
