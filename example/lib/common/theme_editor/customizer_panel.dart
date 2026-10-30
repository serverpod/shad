import 'package:example/common/theme_editor/editor_config.dart';
import 'package:example/common/theme_editor/fonts.dart';
import 'package:example/common/theme_editor/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shad/shad.dart';

/// shadcn/ui's `/create` customizer, as a panel docked beside the app.
///
/// It edits the configuration the whole app is themed from — the top
/// navigation, the playground and the docs browser all follow it. The panel
/// itself does not: it renders as fixed dark chrome at an unscaled text size,
/// because a panel that followed the configuration becomes unreadable while
/// editing a light, menu-inverted or heavily scaled theme.
class ThemeCustomizerPanel extends StatelessWidget {
  const ThemeCustomizerPanel({
    super.key,
    required this.config,
    required this.onChanged,
    this.showLeadingBorder = true,
  });

  final ThemeEditorConfig config;
  final ValueChanged<ThemeEditorConfig> onChanged;

  /// Drawn when the panel sits beside the app; dropped when it fills a narrow
  /// viewport and there is nothing to separate it from.
  final bool showLeadingBorder;

  /// Width of the docked panel on a wide viewport.
  static const width = 272.0;

  /// Chrome, not content: a fixed dark palette at a fixed text size, so the
  /// panel stays readable whatever the configuration under it does.
  ///
  /// Built once. The factory bakes ~54 component themes, and this one never
  /// varies, so rebuilding it per panel build was pure cost.
  static final _chrome = ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadNeutralColorScheme.dark(),
    radius: const BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return ShadThemeScope(
      data: _chrome,
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.noScaling),
        child: Builder(builder: _buildPanel),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    final theme = ShadTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: showLeadingBorder
            ? BorderDirectional(
                start: BorderSide(color: theme.colorScheme.border),
              )
            : null,
      ),
      child: Column(
        children: [
          Expanded(
            child: _Settings(config: config, onChanged: onChanged),
          ),
          _Actions(config: config, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({required this.config, required this.onChanged});

  final ThemeEditorConfig config;
  final ValueChanged<ThemeEditorConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    List<PickerOption<AccentColor>> accentOptions({AccentColor? inheritFrom}) =>
        [
          for (final accent in AccentColor.values)
            PickerOption(
              value: accent,
              label: accent.label,
              // "Base" inherits: for the theme picker from the base colour,
              // for the chart picker from whatever theme is selected.
              swatch: accent == AccentColor.base && inheritFrom != null
                  ? inheritFrom.swatch(
                      config.brightness,
                      config.baseColor,
                    )
                  : accent.swatch(config.brightness, config.baseColor),
            ),
        ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          ThemePicker<StylePreset>(
            label: 'Style',
            icon: LucideIcons.shapes,
            value: config.style,
            options: [
              for (final s in StylePreset.values)
                PickerOption(value: s, label: s.label),
            ],
            onChanged: (v) => onChanged(config.copyWith(style: v)),
          ),
          const _Separator(),
          ThemePicker<BaseColor>(
            label: 'Base Color',
            value: config.baseColor,
            options: [
              for (final b in BaseColor.values)
                PickerOption(
                  value: b,
                  label: b.label,
                  swatch: b.swatch,
                ),
            ],
            onChanged: (v) => onChanged(config.copyWith(baseColor: v)),
          ),
          ThemePicker<AccentColor>(
            label: 'Theme',
            value: config.accentColor,
            options: accentOptions(),
            onChanged: (v) => onChanged(config.copyWith(accentColor: v)),
          ),
          ThemePicker<AccentColor>(
            label: 'Chart Color',
            value: config.chartColor,
            options: accentOptions(inheritFrom: config.accentColor),
            onChanged: (v) => onChanged(config.copyWith(chartColor: v)),
          ),
          const _Separator(),
          _FontPicker(
            label: 'Heading',
            icon: LucideIcons.heading,
            value: config.headingFontTitle ?? _sameAsBody,
            includeSameAsBody: true,
            onLoaded: (v) => onChanged(
              v == _sameAsBody
                  ? config.copyWith(clearHeadingFont: true)
                  : config.copyWith(headingFontTitle: v),
            ),
          ),
          _FontPicker(
            label: 'Font',
            icon: LucideIcons.type,
            value: config.fontTitle,
            onLoaded: (v) => onChanged(config.copyWith(fontTitle: v)),
          ),
          const _Separator(),
          ThemePicker<RadiusPreset>(
            label: 'Radius',
            icon: LucideIcons.squareRoundCorner,
            value: config.radius,
            options: [
              for (final r in RadiusPreset.values)
                PickerOption(value: r, label: r.label),
            ],
            onChanged: (v) => onChanged(
              config.copyWith(radius: v, clearCustomRadius: true),
            ),
          ),
          const _Separator(),
          // One row, two radio groups — shadcn's Menu picker shape.
          ThemeGroupPicker(
            label: 'Menu',
            icon: LucideIcons.menu,
            value: '${config.menuColor.label} / ${config.menuFinish.label}',
            groups: [
              PickerGroup(
                label: 'Color',
                options: [for (final m in MenuSurfaceColor.values) m.label],
                selected: config.menuColor.label,
                onSelected: (v) => onChanged(
                  config.copyWith(
                    menuColor: MenuSurfaceColor.values.firstWhere(
                      (m) => m.label == v,
                    ),
                  ),
                ),
              ),
              PickerGroup(
                label: 'Surface',
                options: [for (final m in MenuSurfaceFinish.values) m.label],
                selected: config.menuFinish.label,
                onSelected: (v) => onChanged(
                  config.copyWith(
                    menuFinish: MenuSurfaceFinish.values.firstWhere(
                      (m) => m.label == v,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ThemePicker<MenuAccent>(
            label: 'Menu Accent',
            icon: LucideIcons.highlighter,
            // A translucent menu highlights with a foreground wash, so the
            // accent has no effect there; the picker is locked to make that
            // visible, as shadcn's editor does.
            value: config.menuFinish == MenuSurfaceFinish.solid
                ? config.menuAccent
                : MenuAccent.subtle,
            enabled: config.menuFinish == MenuSurfaceFinish.solid,
            options: [
              for (final m in MenuAccent.values)
                PickerOption(value: m, label: m.label),
            ],
            onChanged: (v) => onChanged(config.copyWith(menuAccent: v)),
          ),
          const _Separator(),
          ThemeSlider(
            label: 'Text Scale',
            icon: LucideIcons.aLargeSmall,
            value: config.textScale,
            min: .8,
            max: 1.6,
            fractionDigits: 2,
            onChanged: (v) => onChanged(config.copyWith(textScale: v)),
          ),
        ],
      ),
    );
  }

  static const _sameAsBody = 'Same as body';
}

class _Actions extends StatelessWidget {
  const _Actions({required this.config, required this.onChanged});

  final ThemeEditorConfig config;
  final ValueChanged<ThemeEditorConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        spacing: 8,
        children: [
          SizedBox(
            width: double.infinity,
            child: ShadButton(
              onPressed: () => _copy(context, config),
              leading: const Icon(LucideIcons.clipboard),
              child: const Text('Copy Theme'),
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ShadButton.outline(
                  onPressed: () => _showCode(context, config),
                  leading: const Icon(LucideIcons.code),
                  child: const Text('Code'),
                ),
              ),
              Expanded(
                child: ShadButton.outline(
                  onPressed: () => onChanged(const ThemeEditorConfig()),
                  leading: const Icon(LucideIcons.rotateCcw),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, ThemeEditorConfig config) async {
    await Clipboard.setData(ClipboardData(text: config.toDartSnippet()));
    if (!context.mounted) return;
    ShadSonner.of(context).show(
      const ShadToast(title: Text('Theme copied to clipboard')),
    );
  }

  void _showCode(BuildContext context, ThemeEditorConfig config) {
    final snippet = config.toDartSnippet();
    showShadDialog<void>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('ShadThemeData'),
        description: const Text(
          'Paste this into your ShadApp to reproduce the preview.',
        ),
        semanticLabel: 'Generated theme code',
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ShadButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: snippet));
              if (context.mounted) Navigator.of(context).pop();
            },
            leading: const Icon(LucideIcons.copy),
            child: const Text('Copy'),
          ),
        ],
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: SelectableText(
              snippet,
              style: ShadTheme.of(context).textTheme.small.copyWith(
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return const ShadSeparator.horizontal(
      margin: EdgeInsets.symmetric(vertical: 2),
    );
  }
}

/// A font [ThemePicker] that fetches the picked font before applying it.
///
/// Applying first and loading after would lay every control out in the
/// fallback face and then again when the real one arrives, so the text jumps
/// twice. Each option is listed in its own face.
class _FontPicker extends StatefulWidget {
  const _FontPicker({
    required this.label,
    required this.icon,
    required this.value,
    required this.onLoaded,
    this.includeSameAsBody = false,
  });

  final String label;
  final IconData icon;
  final String value;
  final ValueChanged<String> onLoaded;
  final bool includeSameAsBody;

  @override
  State<_FontPicker> createState() => _FontPickerState();
}

class _FontPickerState extends State<_FontPicker> {
  /// The title being loaded, if any. A newer pick supersedes an older one.
  String? loading;

  Future<void> pick(String title) async {
    if (title == _Settings._sameAsBody) {
      widget.onLoaded(title);
      return;
    }
    setState(() => loading = title);
    await EditorFont.byTitle(title).load();
    if (!mounted || loading != title) return;
    setState(() => loading = null);
    widget.onLoaded(title);
  }

  @override
  Widget build(BuildContext context) {
    return ThemePicker<String>(
      label: widget.label,
      icon: widget.icon,
      busy: loading != null,
      value: loading ?? widget.value,
      options: [
        if (widget.includeSameAsBody)
          const PickerOption(
            value: _Settings._sameAsBody,
            label: _Settings._sameAsBody,
          ),
        for (final f in EditorFont.all)
          PickerOption(
            value: f.title,
            label: f.title,
            labelStyle: f.previewStyle(),
          ),
      ],
      onChanged: pick,
    );
  }
}
