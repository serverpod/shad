import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  final darkTheme = ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadNeutralColorScheme.dark(),
  );

  group('ShadThemeScope', () {
    testWidgets('publishes the Shad theme to its subtree', (tester) async {
      late ShadThemeData seen;
      await tester.pumpWidget(
        ShadApp(
          home: ShadThemeScope(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                seen = ShadTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(seen.brightness, Brightness.dark);
    });

    testWidgets('text follows the scoped theme, not the app', (tester) async {
      // The regression this exists for: a dark panel inside a light app used
      // to inherit the app's DefaultTextStyle and render black-on-black.
      late TextStyle style;
      await tester.pumpWidget(
        ShadApp(
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadNeutralColorScheme.light(),
          ),
          home: ShadThemeScope(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                style = DefaultTextStyle.of(context).style;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(style.color, darkTheme.colorScheme.foreground);
    });

    testWidgets('icons follow the scoped theme', (tester) async {
      late IconThemeData icons;
      await tester.pumpWidget(
        ShadApp(
          home: ShadThemeScope(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                icons = IconTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(icons.color, darkTheme.colorScheme.foreground);
    });

    testWidgets('installs a matching Material theme', (tester) async {
      late ThemeData material;
      await tester.pumpWidget(
        ShadApp(
          home: ShadThemeScope(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                material = Theme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(material.brightness, Brightness.dark);
      expect(material.colorScheme.surface, darkTheme.colorScheme.background);
    });

    testWidgets('applyMaterialTheme: false leaves Material alone', (
      tester,
    ) async {
      late ThemeData material;
      await tester.pumpWidget(
        ShadApp(
          home: ShadThemeScope(
            data: darkTheme,
            applyMaterialTheme: false,
            child: Builder(
              builder: (context) {
                material = Theme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(material.brightness, Brightness.light);
    });
  });

  group('showShadDialog theme inheritance', () {
    testWidgets("a dialog opened from a scope keeps that scope's theme", (
      tester,
    ) async {
      // A route is built under the Navigator, so without the fix the dialog
      // would pick up the app theme and clash with the panel it came from.
      late ShadThemeData insideDialog;

      await tester.pumpWidget(
        ShadApp(
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadNeutralColorScheme.light(),
          ),
          home: ShadThemeScope(
            data: darkTheme,
            child: Builder(
              builder: (context) => ShadButton(
                onPressed: () => showShadDialog<void>(
                  context: context,
                  builder: (context) {
                    insideDialog = ShadTheme.of(context);
                    return const ShadDialog(child: Text('hi'));
                  },
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(insideDialog.brightness, Brightness.dark);
      expect(
        insideDialog.colorScheme.background,
        darkTheme.colorScheme.background,
      );
    });
  });
}
