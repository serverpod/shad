import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/sheet.dart';
import 'package:shad/src/components/sidebar.dart';
import 'package:shad/src/theme/theme.dart';

void main() {
  // Wider than the md breakpoint, so the sidebar renders inline.
  const desktopSize = Size(1200, 800);

  Widget createTestWidget({
    ShadSidebarController? controller,
    ShadSidebarCollapsible collapsible = ShadSidebarCollapsible.offcanvas,
    ShadSidebarVariant variant = ShadSidebarVariant.sidebar,
    List<Widget> children = const [],
    Widget? header,
    Widget? footer,
    Widget child = const Text('content'),
  }) {
    return ShadApp(
      home: Scaffold(
        body: ShadSidebarScaffold(
          controller: controller,
          sidebar: ShadSidebar(
            collapsible: collapsible,
            variant: variant,
            header: header,
            footer: footer,
            children: children,
          ),
          child: child,
        ),
      ),
    );
  }

  Future<void> pumpDesktop(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = desktopSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(widget);
  }

  group('ShadSidebar', () {
    testWidgets('renders header, groups and footer', (tester) async {
      await pumpDesktop(
        tester,
        createTestWidget(
          header: const Text('Acme'),
          footer: const Text('Account'),
          children: [
            ShadSidebarGroup(
              label: const Text('Platform'),
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Acme'), findsOneWidget);
      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('lays out at the theme width', (tester) async {
      await pumpDesktop(tester, createTestWidget());
      final theme = ShadTheme.of(
        tester.element(find.byType(ShadSidebarScaffold)),
      );
      expect(
        tester.getSize(find.byType(ShadSidebar)).width,
        theme.sidebarTheme.width,
      );
    });

    testWidgets('offcanvas collapse animates the width to zero', (
      tester,
    ) async {
      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await pumpDesktop(tester, createTestWidget(controller: controller));

      controller.open = false;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.getSize(find.byType(ShadSidebar)).width, 0);
    });

    testWidgets('icon collapse stops at the collapsed width', (tester) async {
      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await pumpDesktop(
        tester,
        createTestWidget(
          controller: controller,
          collapsible: ShadSidebarCollapsible.icon,
        ),
      );

      controller.open = false;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final theme = ShadTheme.of(
        tester.element(find.byType(ShadSidebarScaffold)),
      );
      expect(
        tester.getSize(find.byType(ShadSidebar)).width,
        theme.sidebarTheme.collapsedWidth,
      );
    });

    testWidgets('the trigger toggles the controller', (tester) async {
      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await pumpDesktop(
        tester,
        createTestWidget(
          controller: controller,
          child: const ShadSidebarTrigger(),
        ),
      );

      expect(controller.open, isTrue);
      await tester.tap(find.byType(ShadSidebarTrigger));
      await tester.pump();
      expect(controller.open, isFalse);
    });

    testWidgets('menu button onPressed fires and isActive highlights', (
      tester,
    ) async {
      var pressed = false;
      await pumpDesktop(
        tester,
        createTestWidget(
          children: [
            ShadSidebarGroup(
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      isActive: true,
                      onPressed: () => pressed = true,
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      await tester.tap(find.text('Home'));
      expect(pressed, isTrue);

      // The active row keeps the sidebar accent as its fill.
      final theme = ShadTheme.of(
        tester.element(find.byType(ShadSidebarScaffold)),
      );
      final containers = tester.widgetList<AnimatedContainer>(
        find.descendant(
          of: find.byType(ShadSidebarMenuButton),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final hasAccentFill = containers.any((c) {
        final decoration = c.decoration;
        return decoration is BoxDecoration &&
            decoration.color == theme.colorScheme.sidebarAccent;
      });
      expect(hasAccentFill, isTrue);
    });

    testWidgets('sub-menus hide in the icon rail', (tester) async {
      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await pumpDesktop(
        tester,
        createTestWidget(
          controller: controller,
          collapsible: ShadSidebarCollapsible.icon,
          children: [
            ShadSidebarGroup(
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      onPressed: () {},
                      child: const Text('Docs'),
                    ),
                    ShadSidebarMenuSub(
                      children: [
                        ShadSidebarMenuSubButton(
                          onPressed: () {},
                          child: const Text('Installation'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Installation'), findsOneWidget);

      controller.open = false;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Installation'), findsNothing);
    });

    testWidgets('below the breakpoint the sidebar is not inline', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestWidget(
          children: [
            ShadSidebarGroup(
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Home'), findsNothing);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('the trigger opens the mobile sheet as a drawer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        createTestWidget(
          controller: controller,
          collapsible: ShadSidebarCollapsible.icon,
          children: [
            ShadSidebarGroup(
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      leading: const Icon(Icons.home),
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ],
          child: const Row(children: [ShadSidebarTrigger()]),
        ),
      );
      await tester.pump();

      // A real mouse, so the trigger's MouseRegion and the sheet's route
      // interact the way they do on desktop — this used to cascade into a
      // mouse_tracker assertion when the sheet gave the sidebar's Expanded
      // column unbounded height.
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(ShadSidebarTrigger)));
      await tester.pump();
      await gesture.down(tester.getCenter(find.byType(ShadSidebarTrigger)));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
      expect(controller.openMobile, isTrue);
      expect(find.byType(ShadSheet), findsOneWidget);
      // The sheet shows the full sidebar, never the icon rail.
      expect(find.text('Home'), findsOneWidget);

      // Closing through the controller pops the sheet again.
      controller.openMobile = false;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the icon rail truncates content that cannot shrink', (
      tester,
    ) async {
      // A plain Row header (logo + gap + label) and a skeleton row know
      // nothing about collapsing. In CSS they would just be clipped by
      // overflow-hidden; the sidebar reproduces that by laying content out at
      // the expanded width, so neither may throw a RenderFlex overflow.
      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await pumpDesktop(
        tester,
        createTestWidget(
          controller: controller,
          collapsible: ShadSidebarCollapsible.icon,
          header: Row(
            children: [
              Container(width: 32, height: 32, color: const Color(0xFF000000)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Acme Inc', maxLines: 1, softWrap: false),
              ),
            ],
          ),
          children: [
            ShadSidebarGroup(
              label: const Text('Platform'),
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      leading: const Icon(Icons.home),
                      trailing: const Icon(Icons.chevron_right),
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                    const ShadSidebarMenuSkeleton(showIcon: true),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      controller.open = false;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);

      // ...and back out again, which used to overflow while the trailing
      // chevron reappeared before the width had grown to fit it.
      controller.open = true;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('collapsed menu buttons are squares at the start edge', (
      tester,
    ) async {
      final controller = ShadSidebarController(open: false);
      addTearDown(controller.dispose);
      await pumpDesktop(
        tester,
        createTestWidget(
          controller: controller,
          collapsible: ShadSidebarCollapsible.icon,
          children: [
            ShadSidebarGroup(
              children: [
                ShadSidebarMenu(
                  children: [
                    ShadSidebarMenuButton(
                      leading: const Icon(Icons.home),
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // `size-8! p-2!`: rail 48 minus the group's p-2 → a 32px square.
      final theme = ShadTheme.of(
        tester.element(find.byType(ShadSidebarScaffold)),
      );
      final collapsedWidth = theme.sidebarTheme.collapsedWidth ?? 48;
      final button = find.descendant(
        of: find.byType(ShadSidebarMenuButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(
        tester.getSize(button.first),
        Size.square(collapsedWidth - 16),
      );
      // Flush with the rail's padding, not centered in the expanded width.
      expect(
        tester.getTopLeft(button.first).dx,
        tester.getTopLeft(find.byType(ShadSidebar)).dx + 8,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping the barrier closes the mobile drawer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(createTestWidget(controller: controller));
      await tester.pump();

      controller.openMobile = true;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsOneWidget);

      // Well clear of the 288px drawer.
      await tester.tapAt(const Offset(450, 400));
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsNothing);
      // ...and the controller learned about it, so the trigger reopens.
      expect(controller.openMobile, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an open drawer survives nothing: unmounting the scaffold '
        'removes it without touching the dead state', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      final show = ValueNotifier<bool>(true);
      addTearDown(show.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: show,
            builder: (context, value, _) => value
                ? ShadSidebarScaffold(
                    controller: controller,
                    sidebar: const ShadSidebar(children: [Text('menu')]),
                    child: const Text('content'),
                  )
                : const Text('gone'),
          ),
        ),
      );
      await tester.pump();

      controller.openMobile = true;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsOneWidget);

      // Swap the scaffold out from under its open drawer, then change the
      // window metrics: the route's builder re-runs on MediaQuery changes
      // and used to reach into the unmounted State's context.
      show.value = false;
      await tester.pump();
      tester.view.physicalSize = const Size(400, 700);
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
      // The drawer went down with its scaffold, as unmounting the provider
      // does in the reference.
      expect(find.byType(ShadSheet), findsNothing);
    });

    testWidgets('growing past the breakpoint closes the mobile sheet', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = ShadSidebarController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(createTestWidget(controller: controller));
      await tester.pump();

      controller.openMobile = true;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsOneWidget);

      // Resize to desktop: the drawer belongs to the mobile layout and goes
      // with it, as unmounting does in the reference.
      tester.view.physicalSize = desktopSize;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ShadSheet), findsNothing);
      expect(controller.openMobile, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('borderRadius clips the embedded scaffold', (tester) async {
      await pumpDesktop(
        tester,
        ShadApp(
          home: Center(
            child: SizedBox(
              width: 700,
              height: 400,
              child: ShadSidebarScaffold(
                borderRadius: BorderRadius.circular(12),
                sidebar: const ShadSidebar(),
                child: const Text('content'),
              ),
            ),
          ),
        ),
      );

      final clip = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(ShadSidebarScaffold),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(clip.borderRadius, BorderRadius.circular(12));
    });
  });

  group('ShadSidebar.scrollController', () {
    testWidgets('drives the content area between header and footer', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await pumpDesktop(
        tester,
        ShadApp(
          home: Scaffold(
            body: ShadSidebarScaffold(
              sidebar: ShadSidebar(
                scrollController: controller,
                header: const Text('Header'),
                children: [
                  for (var group = 0; group < 20; group++)
                    ShadSidebarGroup(
                      label: Text('Group $group'),
                      children: [
                        ShadSidebarMenu(
                          children: [
                            for (var item = 0; item < 4; item++)
                              ShadSidebarMenuButton(
                                onPressed: () {},
                                child: Text('Item $group.$item'),
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              child: const Text('content'),
            ),
          ),
        ),
      );

      expect(controller.hasClients, isTrue);
      expect(controller.offset, 0);

      controller.jumpTo(200);
      await tester.pump();
      expect(controller.offset, 200);

      // The header is pinned outside the scrolled region.
      expect(tester.getTopLeft(find.text('Header')).dy, lessThan(50));
      // And ensureVisible reaches the content through the same scrollable.
      await Scrollable.ensureVisible(
        tester.element(find.text('Group 19', skipOffstage: false)),
      );
      await tester.pump();
      expect(controller.offset, greaterThan(200));
    });
  });
}
