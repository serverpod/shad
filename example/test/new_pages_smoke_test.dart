import 'package:disco/disco.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Renders every page added for the 0.57.0 components.
///
/// These pages are only reachable by navigating the example app, so without
/// this a broken page would go unnoticed until someone opened it by hand.
void main() {
  const newRoutes = [
    '/collapsible',
    '/command',
    '/data-table',
    '/empty',
    '/kbd',
    '/layout',
    '/pagination',
    '/skeleton',
    '/spinner',
    '/toggle',
    '/toggle-group',
  ];

  for (final route in newRoutes) {
    testWidgets('$route builds', (tester) async {
      // Wide enough for BaseScaffold's resizable two-pane layout.
      tester.view.physicalSize = const Size(1400, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final builder = routes[route];
      expect(builder, isNotNull, reason: '$route is not registered');

      await tester.pumpWidget(
        // BaseScaffold's app bar reads the theme-mode and directionality
        // signals, so the page needs the same ProviderScope main() sets up.
        ProviderScope(
          providers: [themeModeProvider, directionalityProvider],
          child: ShadApp(home: Builder(builder: builder!)),
        ),
      );
      // Skeleton and Spinner animate forever, so pump fixed frames rather
      // than pumpAndSettle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('every new component page is registered', (tester) async {
    for (final route in newRoutes) {
      expect(routes.containsKey(route), isTrue, reason: 'missing $route');
    }
  });
}
