import 'package:disco/disco.dart';
import 'package:example/common/app_shell.dart';
import 'package:example/main.dart';
import 'package:example/pages/theme_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        providers: [themeModeProvider, directionalityProvider],
        child: const ShadApp(home: AppShell()),
      ),
    );
    // Doc previews contain spinners and skeletons that animate forever, so
    // pump fixed frames rather than pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('the shell shows the top navigation and the docs browser', (
    tester,
  ) async {
    await pumpShell(tester);

    expect(find.text('shadcn_ui'), findsOneWidget);
    expect(find.text('Components'), findsWidgets);
    expect(find.text('Theme Editor'), findsOneWidget);
    // The sidebar lists the components; Typography is the first entry.
    expect(find.byType(ShadSidebar), findsOneWidget);
    expect(find.text('Typography'), findsWidgets);
  });

  testWidgets('selecting a component in the sidebar opens its doc page', (
    tester,
  ) async {
    await pumpShell(tester);

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

    await tester.enterText(find.byType(ShadInput).first, 'badge');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Badge'), findsWidgets);
    expect(find.text('Accordion'), findsNothing);
  });

  testWidgets('the Theme Editor link switches sections', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Theme Editor'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ThemeEditorView), findsOneWidget);
  });
}
