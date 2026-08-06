import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/border.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/separated_iterable.dart';

/// {@template ShadKbd}
/// A keyboard key cap, used to document a shortcut.
///
/// Mirrors shadcn/ui's `Kbd`. A single key:
///
/// ```dart
/// const ShadKbd('⌘')
/// ```
///
/// or a chord, rendered as a row of caps:
///
/// ```dart
/// const ShadKbd.group(['⌘', 'K'])
/// ```
///
/// This is presentational. It documents a shortcut, it does not register one —
/// use `CallbackShortcuts` or `Shortcuts` for that.
/// {@endtemplate}
class ShadKbd extends StatelessWidget {
  /// {@macro ShadKbd}
  const ShadKbd(
    String this.label, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.padding,
    this.textStyle,
    this.minWidth,
    this.height,
  }) : keys = null,
       gap = null;

  /// A group of keys rendered as adjacent caps, e.g. `['⌘', 'K']`.
  const ShadKbd.group(
    List<String> this.keys, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.padding,
    this.textStyle,
    this.gap,
    this.minWidth,
    this.height,
  }) : label = null;

  /// The label of a single key cap.
  final String? label;

  /// The labels of a group of key caps.
  final List<String>? keys;

  /// {@template ShadKbd.backgroundColor}
  /// The background color of the key cap.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template ShadKbd.foregroundColor}
  /// The text color of the key cap.
  /// {@endtemplate}
  final Color? foregroundColor;

  /// {@template ShadKbd.border}
  /// The border of the key cap.
  /// {@endtemplate}
  final ShadBorder? border;

  /// {@template ShadKbd.padding}
  /// The padding inside the key cap.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template ShadKbd.textStyle}
  /// The text style of the key label.
  /// {@endtemplate}
  final TextStyle? textStyle;

  /// The gap between caps in a group.
  final double? gap;

  /// The minimum width of a single cap, so that `⌘` and `K` line up.
  final double? minWidth;

  /// {@template ShadKbd.height}
  /// The height of the key cap. Defaults to the theme's.
  /// {@endtemplate}
  final double? height;

  Widget _buildCap(BuildContext context, String text) {
    final theme = ShadTheme.of(context);
    final kbdTheme = theme.kbdTheme;

    final effectiveBackgroundColor =
        backgroundColor ?? kbdTheme.backgroundColor ?? theme.colorScheme.muted;
    final effectiveForegroundColor =
        foregroundColor ??
        kbdTheme.foregroundColor ??
        theme.colorScheme.mutedForeground;
    final effectiveBorder = (kbdTheme.border ?? const ShadBorder()).merge(
      border,
    );
    final effectivePadding =
        padding ??
        kbdTheme.padding ??
        const EdgeInsets.symmetric(horizontal: 5, vertical: 1);
    final effectiveTextStyle = (kbdTheme.textStyle ?? theme.textTheme.muted)
        .copyWith(color: effectiveForegroundColor)
        .merge(textStyle);
    final effectiveMinWidth = minWidth ?? kbdTheme.minWidth ?? 20.0;
    final effectiveHeight = height ?? kbdTheme.height ?? 20.0;

    // The Align keeps the cap its own size when the parent hands down tight
    // constraints — inside a button's row, say — instead of letting it
    // stretch to the parent's full height. [IntrinsicWidth] does the same on
    // the cross axis when a column stretches its children.
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(minWidth: effectiveMinWidth),
          height: effectiveHeight,
          padding: effectivePadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: effectiveBorder.radius,
            border: effectiveBorder.hasBorder
                ? effectiveBorder.toBorder()
                : null,
          ),
          child: Text(text, style: effectiveTextStyle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    assert(
      label != null || keys != null,
      'ShadKbd needs either a label or a list of keys',
    );

    if (label != null) return _buildCap(context, label!);

    final effectiveGap = gap ?? ShadTheme.of(context).kbdTheme.gap ?? 4.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keys!
          .map((key) => _buildCap(context, key))
          .separatedBy(SizedBox(width: effectiveGap))
          .toList(),
    );
  }
}
