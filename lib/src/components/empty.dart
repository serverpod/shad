import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/i18n/localizations_delegate.dart';
import 'package:shadcn_ui/src/theme/theme.dart';
import 'package:shadcn_ui/src/utils/debug_check.dart';

/// {@template ShadEmpty}
/// An empty-state placeholder.
///
/// Mirrors shadcn/ui's `Empty`: an icon, a title, a description and optional
/// actions, centred in the space where content would otherwise be.
///
/// ```dart
/// ShadEmpty(
///   icon: const Icon(LucideIcons.inbox),
///   title: const Text('No messages'),
///   description: const Text('Messages you receive will show up here.'),
///   actions: [ShadButton(onPressed: refresh, child: const Text('Refresh'))],
/// )
/// ```
///
/// [title] falls back to a localized "No results" so the widget is never
/// silently blank.
/// {@endtemplate}
class ShadEmpty extends StatelessWidget {
  /// {@macro ShadEmpty}
  const ShadEmpty({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.actions = const [],
    this.padding,
    this.gap,
    this.iconSize,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// An illustration shown above the title, usually an [Icon].
  final Widget? icon;

  /// The headline. Defaults to a localized "No results".
  final Widget? title;

  /// A sentence explaining the empty state, or how to leave it.
  final Widget? description;

  /// Actions offered to the user, laid out in a row below the description.
  final List<Widget> actions;

  /// {@template ShadEmpty.padding}
  /// The padding around the content.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// The vertical gap between the icon, title, description and actions.
  final double? gap;

  /// {@template ShadEmpty.iconSize}
  /// The size of [icon].
  /// {@endtemplate}
  final double? iconSize;

  /// The color applied to [icon].
  final Color? iconColor;

  /// {@template ShadEmpty.titleStyle}
  /// The style of [title].
  /// {@endtemplate}
  final TextStyle? titleStyle;

  /// {@template ShadEmpty.descriptionStyle}
  /// The style of [description].
  /// {@endtemplate}
  final TextStyle? descriptionStyle;

  /// {@template ShadEmpty.crossAxisAlignment}
  /// The horizontal alignment of the content.
  /// {@endtemplate}
  final CrossAxisAlignment? crossAxisAlignment;

  /// {@template ShadEmpty.mainAxisAlignment}
  /// The vertical alignment of the content.
  /// {@endtemplate}
  final MainAxisAlignment? mainAxisAlignment;

  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final emptyTheme = theme.emptyTheme;
    final localizations = ShadLocalizations.of(context);

    final effectivePadding =
        padding ??
        emptyTheme.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 48);
    final effectiveGap = gap ?? emptyTheme.gap ?? 8.0;
    final effectiveIconSize = iconSize ?? emptyTheme.iconSize ?? 40.0;
    final effectiveIconColor =
        iconColor ?? emptyTheme.iconColor ?? theme.colorScheme.mutedForeground;
    final effectiveTitleStyle = (emptyTheme.titleStyle ?? theme.textTheme.large)
        .merge(titleStyle);
    final effectiveDescriptionStyle =
        (emptyTheme.descriptionStyle ?? theme.textTheme.muted).merge(
          descriptionStyle,
        );
    final effectiveCrossAxisAlignment =
        crossAxisAlignment ??
        emptyTheme.crossAxisAlignment ??
        CrossAxisAlignment.center;
    final effectiveMainAxisAlignment =
        mainAxisAlignment ??
        emptyTheme.mainAxisAlignment ??
        MainAxisAlignment.center;

    final effectiveTitle = title ?? Text(localizations.empty.title);

    return Semantics(
      container: true,
      child: Padding(
        padding: effectivePadding,
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: effectiveMainAxisAlignment,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  size: effectiveIconSize,
                  color: effectiveIconColor,
                ),
                child: icon!,
              ),
              SizedBox(height: effectiveGap * 2),
            ],
            DefaultTextStyle(
              style: effectiveTitleStyle,
              textAlign: TextAlign.center,
              child: effectiveTitle,
            ),
            if (description != null) ...[
              SizedBox(height: effectiveGap),
              DefaultTextStyle(
                style: effectiveDescriptionStyle,
                textAlign: TextAlign.center,
                child: description!,
              ),
            ],
            if (actions.isNotEmpty) ...[
              SizedBox(height: effectiveGap * 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) SizedBox(width: effectiveGap),
                    actions[i],
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
