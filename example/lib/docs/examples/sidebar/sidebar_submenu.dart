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
        child: ClipRRect(
          borderRadius: theme.radii.lg,
          child: ShadSidebarScaffold(
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
      ),
    );
  }
}
