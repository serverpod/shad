import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
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
  });
}
