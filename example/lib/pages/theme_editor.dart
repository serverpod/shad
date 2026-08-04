import 'package:example/common/app_bar.dart';
import 'package:example/main.dart';
import 'package:example/common/theme_editor/editor_config.dart';
import 'package:example/common/theme_editor/fonts.dart';
import 'package:example/common/theme_editor/picker.dart';
import 'package:example/common/theme_editor/preview_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A recreation of shadcn/ui's theme editor (ui.shadcn.com/create).
///
/// The preview fills the page and the customizer floats over it as a
/// translucent, blurred, rounded card — the layout the original uses. Both
/// halves are wrapped in [ShadThemeScope] rather than a bare `ShadTheme`, so
/// their text and icon colours follow their own theme instead of inheriting
/// the app's.
class ThemeEditorPage extends StatefulWidget {
  const ThemeEditorPage({super.key});

  @override
  State<ThemeEditorPage> createState() => _ThemeEditorPageState();
}

class _ThemeEditorPageState extends State<ThemeEditorPage> {
  ThemeEditorConfig config = const ThemeEditorConfig();

  void update(ThemeEditorConfig next) => setState(() => config = next);

  @override
  Widget build(BuildContext context) {
    // Light/dark and direction are app-wide switches in the toolbar, so the
    // panel does not duplicate them; the page reads them like every other one.
    return SignalBuilder(builder: (context, _) => _build(context));
  }

  Widget _build(BuildContext context) {
    final themeMode = themeModeProvider.of(context).value;
    final directionality = directionalityProvider.of(context).value;
    final config = this.config.copyWith(
      brightness: switch (themeMode) {
        ThemeMode.dark => Brightness.dark,
        ThemeMode.light => Brightness.light,
        ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      },
      rtl: directionality == TextDirection.rtl,
    );

    final preview = ShadThemeScope(
      data: config.build(),
      child: Directionality(
        textDirection: config.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(config.textScale),
          ),
          child: const ThemePreviewPanel(),
        ),
      ),
    );

    // The customizer always renders dark, matching `className="dark"` on
    // shadcn's Card. It is chrome, not part of the theme being edited: if it
    // followed the configuration you could not read it while editing a light
    // theme's contrast, or a menu-inverted one.
    final customizer = ShadThemeScope(
      data: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadNeutralColorScheme.dark(),
        radius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: _Customizer(config: config, onChanged: update),
    );

    return Scaffold(
      // The page behind the preview carries the preview's own canvas colour,
      // so nothing white shows through at the edges or under a docked panel.
      backgroundColor: config.build().colorScheme.muted,
      appBar: const MyAppBar(title: 'Theme Editor'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Below this the floating panel would cover the preview, so it docks
          // to the top instead.
          if (constraints.maxWidth < 900) {
            return Column(
              children: [
                SizedBox(height: 300, child: customizer),
                Expanded(child: preview),
              ],
            );
          }
          return Stack(
            children: [
              // The panel floats over the preview, so the preview reserves
              // room for it rather than letting cards slide underneath.
              Positioned.fill(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    padding: const EdgeInsets.only(right: _panelWidth + 48),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: _panelWidth + 48),
                    child: preview,
                  ),
                ),
              ),
              Positioned(
                top: 24,
                right: 24,
                bottom: 24,
                width: _panelWidth,
                child: customizer,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Width of the floating customizer panel.
const _panelWidth = 320.0;

class _Customizer extends StatelessWidget {
  const _Customizer({required this.config, required this.onChanged});

  final ThemeEditorConfig config;
  final ValueChanged<ThemeEditorConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

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

    final fontOptions = [
      for (final f in EditorFont.all)
        PickerOption(value: f.title, label: f.title),
    ];

    final panel = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                ThemePicker<String>(
                  label: 'Heading',
                  icon: LucideIcons.heading,
                  value: config.headingFontTitle ?? _sameAsBody,
                  options: [
                    const PickerOption(
                      value: _sameAsBody,
                      label: _sameAsBody,
                    ),
                    ...fontOptions,
                  ],
                  onChanged: (v) => onChanged(
                    v == _sameAsBody
                        ? config.copyWith(clearHeadingFont: true)
                        : config.copyWith(headingFontTitle: v),
                  ),
                ),
                ThemePicker<String>(
                  label: 'Font',
                  icon: LucideIcons.type,
                  value: config.fontTitle,
                  options: fontOptions,
                  onChanged: (v) => onChanged(config.copyWith(fontTitle: v)),
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
                  value:
                      '${config.menuColor.label} / ${config.menuFinish.label}',
                  groups: [
                    PickerGroup(
                      label: 'Color',
                      options: [
                        for (final m in MenuSurfaceColor.values) m.label,
                      ],
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
                      options: [
                        for (final m in MenuSurfaceFinish.values) m.label,
                      ],
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
                  // A translucent menu highlights with a foreground wash, so
                  // the accent has no effect there; the picker is locked to
                  // make that visible, as shadcn's editor does.
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  onPressed: () => _copy(context, config),
                  leading: const Icon(LucideIcons.clipboard, size: 16),
                  child: const Text('Copy Theme'),
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () => _showCode(context, config),
                      leading: const Icon(LucideIcons.code, size: 16),
                      child: const Text('Code'),
                    ),
                  ),
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () => onChanged(const ThemeEditorConfig()),
                      leading: const Icon(LucideIcons.rotateCcw, size: 16),
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.border),
        ),
        child: panel,
      ),
    );
  }

  static const _sameAsBody = 'Same as body';

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
            leading: const Icon(LucideIcons.copy, size: 16),
            child: const Text('Copy'),
          ),
        ],
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: SelectableText(
              snippet,
              style: ShadTheme.of(context).textTheme.small.copyWith(
                fontFamily: 'GeistMono',
                package: 'shadcn_ui',
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
