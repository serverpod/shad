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
        child: ClipRRect(
          borderRadius: theme.radii.lg,
          child: ShadSidebarScaffold(
            sidebar: ShadSidebar(
              collapsible: ShadSidebarCollapsible.icon,
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
      ),
    );
  }
}
