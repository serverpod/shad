import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/material.dart';
import 'package:shad/shad.dart';

/// shad's core does not depend on Material or Cupertino, which Flutter is
/// moving out of the SDK into the `material_ui` and `cupertino_ui` packages.
/// Interop is opt-in through `package:shad/material.dart`.
void main() {
  final dark = ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadZincColorScheme.dark(),
  );

  test('only lib/material.dart imports Material or Cupertino', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path == 'lib/material.dart') continue;
      final imports = RegExp(
        r'''^\s*(import|export)\s+'package:flutter/(material|cupertino)\.dart''',
        multiLine: true,
      );
      if (imports.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty);
  });

  group('ShadApp without ShadMaterial', () {
    testWidgets('sets the icon and selection styles from the shad theme', (
      tester,
    ) async {
      late IconThemeData icons;
      late DefaultSelectionStyle selection;
      await tester.pumpWidget(
        ShadApp(
          themeMode: ShadThemeMode.dark,
          darkTheme: dark,
          home: Builder(
            builder: (context) {
              icons = IconTheme.of(context);
              selection = DefaultSelectionStyle.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(icons.size, 16);
      expect(icons.color, dark.colorScheme.foreground);
      expect(selection.cursorColor, dark.colorScheme.primary);
      expect(selection.selectionColor, dark.colorScheme.selection);
    });

    testWidgets('pushes pages with a ShadPageRoute', (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ShadApp(
          navigatorKey: navigator,
          routes: {
            '/': (_) => const Text('home'),
            '/next': (_) => const Text('next'),
          },
        ),
      );
      navigator.currentState!.pushNamed('/next');
      await tester.pumpAndSettle();
      expect(find.text('next'), findsOneWidget);
      expect(
        ModalRoute.of(tester.element(find.text('next'))),
        isA<ShadPageRoute<Object?>>(),
      );
    });

    testWidgets('gives vertical scrollables a ShadScrollbar on desktop', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.pumpWidget(
        ShadApp(
          home: ListView(
            children: [for (var i = 0; i < 50; i++) Text('$i')],
          ),
        ),
      );
      expect(find.byType(ShadScrollbar), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('ShadMaterial', () {
    testWidgets('derives the Material theme from the shad theme', (
      tester,
    ) async {
      late ThemeData material;
      await tester.pumpWidget(
        ShadApp(
          themeMode: ShadThemeMode.dark,
          darkTheme: dark,
          builder: (context, child) => ShadMaterial(child: child!),
          home: Builder(
            builder: (context) {
              material = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(material.brightness, Brightness.dark);
      expect(material.colorScheme.primary, dark.colorScheme.primary);
      expect(material.colorScheme.surface, dark.colorScheme.background);
    });

    testWidgets('themeBuilder changes the derived theme', (tester) async {
      late ThemeData material;
      await tester.pumpWidget(
        ShadApp(
          builder: (context, child) => ShadMaterial(
            themeBuilder: (context, theme) =>
                theme.copyWith(splashFactory: NoSplash.splashFactory),
            child: child!,
          ),
          home: Builder(
            builder: (context) {
              material = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(material.splashFactory, NoSplash.splashFactory);
    });

    testWidgets('provides what TextField and Slider need', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadApp(
          builder: (context, child) => ShadMaterial(child: child!),
          home: const Column(
            children: [TextField(), Slider(value: .5, onChanged: null)],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(TextField));
      expect(MaterialLocalizations.of(context), isNotNull);
      expect(CupertinoLocalizations.of(context), isNotNull);
    });

    testWidgets('keeps the text direction set above it', (tester) async {
      late TextDirection direction;
      await tester.pumpWidget(
        ShadApp(
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: ShadMaterial(child: child!),
          ),
          home: Builder(
            builder: (context) {
              direction = Directionality.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(direction, TextDirection.rtl);
    });

    testWidgets('keeps localizations an ancestor already provides', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => ShadMaterial(child: child!),
          home: const SizedBox.shrink(),
        ),
      );
      // Only the app's own Localizations: the bridge added no override.
      expect(find.byType(Localizations), findsOneWidget);
    });
  });
}
