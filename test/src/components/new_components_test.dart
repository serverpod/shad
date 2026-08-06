import 'dart:ui' show Tristate;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  Widget wrap(Widget child) => ShadApp(home: Center(child: child));

  group('ShadSkeleton', () {
    testWidgets('renders at the requested size', (tester) async {
      await tester.pumpWidget(
        wrap(const ShadSkeleton(width: 200, height: 16, animate: false)),
      );
      final size = tester.getSize(find.byType(ShadSkeleton));
      expect(size, const Size(200, 16));
    });

    testWidgets('reads its color from the theme', (tester) async {
      await tester.pumpWidget(
        ShadApp(
          theme: ShadThemeData(
            colorScheme: const ShadSlateColorScheme.light(),
            brightness: Brightness.light,
            skeletonTheme: const ShadSkeletonTheme(
              color: Color(0xFF123456),
              animate: false,
            ),
          ),
          home: const Center(child: ShadSkeleton(width: 10, height: 10)),
        ),
      );
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(ShadSkeleton),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (box.decoration as BoxDecoration).color,
        const Color(0xFF123456),
      );
    });

    testWidgets('is hidden from semantics', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(const ShadSkeleton(width: 10, height: 10, animate: false)),
      );
      expect(find.byType(ExcludeSemantics), findsWidgets);
      handle.dispose();
    });
  });

  group('ShadSpinner', () {
    testWidgets('renders at the requested size and keeps animating', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ShadSpinner(size: 24)));
      expect(tester.getSize(find.byType(ShadSpinner)), const Size(24, 24));

      // A repeating animation never settles, so pump fixed frames instead of
      // pumpAndSettle (which would time out).
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });
  });

  group('ShadKbd', () {
    testWidgets('renders a single cap', (tester) async {
      await tester.pumpWidget(wrap(const ShadKbd('K')));
      expect(find.text('K'), findsOneWidget);
    });

    testWidgets('renders a group of caps', (tester) async {
      await tester.pumpWidget(wrap(const ShadKbd.group(['⌘', 'K'])));
      expect(find.text('⌘'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
    });
  });

  group('ShadToggle', () {
    testWidgets('calls onChanged with the flipped value', (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        wrap(
          ShadToggle(
            value: false,
            onChanged: changes.add,
            child: const Text('Bold'),
          ),
        ),
      );

      await tester.tap(find.byType(ShadToggle));
      await tester.pumpAndSettle();
      expect(changes, [true]);
    });

    testWidgets('does not fire when disabled', (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        wrap(
          ShadToggle(
            value: false,
            enabled: false,
            onChanged: changes.add,
            child: const Text('Bold'),
          ),
        ),
      );

      await tester.tap(find.byType(ShadToggle), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
    });

    testWidgets('outline uses the outline toggle theme', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShadToggle.outline(
            value: false,
            onChanged: (_) {},
            child: const Text('Bold'),
          ),
        ),
      );

      final theme = ShadTheme.of(
        tester.element(find.byType(ShadToggle)),
      );
      expect(theme.outlineToggleTheme.decoration?.border?.top?.width, 1);
      expect(theme.toggleTheme.decoration?.border?.top?.width, 0);
    });

    testWidgets('exposes its toggled state to semantics', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          ShadToggle(
            value: true,
            onChanged: (_) {},
            semanticLabel: 'Bold',
            child: const Text('B'),
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(ShadToggle));
      // The explicit label replaces the child's text rather than merging.
      expect(node.label, 'Bold');
      expect(node.flagsCollection.isButton, isTrue);
      // isToggled/isEnabled are tri-state: unset, true or false.
      expect(node.flagsCollection.isToggled, Tristate.isTrue);
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      handle.dispose();
    });
  });

  group('ShadToggleGroup', () {
    testWidgets('single variant replaces the selection', (tester) async {
      Set<String>? latest;
      await tester.pumpWidget(
        wrap(
          ShadToggleGroup<String>(
            values: const {'a'},
            onChanged: (v) => latest = v,
            children: const [
              ShadToggleGroupItem(value: 'a', child: Text('A')),
              ShadToggleGroupItem(value: 'b', child: Text('B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(latest, {'b'});
    });

    testWidgets('single variant deselects on re-tap', (tester) async {
      Set<String>? latest;
      await tester.pumpWidget(
        wrap(
          ShadToggleGroup<String>(
            values: const {'a'},
            onChanged: (v) => latest = v,
            children: const [
              ShadToggleGroupItem(value: 'a', child: Text('A')),
              ShadToggleGroupItem(value: 'b', child: Text('B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(latest, isEmpty);
    });

    testWidgets('multiple variant accumulates', (tester) async {
      Set<String>? latest;
      await tester.pumpWidget(
        wrap(
          ShadToggleGroup<String>.multiple(
            values: const {'a'},
            onChanged: (v) => latest = v,
            children: const [
              ShadToggleGroupItem(value: 'a', child: Text('A')),
              ShadToggleGroupItem(value: 'b', child: Text('B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(latest, {'a', 'b'});
    });
  });

  group('ShadCollapsible', () {
    testWidgets('hides content until opened', (tester) async {
      final controller = ShadCollapsibleController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          ShadCollapsible(
            controller: controller,
            child: const Text('Hidden'),
          ),
        ),
      );
      expect(find.text('Hidden'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Hidden'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('keeps content mounted with maintainState', (tester) async {
      final controller = ShadCollapsibleController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          ShadCollapsible(
            controller: controller,
            maintainState: true,
            child: const Text('Hidden'),
          ),
        ),
      );
      expect(find.text('Hidden'), findsOneWidget);
    });
  });

  group('ShadEmpty', () {
    testWidgets('falls back to a localized title', (tester) async {
      await tester.pumpWidget(wrap(const ShadEmpty()));
      expect(find.text('No results'), findsOneWidget);
    });

    testWidgets('renders icon, title, description and actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          ShadEmpty(
            icon: const Icon(LucideIcons.inbox),
            title: const Text('Nothing here'),
            description: const Text('Try again later.'),
            actions: [
              ShadButton(onPressed: () {}, child: const Text('Refresh')),
            ],
          ),
        ),
      );
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Try again later.'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.byIcon(LucideIcons.inbox), findsOneWidget);
    });
  });

  group('ShadPagination.buildPageWindow', () {
    test('returns every page when they all fit', () {
      expect(
        ShadPagination.buildPageWindow(page: 1, pageCount: 5),
        [1, 2, 3, 4, 5],
      );
    });

    test('inserts an ellipsis for a skipped run', () {
      expect(
        ShadPagination.buildPageWindow(page: 1, pageCount: 20),
        [1, 2, null, 20],
      );
    });

    test('windows around the current page', () {
      expect(
        ShadPagination.buildPageWindow(page: 10, pageCount: 20),
        [1, null, 9, 10, 11, null, 20],
      );
    });

    test('renders the page itself rather than hiding a single one', () {
      // A gap of exactly one page would make the ellipsis longer than the
      // number it replaces.
      expect(
        ShadPagination.buildPageWindow(page: 4, pageCount: 7),
        [1, 2, 3, 4, 5, 6, 7],
      );
    });

    test('handles the degenerate cases', () {
      expect(ShadPagination.buildPageWindow(page: 1, pageCount: 0), isEmpty);
      expect(ShadPagination.buildPageWindow(page: 1, pageCount: 1), [1]);
      // An out-of-range page is clamped rather than throwing.
      expect(
        ShadPagination.buildPageWindow(page: 99, pageCount: 3),
        [1, 2, 3],
      );
    });
  });

  group('ShadPagination', () {
    testWidgets('navigates with the previous/next buttons', (tester) async {
      final visited = <int>[];
      await tester.pumpWidget(
        wrap(
          ShadPagination(
            page: 5,
            pageCount: 20,
            onPageChanged: visited.add,
          ),
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(visited, [6]);

      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();
      expect(visited, [6, 4]);
    });

    testWidgets('does not go before the first page', (tester) async {
      final visited = <int>[];
      await tester.pumpWidget(
        wrap(
          ShadPagination(page: 1, pageCount: 5, onPageChanged: visited.add),
        ),
      );

      await tester.tap(find.text('Previous'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(visited, isEmpty);
    });

    testWidgets('jumps to a tapped page number', (tester) async {
      final visited = <int>[];
      await tester.pumpWidget(
        wrap(
          ShadPagination(page: 1, pageCount: 5, onPageChanged: visited.add),
        ),
      );

      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();
      expect(visited, [3]);
    });
  });
}
