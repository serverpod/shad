import 'package:example/docs/docs.dart';
import 'package:example/screens/components_screen.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

/// A grid of every component doc page — the landing page for the Components
/// section.
class ComponentsOverview extends StatelessWidget {
  const ComponentsOverview({super.key, required this.components});

  final List<ComponentDoc> components;

  void _open(BuildContext context, String slug) {
    context.findAncestorStateOfType<ComponentsScreenState>()?.open(slug);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final columns = constraints.maxWidth >= 480 ? 3 : 1;
        final tileWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 4,
          children: [
            for (final doc in components)
              SizedBox(
                width: tileWidth,
                child: _ComponentLink(
                  title: doc.title,
                  description: doc.description,
                  onPressed: () => _open(context, doc.slug),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ComponentLink extends StatefulWidget {
  const _ComponentLink({
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  State<_ComponentLink> createState() => _ComponentLinkState();
}

class _ComponentLinkState extends State<_ComponentLink> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final titleColor = hovered
        ? theme.colorScheme.primary
        : theme.colorScheme.foreground;

    return SelectionContainer.disabled(
      child: MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.large.copyWith(color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  style: theme.textTheme.muted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
