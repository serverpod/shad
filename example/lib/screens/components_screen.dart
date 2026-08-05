import 'package:example/docs/docs.dart';
import 'package:example/docs/registry.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

/// The documentation browser: a [ShadSidebar] of every component next to the
/// selected component's doc page.
class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({super.key, this.initialSlug});

  final String? initialSlug;

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  late String selectedSlug =
      widget.initialSlug ?? docGroups.first.items.first.slug;
  String query = '';

  ComponentDoc get selectedDoc {
    for (final group in docGroups) {
      for (final doc in group.items) {
        if (doc.slug == selectedSlug) return doc;
      }
    }
    return docGroups.first.items.first;
  }

  List<DocGroup> get filteredGroups {
    if (query.isEmpty) return docGroups;
    final q = query.toLowerCase();
    return [
      for (final group in docGroups)
        if (group.items.any((d) => d.title.toLowerCase().contains(q)))
          DocGroup(
            title: group.title,
            items: [
              for (final doc in group.items)
                if (doc.title.toLowerCase().contains(q)) doc,
            ],
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final doc = selectedDoc;

    return ShadSidebarScaffold(
      sidebar: ShadSidebar(
        rail: true,
        header: ShadInput(
          placeholder: const Text('Search components'),
          leading: const Icon(LucideIcons.search),
          onChanged: (value) => setState(() => query = value),
        ),
        children: [
          for (final group in filteredGroups)
            ShadSidebarGroup(
              label: Text(group.title),
              children: [
                ShadSidebarMenu(
                  children: [
                    for (final item in group.items)
                      ShadSidebarMenuButton(
                        isActive: item.slug == doc.slug,
                        onPressed: () =>
                            setState(() => selectedSlug = item.slug),
                        child: Text(item.title),
                      ),
                  ],
                ),
              ],
            ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.border),
              ),
            ),
            child: Row(
              children: [
                const ShadSidebarTrigger(),
                const SizedBox(width: 8),
                const SizedBox(
                  height: 16,
                  child: ShadSeparator.vertical(margin: EdgeInsets.zero),
                ),
                const SizedBox(width: 12),
                ShadBreadcrumb(
                  children: [
                    Text('Components', style: theme.textTheme.muted),
                    Text(doc.title),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: ComponentDocPage(doc: doc)),
        ],
      ),
    );
  }
}
