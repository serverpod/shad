import 'package:example/common/theme_editor/customizer_panel.dart';
import 'package:example/main.dart';
import 'package:example/screens/components_screen.dart';
import 'package:example/screens/playground_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shad/shad.dart';

enum AppSection { playground, components }

/// The application frame: a shadcn-style top navigation bar over the current
/// section, with the theme customizer docked beside it when it is open. Both
/// sections stay alive in an [IndexedStack], so switching back and forth keeps
/// scroll position and page state.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppSection section = AppSection.playground;

  /// Below this the docked panel would leave the app too narrow to use, so it
  /// takes the viewport instead.
  static const _narrow = 700.0;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, _) {
        final openSignal = themeEditorOpenProvider.of(context);
        final configSignal = themeConfigProvider.of(context);
        // Read both here rather than inside the LayoutBuilder below: that
        // callback runs during layout, outside the scope SignalBuilder
        // tracks, so a read in there never subscribes.
        final open = openSignal.value;
        final config = configSignal.value;

        ThemeCustomizerPanel panel({required bool showLeadingBorder}) =>
            ThemeCustomizerPanel(
              config: config,
              onChanged: (next) => configSignal.value = next,
              onClose: () => openSignal.value = false,
              showLeadingBorder: showLeadingBorder,
            );

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < _narrow;
              final body = IndexedStack(
                index: section.index,
                children: const [PlaygroundScreen(), ComponentsScreen()],
              );

              return Column(
                children: [
                  _TopNav(
                    section: section,
                    onSelect: (value) => setState(() => section = value),
                  ),
                  // The page is always the first child of both the Stack and
                  // the Row, so opening the panel never reshapes the element
                  // above it. Building it conditionally instead threw away
                  // the docs browser's state — which read as "the editor does
                  // not affect this page", since it also bounced you back to
                  // the first component.
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Row(
                            children: [
                              Expanded(child: body),
                              if (open && !narrow)
                                SizedBox(
                                  width: ThemeCustomizerPanel.width,
                                  child: panel(showLeadingBorder: true),
                                ),
                            ],
                          ),
                        ),
                        // Narrow: the panel covers the page rather than
                        // squeezing it. The top navigation stays put, so its
                        // toggle is still there to close it again.
                        if (open && narrow)
                          Positioned.fill(
                            child: panel(showLeadingBorder: false),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On a phone-width viewport the wordmark's text is the first thing
          // to go: the links and the toolbar have to stay reachable.
          final compact = constraints.maxWidth < 480;

          return Row(
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
              if (!compact) ...[
                const SizedBox(width: 8),
                Text(
                  'shad',
                  style: theme.textTheme.large.copyWith(fontSize: 15),
                ),
              ],
              SizedBox(width: compact ? 16 : 28),
              _NavLink(
                label: 'Playground',
                selected: section == AppSection.playground,
                onTap: () => onSelect(AppSection.playground),
              ),
              SizedBox(width: compact ? 12 : 20),
              _NavLink(
                label: 'Components',
                selected: section == AppSection.components,
                onTap: () => onSelect(AppSection.components),
              ),
              const Spacer(),
              const _ThemeEditorButton(),
              const SizedBox(width: 4),
              const _ThemeModeButton(),
              const SizedBox(width: 4),
              const _DirectionButton(),
            ],
          );
        },
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

/// Shows and hides the customizer, from either section.
class _ThemeEditorButton extends StatelessWidget {
  const _ThemeEditorButton();

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, _) {
        final open = themeEditorOpenProvider.of(context);
        final icon = Icon(
          LucideIcons.palette,
          semanticLabel: open.value
              ? 'Hide the theme editor'
              : 'Show the theme editor',
        );
        void toggle() => open.value = !open.value;

        // The pressed-in secondary variant is what marks the panel as open.
        return open.value
            ? ShadIconButton.secondary(icon: icon, onPressed: toggle)
            : ShadIconButton.ghost(icon: icon, onPressed: toggle);
      },
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
            // Lucide's pilcrow pair is its text-direction icon.
            isLtr ? LucideIcons.pilcrowRight : LucideIcons.pilcrowLeft,
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
