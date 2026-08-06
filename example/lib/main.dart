import 'package:disco/disco.dart';
import 'package:example/common/app_shell.dart';
import 'package:example/common/theme_editor/editor_config.dart';
import 'package:example/docs/docs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shad/shad.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SolidartConfig.devToolsEnabled = false;
  // The docs' code blocks need the Dart grammar and highlighter theme.
  await CodeHighlighter.ensureInitialized();
  runApp(const App());
}

final themeModeProvider = Provider((_) => Signal(ThemeMode.light));

final directionalityProvider = Provider((context) => Signal(TextDirection.ltr));

/// The theme the whole app is built from, edited by the customizer panel.
final themeConfigProvider = Provider((_) => Signal(const ThemeEditorConfig()));

/// Whether that panel is docked beside the app. [AppShell] opens it by
/// default on viewports wide enough to dock it.
final themeEditorOpenProvider = Provider((_) => Signal(false));

/// Named styles the app adds on top of whatever the editor produces — an
/// example of extending [ShadTextTheme]; see the `/typography` page for how
/// they are read back.
Map<String, TextStyle> appCustomTextStyles(Brightness brightness) => {
  'myCustomStyle': TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? Colors.blue : Colors.green,
  ),
};

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [
        themeModeProvider,
        directionalityProvider,
        themeConfigProvider,
        themeEditorOpenProvider,
      ],
      child: SignalBuilder(
        builder: (context, _) {
          final themeMode = themeModeProvider.of(context).value;
          final directionality = directionalityProvider.of(context).value;
          // Both themes come from the editor's configuration, so the panel
          // restyles the whole app — navigation, playground and docs alike.
          final config = themeConfigProvider.of(context).value;
          return ShadApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: config
                .copyWith(brightness: Brightness.light)
                .build(
                  customTextStyles: appCustomTextStyles(Brightness.light),
                ),
            darkTheme: config
                .copyWith(brightness: Brightness.dark)
                .build(
                  customTextStyles: appCustomTextStyles(Brightness.dark),
                ),
            home: const AppShell(),
            builder: (context, child) {
              return Directionality(
                textDirection: directionality,
                // The editor's text scale applies to the whole app; the
                // customizer panel resets it for its own chrome.
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(config.textScale),
                  ),
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
