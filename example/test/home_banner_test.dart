import 'package:disco/disco.dart';
import 'package:example/main.dart';
import 'package:example/pages/theme_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        providers: [themeModeProvider, directionalityProvider],
        child: ShadApp(routes: routes, home: const MainPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the home page features the theme editor', (tester) async {
    await pumpHome(tester);

    expect(find.text('Theme Editor'), findsWidgets);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('the Open button navigates to the editor', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text('Open'));
    // The editor's preview contains a spinner and skeletons, which animate
    // forever, so pump fixed frames rather than pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ThemeEditorPage), findsOneWidget);
  });

  testWidgets('the editor is still reachable through search', (tester) async {
    await pumpHome(tester);

    // The banner is a shortcut, not a replacement: the route stays in the
    // searchable list so typing "theme" still finds it.
    await tester.enterText(find.byType(ShadInput).first, 'theme');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    await tester.tap(find.byType(ListTile));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ThemeEditorPage), findsOneWidget);
  });
}
