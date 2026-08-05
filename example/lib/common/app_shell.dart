import 'package:example/main.dart';
import 'package:example/pages/theme_editor.dart';
import 'package:example/screens/components_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shad/shad.dart';

enum AppSection { components, themeEditor }

/// The application frame: a shadcn-style top navigation bar over the current
/// section. Both sections stay alive in an [IndexedStack], so switching back
/// and forth keeps scroll position and editor state.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppSection section = AppSection.components;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _TopNav(
            section: section,
            onSelect: (value) => setState(() => section = value),
          ),
          Expanded(
            child: IndexedStack(
              index: section.index,
              children: const [
                ComponentsScreen(),
                ThemeEditorView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav({required this.section, required this.onSelect});

  final AppSection section;
  final ValueChanged<AppSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Row(
        children: [
          // Wordmark.
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: theme.radii.sm,
            ),
            child: Icon(
              LucideIcons.layoutDashboard,
              size: 14,
              color: theme.colorScheme.primaryForeground,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'shad',
            style: theme.textTheme.large.copyWith(fontSize: 15),
          ),
          const SizedBox(width: 28),
          _NavLink(
            label: 'Components',
            selected: section == AppSection.components,
            onTap: () => onSelect(AppSection.components),
          ),
          const SizedBox(width: 20),
          _NavLink(
            label: 'Theme Editor',
            selected: section == AppSection.themeEditor,
            onTap: () => onSelect(AppSection.themeEditor),
          ),
          const Spacer(),
          const _ThemeModeButton(),
          const SizedBox(width: 4),
          const _DirectionButton(),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = widget.selected || hovered
        ? theme.colorScheme.foreground
        : theme.colorScheme.mutedForeground;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: theme.textTheme.small.copyWith(color: color),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, _) {
        final mode = themeModeProvider.of(context).value;
        final isLight = mode == ThemeMode.light;
        return ShadIconButton.ghost(
          icon: Icon(
            isLight ? LucideIcons.sun : LucideIcons.moon,
            semanticLabel: isLight
                ? 'Switch to dark mode'
                : 'Switch to light mode',
          ),
          onPressed: () {
            themeModeProvider
                .of(context)
                .updateValue(
                  (value) => value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
          },
        );
      },
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton();

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, _) {
        final direction = directionalityProvider.of(context).value;
        final isLtr = direction == TextDirection.ltr;
        return ShadIconButton.ghost(
          icon: Icon(
            isLtr
                ? Icons.format_textdirection_r_to_l
                : Icons.format_textdirection_l_to_r,
            semanticLabel: isLtr ? 'Switch to RTL' : 'Switch to LTR',
          ),
          onPressed: () {
            directionalityProvider
                .of(context)
                .updateValue(
                  (value) => value == TextDirection.ltr
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                );
          },
        );
      },
    );
  }
}
