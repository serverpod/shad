import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// An open dialog or sheet follows the app theme: switching light/dark while
/// it is open restyles it too. It used to keep the theme it was opened with.
void main() {
  testWidgets('an open dialog follows a light/dark switch', (tester) async {
    final mode = ValueNotifier(ShadThemeMode.light);
    addTearDown(mode.dispose);
    Brightness? seen;

    await tester.pumpWidget(
      ValueListenableBuilder(
        valueListenable: mode,
        builder: (context, themeMode, _) => ShadApp(
          themeMode: themeMode,
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadZincColorScheme.light(),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
          ),
          home: Builder(
            builder: (context) => Center(
              child: ShadButton(
                onPressed: () => showShadDialog<void>(
                  context: context,
                  builder: (context) => ShadDialog(
                    child: Builder(
                      builder: (context) {
                        seen = ShadTheme.of(context).brightness;
                        return const Text('content');
                      },
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(seen, Brightness.light);

    mode.value = ShadThemeMode.dark;
    await tester.pumpAndSettle();
    expect(find.text('content'), findsOneWidget);
    expect(seen, Brightness.dark);
  });

  testWidgets('a dialog opened from a re-themed subtree keeps that theme', (
    tester,
  ) async {
    Brightness? seen;
    await tester.pumpWidget(
      ShadApp(
        theme: ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
        ),
        home: ShadThemeScope(
          data: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
          ),
          child: Builder(
            builder: (context) => Center(
              child: ShadButton(
                onPressed: () => showShadDialog<void>(
                  context: context,
                  builder: (context) => ShadDialog(
                    child: Builder(
                      builder: (context) {
                        seen = ShadTheme.of(context).brightness;
                        return const Text('content');
                      },
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(seen, Brightness.dark);
  });
}
