import 'package:example/main.dart';
import 'package:example/screens/components_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shad/shad.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const App());
    // Fixed pumps: the playground stays alive in the IndexedStack and hosts
    // forever-animating previews, so pumpAndSettle would never return.
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// The offset of the docs sidebar's content area — the one scrollable
  /// under the sidebar with anywhere to go (the search field nests its own,
  /// extentless one).
  double sidebarOffset(WidgetTester tester) {
    final scrollable = find.descendant(
      of: find.byType(ShadSidebar),
      matching: find.byType(Scrollable),
    );
    return tester
        .stateList<ScrollableState>(scrollable)
        .firstWhere((s) => s.position.maxScrollExtent > 0)
        .position
        .pixels;
  }

  testWidgets('Docs opens the written pages, Components the reference', (
    tester,
  ) async {
    await pumpApp(tester);

    // Docs: lands on the Introduction page, sidebar at the top.
    await tester.tap(find.text('Docs'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Getting started'), findsWidgets);
    expect(
      find.textContaining('shad is a Flutter implementation'),
      findsOneWidget,
    );
    expect(sidebarOffset(tester), 0);

    // Components: opens the overview page and scrolls the sidebar down to the
    // Components section.
    await tester.tap(find.text('Components').first);
    // Three pumps: the reveal is scheduled post-frame, its animation ticks
    // from the following frame, and completes on the one after.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    final state = tester.state<ComponentsScreenState>(
      find.byType(ComponentsScreen),
    );
    expect(state.selectedSlug, 'overview');
    expect(sidebarOffset(tester), greaterThan(0));

    // Back to Docs: Introduction again, scrolled back up.
    await tester.tap(find.text('Docs'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(state.selectedSlug, 'introduction');
    expect(sidebarOffset(tester), 0);
  });

  testWidgets('the breadcrumb names the section of the open page', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Docs'));
    await tester.pump(const Duration(milliseconds: 400));

    // Breadcrumb: "Getting started / Introduction".
    final state = tester.state<ComponentsScreenState>(
      find.byType(ComponentsScreen),
    );
    expect(state.selectedGroup.title, 'Getting started');

    // Selecting a page in another group moves the breadcrumb with it.
    await tester.tap(find.text('Typography'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(state.selectedGroup.title, 'Foundations');
    expect(find.text('Foundations'), findsWidgets);
  });
}
