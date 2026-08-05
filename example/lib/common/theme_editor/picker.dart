import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// One option in a [ThemePicker].
@immutable
class PickerOption<T> {
  const PickerOption({
    required this.value,
    required this.label,
    this.swatch,
  });

  final T value;
  final String label;

  /// Shown as a colour dot before the label, as shadcn's colour pickers do.
  final Color? swatch;
}

/// The style of a setting row's small heading, e.g. "Style" or "Base Color".
///
/// shadcn's customizer sets these `text-xs text-muted-foreground`. The colour
/// has to be stated: `ShadTextTheme.muted` carries the muted *metrics* but no
/// colour, so on its own it renders in the ambient foreground.
TextStyle _labelStyle(ShadThemeData theme) => theme.textTheme.muted.copyWith(
  fontSize: 11,
  color: theme.colorScheme.mutedForeground,
);

/// A setting row from shadcn/ui's customizer.
///
/// The trigger is a two-line stack — a small muted label above the current
/// value — with the row's icon or colour swatch at the trailing edge; tapping
/// it opens a popover holding a single-select list. This is the shape every
/// picker in shadcn's `/create` sidebar uses, where that indicator is
/// positioned `right-2.5 top-1/2 -translate-y-1/2`.
class ThemePicker<T> extends StatefulWidget {
  const ThemePicker({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final T value;
  final List<PickerOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool enabled;

  /// Shown at the trailing edge when the setting has no colour to show.
  ///
  /// shadcn's customizer gives every row its own icon, which is what makes the
  /// list scannable without reading it.
  final IconData? icon;

  @override
  State<ThemePicker<T>> createState() => _ThemePickerState<T>();
}

class _ThemePickerState<T> extends State<ThemePicker<T>> {
  final controller = ShadPopoverController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final selected = widget.options.firstWhere(
      (o) => o.value == widget.value,
      orElse: () => widget.options.first,
    );

    return ShadPopover(
      controller: controller,
      padding: const EdgeInsets.all(4),
      anchor: const ShadAnchorAuto(offset: Offset(0, 4)),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          color: theme.colorScheme.foreground.withValues(alpha: .1),
          radius: theme.radii.lg,
          width: 1,
        ),
      ),
      popover: (context) => ConstrainedBox(
        // Without a maxWidth the popover matches the anchor's incoming
        // constraints, which in a stretched sidebar column is the whole
        // viewport.
        constraints: const BoxConstraints(
          maxHeight: 320,
          minWidth: 232,
          maxWidth: 264,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final option in widget.options)
                _PickerItem(
                  label: option.label,
                  swatch: option.swatch,
                  selected: option.value == widget.value,
                  onTap: () {
                    widget.onChanged(option.value);
                    controller.hide();
                  },
                ),
            ],
          ),
        ),
      ),
      child: Opacity(
        opacity: widget.enabled ? 1 : .5,
        child: ShadGestureDetector(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? controller.toggle : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.card,
              borderRadius: theme.radius,
              border: Border.all(color: theme.colorScheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.label, style: _labelStyle(theme)),
                      Text(
                        selected.label,
                        style: theme.textTheme.small,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // The row's indicator sits at the trailing edge, centred on
                // the two-line stack — shadcn positions it `right-2.5
                // top-1/2 -translate-y-1/2`.
                if (selected.swatch != null) ...[
                  const SizedBox(width: 8),
                  _Swatch(color: selected.swatch!),
                ] else if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    widget.icon,
                    size: 15,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerItem extends StatefulWidget {
  const _PickerItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.swatch,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? swatch;

  @override
  State<_PickerItem> createState() => _PickerItemState();
}

class _PickerItemState extends State<_PickerItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadGestureDetector(
      cursor: SystemMouseCursors.click,
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onHoverChange: (v) => setState(() => hovered = v),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: hovered ? theme.colorScheme.accent : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            if (widget.swatch != null) ...[
              _Swatch(color: widget.swatch!),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(widget.label, style: theme.textTheme.small)),
            if (widget.selected)
              Icon(
                LucideIcons.check,
                size: 14,
                color: theme.colorScheme.foreground,
              ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
      ),
    );
  }
}

/// A labelled slider row, used for the settings shadcn exposes as a range.
class ThemeSlider extends StatelessWidget {
  const ThemeSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.suffix = '',
    this.fractionDigits = 0,
    this.enabled = true,
    this.icon,
  });

  /// {@macro ThemePicker.icon}
  final IconData? icon;

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String suffix;
  final int fractionDigits;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Opacity(
      opacity: enabled ? 1 : .5,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: theme.colorScheme.mutedForeground),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 74,
            child: Text(label, style: _labelStyle(theme)),
          ),
          Expanded(
            child: SliderTheme(
              // Straight from the theme's slider, so the panel's control
              // matches the ones in the preview. The thumb used to be the
              // page background — near-black, and invisible on this
              // deliberately dark panel.
              data: SliderThemeData(
                trackHeight: theme.sliderTheme.trackHeight ?? 4,
                activeTrackColor:
                    theme.sliderTheme.activeTrackColor ??
                    theme.colorScheme.primary,
                inactiveTrackColor:
                    theme.sliderTheme.inactiveTrackColor ??
                    theme.colorScheme.muted,
                thumbColor:
                    theme.sliderTheme.thumbColor ??
                    theme.colorScheme.foreground,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: theme.sliderTheme.thumbRadius ?? 8,
                ),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${value.toStringAsFixed(fractionDigits)}$suffix',
              style: _labelStyle(theme),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// A picker whose popover holds arbitrary content rather than one flat list.
///
/// shadcn's Menu picker is a single row reading e.g. "Default / Solid", opening
/// a popover with two labelled radio groups — colour and surface. Modelling it
/// as four flat options would lose that structure.
class ThemeGroupPicker extends StatefulWidget {
  const ThemeGroupPicker({
    super.key,
    required this.label,
    required this.value,
    required this.groups,
    this.icon,
  });

  final String label;

  /// {@macro ThemePicker.icon}
  final IconData? icon;

  /// The summary shown on the trigger, e.g. "Default / Solid".
  final String value;

  final List<PickerGroup> groups;

  @override
  State<ThemeGroupPicker> createState() => _ThemeGroupPickerState();
}

/// A labelled run of mutually exclusive options inside a [ThemeGroupPicker].
@immutable
class PickerGroup {
  const PickerGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  /// shadcn disables the accent group while a menu is translucent.
  final bool enabled;
}

class _ThemeGroupPickerState extends State<ThemeGroupPicker> {
  final controller = ShadPopoverController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadPopover(
      controller: controller,
      padding: const EdgeInsets.all(4),
      anchor: const ShadAnchorAuto(offset: Offset(0, 4)),
      popover: (context) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 360,
          minWidth: 232,
          maxWidth: 264,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var g = 0; g < widget.groups.length; g++) ...[
                if (g > 0)
                  const ShadSeparator.horizontal(
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                  child: Text(
                    widget.groups[g].label,
                    style: _labelStyle(theme),
                  ),
                ),
                Opacity(
                  opacity: widget.groups[g].enabled ? 1 : .5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final option in widget.groups[g].options)
                        _PickerItem(
                          label: option,
                          selected: option == widget.groups[g].selected,
                          onTap: () {
                            if (!widget.groups[g].enabled) return;
                            widget.groups[g].onSelected(option);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      child: ShadGestureDetector(
        cursor: SystemMouseCursors.click,
        behavior: HitTestBehavior.opaque,
        onTap: controller.toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: theme.radius,
            border: Border.all(color: theme.colorScheme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.label, style: _labelStyle(theme)),
                    Text(
                      widget.value,
                      style: theme.textTheme.small,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  widget.icon,
                  size: 15,
                  color: theme.colorScheme.mutedForeground,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
