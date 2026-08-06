import 'package:example/docs/docs.dart';

final installationDoc = ComponentDoc(
  slug: 'installation',
  title: 'Installation',
  description: 'Add the package, wrap your app in ShadApp, start building.',
  body: (context) => const DocProse(
    children: [
      DocSection(
        title: 'Install the package',
        children: [
          DocParagraph(
            'Add `shad` to your project from the command line:',
          ),
          CodeBlock(code: 'flutter pub add shad'),
          DocParagraph(
            'Everything ships through one import — components, theme, '
            'Lucide icons and animation effects:',
          ),
          CodeBlock(code: "import 'package:shad/shad.dart';"),
        ],
      ),
      DocSection(
        title: 'Set up ShadApp',
        children: [
          DocParagraph(
            '`ShadApp` takes the place of `MaterialApp`: it installs the '
            'theme, localizations, navigation and the overlay layer the '
            'floating components use. With no arguments it uses the slate '
            'colour scheme and the nova style.',
          ),
          CodeBlock(
            code: '''
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadApp(
      home: HomePage(),
    );
  }
}''',
          ),
          DocParagraph(
            'Apps using the `Router` API use `ShadApp.router` with the '
            'usual `routerConfig` or delegate parameters.',
          ),
        ],
      ),
      DocSection(
        title: 'Dark mode',
        children: [
          DocParagraph(
            'Pass a `theme` and a `darkTheme`, and pick between them with '
            '`themeMode` — follow the platform, or bind it to your own '
            'setting:',
          ),
          CodeBlock(
            code: '''
ShadApp(
  themeMode: ThemeMode.system,
  theme: ShadThemeData(),
  darkTheme: ShadThemeData(
    brightness: Brightness.dark,
  ),
  home: const HomePage(),
)''',
          ),
        ],
      ),
      DocSection(
        title: 'Use the components',
        children: [
          DocParagraph(
            'Components are plain widgets. Icons come from the bundled '
            'Lucide set:',
          ),
          CodeBlock(
            code: '''
ShadButton(
  leading: const Icon(LucideIcons.mail),
  onPressed: () {},
  child: const Text('Login with Email'),
)''',
          ),
          DocParagraph(
            'From here, the Theming and Styles pages cover making it yours, '
            'and each component page pairs live previews with the code that '
            'renders them.',
          ),
        ],
      ),
    ],
  ),
);
