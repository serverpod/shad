import 'package:example/docs/docs.dart';
import 'package:example/docs/registry.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

/// The documentation browser: a [ShadSidebar] of every doc page next to the
/// selected page.
class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({
    super.key,
    this.initialSlug,
    this.onSelectionChanged,
  });

  final String? initialSlug;

  /// Called with the sidebar group of the newly selected page, so the shell
  /// can mirror the section in its top navigation.
  final ValueChanged<DocGroup>? onSelectionChanged;

  @override
  State<ComponentsScreen> createState() => ComponentsScreenState();
}

class ComponentsScreenState extends State<ComponentsScreen> {
  late String selectedSlug =
      widget.initialSlug ?? docGroups.first.items.first.slug;
  String query = '';

  final _sidebarScrollController = ScrollController();

  /// One stable key per sidebar group, so [open] can bring the selected
  /// page's section into view.
  final _groupKeys = {for (final group in docGroups) group.title: GlobalKey()};

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    super.dispose();
  }

  ComponentDoc get selectedDoc => selectedGroup.items.firstWhere(
    (doc) => doc.slug == selectedSlug,
    orElse: () => docGroups.first.items.first,
  );

  /// The group the selected page belongs to.
  DocGroup get selectedGroup {
    for (final group in docGroups) {
      for (final doc in group.items) {
        if (doc.slug == selectedSlug) return group;
      }
    }
    return docGroups.first;
  }

  /// Opens the page with [slug] and scrolls the sidebar until its section is
  /// in view — the top navigation drives this when a tab is chosen.
  void open(String slug) {
    _select(slug);
    // After this frame, so a pending rebuild (e.g. a cleared filter) has
    // laid the sidebar out before it scrolls.
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelectedGroup());
  }

  void _select(String slug) {
    setState(() => selectedSlug = slug);
    widget.onSelectionChanged?.call(selectedGroup);
  }

  void _revealSelectedGroup() {
    if (!mounted) return;
    final context = _groupKeys[selectedGroup.title]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      // The section's heading lands at the top of the sidebar, not merely
      // within reach.
      alignment: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
        scrollController: _sidebarScrollController,
        header: ShadInput(
          placeholder: const Text('Search docs'),
          leading: const Icon(LucideIcons.search),
          onChanged: (value) => setState(() => query = value),
        ),
        children: [
          for (final group in filteredGroups)
            ShadSidebarGroup(
              key: _groupKeys[group.title],
              label: Text(group.title),
              children: [
                ShadSidebarMenu(
                  children: [
                    for (final item in group.items)
                      ShadSidebarMenuButton(
                        isActive: item.slug == doc.slug,
                        onPressed: () => _select(item.slug),
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
                    Text(selectedGroup.title, style: theme.textTheme.muted),
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
