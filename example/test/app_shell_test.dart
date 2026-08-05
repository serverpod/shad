import 'package:disco/disco.dart';
import 'package:example/common/app_shell.dart';
import 'package:example/common/theme_editor/customizer_panel.dart';
import 'package:example/common/theme_editor/preview_panel.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  Future<void> pumpShell(
    WidgetTester tester, {
    Size size = const Size(1400, 1200),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        providers: [
          themeModeProvider,
          directionalityProvider,
          themeConfigProvider,
          themeEditorOpenProvider,
        ],
        child: const ShadApp(home: AppShell()),
      ),
    );
    // Doc previews contain spinners and skeletons that animate forever, so
    // pump fixed frames rather than pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// Switches to the docs browser, which is no longer the launch section.
  Future<void> openComponents(WidgetTester tester) async {
    await tester.tap(find.text('Components').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('the shell opens on the playground', (tester) async {
    await pumpShell(tester);

    expect(find.text('shad'), findsOneWidget);
    expect(find.text('Playground'), findsOneWidget);
    expect(find.text('Components'), findsWidgets);
    // The playground is the section shown at launch...
    expect(find.byType(ThemePreviewPanel), findsOneWidget);
    expect(find.text('Contribution History'), findsOneWidget);
    // ...and the editor is closed until it is asked for.
    expect(find.byType(ThemeCustomizerPanel), findsNothing);
  });

  testWidgets('the Components link opens the docs browser', (tester) async {
    await pumpShell(tester);
    await openComponents(tester);

    // The sidebar lists the components; Typography is the first entry.
    expect(find.byType(ShadSidebar), findsOneWidget);
    expect(find.text('Typography'), findsWidgets);
  });

  testWidgets('selecting a component in the sidebar opens its doc page', (
    tester,
  ) async {
    await pumpShell(tester);
    await openComponents(tester);

    await tester.tap(find.text('Button').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text(
        'Displays a button or a component that looks like a button. '
        'Six variants share one API: pick the one matching the '
        "action's weight.",
      ),
      findsOneWidget,
    );
    expect(find.text('Open playground'), findsOneWidget);
  });

  testWidgets('the search box filters the sidebar', (tester) async {
    await pumpShell(tester);
    await openComponents(tester);

    await tester.enterText(find.byType(ShadInput).first, 'badge');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Badge'), findsWidgets);
    expect(find.text('Accordion'), findsNothing);
  });

  group('the theme editor toggle', () {
    Future<void> toggle(WidgetTester tester) async {
      await tester.tap(find.byIcon(LucideIcons.paintbrush).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }

    testWidgets('docks the panel beside the page, and closes again', (
      tester,
    ) async {
      await pumpShell(tester);
      await toggle(tester);

      expect(find.byType(ThemeCustomizerPanel), findsOneWidget);
      // Docked, not covering: the page is still there beside it.
      expect(find.byType(ThemePreviewPanel), findsOneWidget);
      expect(
        tester.getSize(find.byType(ThemeCustomizerPanel)).width,
        ThemeCustomizerPanel.width,
      );

      await toggle(tester);
      expect(find.byType(ThemeCustomizerPanel), findsNothing);
    });

    testWidgets('stays available on the components section', (tester) async {
      await pumpShell(tester);
      await openComponents(tester);
      await toggle(tester);

      expect(find.byType(ThemeCustomizerPanel), findsOneWidget);
      expect(find.byType(ShadSidebar), findsOneWidget);
      expect(find.text('Style'), findsOneWidget);
    });

    testWidgets('opening it keeps the page you were on', (tester) async {
      // Building the page conditionally around the panel used to drop the
      // docs browser's State, which sent you back to the first component
      // every time the editor was opened.
      await pumpShell(tester);
      await openComponents(tester);
      await tester.tap(find.text('Badge').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await toggle(tester);

      expect(find.byType(ThemeCustomizerPanel), findsOneWidget);
      expect(
        find.text('Displays a badge or a component that looks like a badge.'),
        findsOneWidget,
      );
    });

    testWidgets('fills a narrow viewport', (tester) async {
      await pumpShell(tester, size: const Size(600, 1000));
      await toggle(tester);

      final panel = find.byType(ThemeCustomizerPanel);
      expect(panel, findsOneWidget);
      expect(tester.getSize(panel).width, 600);
      // The page stays in the tree underneath — covered, not discarded, so
      // closing the panel brings back the page you were on.
      expect(find.byType(ThemePreviewPanel), findsOneWidget);
      // The toggle is still reachable above it.
      expect(find.text('Playground'), findsOneWidget);
    });
  });
}
