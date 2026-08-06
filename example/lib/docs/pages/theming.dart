import 'package:example/docs/docs.dart';

final themingDoc = ComponentDoc(
  slug: 'theming',
  title: 'Theming',
  description:
      'One ShadThemeData drives every component: colour scheme, radius, '
      'typography, and per-component overrides.',
  body: (context) => const DocProse(
    children: [
      DocSection(
        title: 'Reading the theme',
        children: [
          DocParagraph(
            'Every component resolves its appearance from the nearest '
            '`ShadTheme`. Your own widgets read it the same way:',
          ),
          CodeBlock(
            code: '''
final theme = ShadTheme.of(context);

theme.colorScheme.primary;   // the palette
theme.textTheme.p;           // the type scale
theme.radius;                // the base corner radius
theme.style;                 // the active style preset''',
          ),
        ],
      ),
      DocSection(
        title: 'Colour schemes',
        children: [
          DocParagraph(
            'Sixteen schemes ship in light and dark: blue, gray, green, '
            'mauve, mist, neutral, olive, orange, red, rose, slate '
            '(the default), stone, taupe, violet, yellow and zinc.',
          ),
          CodeBlock(
            code: '''
ShadApp(
  theme: ShadThemeData(
    colorScheme: const ShadZincColorScheme.light(),
  ),
  darkTheme: ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadZincColorScheme.dark(),
  ),
)''',
          ),
          DocParagraph(
            'To let users pick a palette at runtime, resolve one by name '
            'with `ShadColorScheme.fromName`:',
          ),
          CodeBlock(
            code: '''
final scheme = ShadColorScheme.fromName(
  'rose',
  brightness: Brightness.dark,
);''',
          ),
        ],
      ),
      DocSection(
        title: 'Customising a scheme',
        children: [
          DocParagraph(
            'A scheme is a value: override individual slots where you '
            'construct it, and carry your own colours in the `custom` map '
            'so they lerp and switch with the rest of the theme.',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  colorScheme: const ShadSlateColorScheme.light(
    primary: Color(0xFF16A34A),
    custom: {
      'highlight': Color(0xFFFACC15),
    },
  ),
)

// Read it back anywhere:
ShadTheme.of(context).colorScheme.custom['highlight'];''',
          ),
          DocParagraph(
            'An extension keeps custom colours as ergonomic as the '
            'built-in ones:',
          ),
          CodeBlock(
            code: '''
extension AppColors on ShadColorScheme {
  Color get highlight => custom['highlight']!;
}''',
          ),
        ],
      ),
      DocSection(
        title: 'Component themes',
        children: [
          DocParagraph(
            'Every component has a theme slot on `ShadThemeData` — '
            '`primaryButtonTheme`, `cardTheme`, `inputTheme` and so on. '
            'Values you pass are merged over what the style derives, so an '
            'override touches exactly the property you name:',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  primaryButtonTheme: const ShadButtonTheme(
    backgroundColor: Color(0xFF16A34A),
  ),
)''',
          ),
        ],
      ),
      DocSection(
        title: 'Radius',
        children: [
          DocParagraph(
            'The theme carries one base radius — the `md` step of the '
            "scale. Everything else derives from it: at the default 8 the "
            'scale runs sm 6, md 8, lg 10, xl 14, 2xl 16, 3xl 24, 4xl 32, '
            'and each component picks the step its style prescribes.',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  radius: const BorderRadius.all(Radius.circular(10)),
)''',
          ),
        ],
      ),
      DocSection(
        title: 'Menu appearance',
        children: [
          DocParagraph(
            "The shadcn theme editor's menu options are theme settings "
            'here too: `menuColorScheme` renders menu surfaces on another '
            'palette (pass the dark counterpart for the "Inverted" look), '
            '`menuTranslucent` gives them the blurred 70% finish, and '
            '`menuAccent` picks how strongly rows highlight.',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  menuColorScheme: const ShadSlateColorScheme.dark(),
  menuTranslucent: true,
  menuAccent: ShadMenuAccent.bold,
)''',
          ),
        ],
      ),
      DocSection(
        title: 'Focus rings',
        children: [
          DocParagraph(
            'Focus is shown as an outward ring, like shadcn/ui. Set '
            '`disableSecondaryBorder: true` to switch to the alternative '
            'treatment — a 2px border inside the control — which keeps '
            'focus visible where an outward ring would be clipped.',
          ),
        ],
      ),
    ],
  ),
);
