import 'package:example/docs/docs.dart';

final fontsDoc = ComponentDoc(
  slug: 'fonts',
  title: 'Fonts',
  description:
      'shad bundles no fonts. Text uses the platform font until you choose '
      'one: from Google Fonts at runtime, or from your own assets.',
  body: (context) => const DocProse(
    children: [
      DocSection(
        title: 'Google Fonts',
        children: [
          DocParagraph(
            'Add `google_fonts` and build the text theme from one of its '
            'fonts. Faces are fetched the first time they are used. This '
            'docs site does it for every font in the theme editor.',
          ),
          CodeBlock(
            code: '''
// flutter pub add google_fonts
ShadThemeData(
  textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter),
)''',
          ),
          DocParagraph(
            'Pass a static tear-off such as `GoogleFonts.inter`. If you wrap '
            '`GoogleFonts.getFont(name)` in a closure, create it once and '
            'reuse it: a new closure on every build makes the theme unequal '
            'to itself, which restarts the theme transition on every '
            'rebuild.',
          ),
          DocParagraph(
            'To avoid a flash of the fallback font on the first frame, fetch '
            'the face before `runApp`:',
          ),
          CodeBlock(
            code: '''
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.inter();
  await GoogleFonts.pendingFonts();
  runApp(const App());
}''',
          ),
        ],
      ),
      DocSection(
        title: 'Your own fonts',
        children: [
          DocParagraph(
            'Put the files in your app, declare the family in pubspec.yaml, '
            'and name it in the text theme. Ship the font licence with it.',
          ),
          CodeBlock(
            code: '''
# pubspec.yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter[opsz,wght].ttf''',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  textTheme: ShadTextTheme(family: 'Inter'),
)''',
          ),
          DocParagraph(
            'A font from another package is named with its package: '
            "`ShadTextTheme(family: 'Inter', package: 'my_fonts')`.",
          ),
        ],
      ),
      DocSection(
        title: 'Which font',
        children: [
          DocParagraph(
            "shadcn/ui's default font is Inter. Geist and Geist Mono give "
            "the Vercel look. Controls keep their heights whatever the font, "
            'because heights come from the style tokens.',
          ),
        ],
      ),
    ],
  ),
);
