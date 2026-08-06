# Sidebar

A composable, collapsible side navigation panel. Collapses to an icon rail or off-canvas, floats or insets, and becomes a modal sheet under the mobile breakpoint. ⌘B toggles it.

## Icon rail

With collapsible: icon the sidebar shrinks to a rail of icons. Menu buttons show their label as a tooltip, and with rail: true the inner edge becomes a grab rail — click it to toggle. This docs app itself runs on ShadSidebarScaffold.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SidebarBasicExample extends StatefulWidget {
  const SidebarBasicExample({super.key});

  @override
  State<SidebarBasicExample> createState() => _SidebarBasicExampleState();
}

class _SidebarBasicExampleState extends State<SidebarBasicExample> {
  String selected = 'Home';

  ShadSidebarMenuButton item(String label, IconData icon) {
    return ShadSidebarMenuButton(
      leading: Icon(icon),
      isActive: selected == label,
      tooltip: label,
      onPressed: () => setState(() => selected = label),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 700,
      height: 420,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: theme.radii.lg,
        ),
        child: ShadSidebarScaffold(
          borderRadius: theme.radii.lg,
          sidebar: ShadSidebar(
            collapsible: ShadSidebarCollapsible.icon,
            // The inner edge highlights under the pointer and toggles the
            // sidebar on click.
            rail: true,
            header: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: theme.radii.md,
                  ),
                  child: Icon(
                    LucideIcons.galleryVerticalEnd,
                    size: 16,
                    color: theme.colorScheme.primaryForeground,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Acme Inc',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: theme.textTheme.small,
                  ),
                ),
              ],
            ),
            footer: ShadSidebarMenuButton(
              leading: const Icon(LucideIcons.circleUser),
              trailing: const Icon(LucideIcons.chevronsUpDown),
              tooltip: 'Account',
              onPressed: () {},
              child: const Text('shadcn'),
            ),
            children: [
              ShadSidebarGroup(
                label: const Text('Platform'),
                children: [
                  ShadSidebarMenu(
                    children: [
                      item('Home', LucideIcons.house),
                      item('Inbox', LucideIcons.inbox),
                      item('Calendar', LucideIcons.calendar),
                    ],
                  ),
                ],
              ),
              ShadSidebarGroup(
                label: const Text('Settings'),
                children: [
                  ShadSidebarMenu(
                    children: [
                      item('Profile', LucideIcons.user),
                      item('Billing', LucideIcons.creditCard),
                    ],
                  ),
                ],
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const ShadSidebarTrigger(),
                    const SizedBox(width: 8),
                    Text(selected, style: theme.textTheme.small),
                  ],
                ),
              ),
              const Expanded(
                child: Center(child: Text('Content area')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Floating, with sub-menus

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SidebarSubmenuExample extends StatefulWidget {
  const SidebarSubmenuExample({super.key});

  @override
  State<SidebarSubmenuExample> createState() => _SidebarSubmenuExampleState();
}

class _SidebarSubmenuExampleState extends State<SidebarSubmenuExample> {
  String selected = 'Installation';

  static const _sections = {
    'Getting Started': ['Installation', 'Project Structure'],
    'Building Your Application': ['Routing', 'Data Fetching', 'Rendering'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 700,
      height: 420,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: theme.radii.lg,
        ),
        child: ShadSidebarScaffold(
          borderRadius: theme.radii.lg,
          sidebar: ShadSidebar(
            variant: ShadSidebarVariant.floating,
            children: [
              ShadSidebarGroup(
                label: const Text('Documentation'),
                children: [
                  ShadSidebarMenu(
                    children: [
                      for (final entry in _sections.entries) ...[
                        ShadSidebarMenuButton(
                          leading: const Icon(LucideIcons.bookOpen),
                          onPressed: () {},
                          child: Text(entry.key),
                        ),
                        ShadSidebarMenuSub(
                          children: [
                            for (final page in entry.value)
                              ShadSidebarMenuSubButton(
                                isActive: selected == page,
                                onPressed: () =>
                                    setState(() => selected = page),
                                child: Text(page),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          child: Center(child: Text(selected)),
        ),
      ),
    );
  }
}
```

