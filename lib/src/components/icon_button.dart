import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/components/button.dart';
import 'package:shad/src/theme/components/button.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/states_controller.dart';

/// A customizable icon-only button widget with variant styling.
///
/// The [ShadIconButton] widget is a specialized version of [ShadButton]
/// designed for icon-only use cases, offering multiple styling variants
/// (primary, destructive, outline, secondary, ghost). It supports rich
/// interaction states and integrates with [ShadTheme] for consistent
/// appearance. Use named constructors like [ShadIconButton.destructive] for
/// specific variants or [ShadIconButton.raw] for full control.
///
/// shadcn/ui itself has no separate component — it is `<Button size="icon">`,
/// and `ShadButton(size: ShadButtonSize.icon, child: Icon(...))` is exactly
/// that. This adds the square sizes for the `sm`/`lg` steps (which shadcn
/// spells `size-icon-sm` / `size-icon-lg`) and the semantic label an
/// icon-only control needs, so prefer it when the button holds only an icon.
class ShadIconButton extends StatelessWidget {
  /// Creates a primary variant icon button widget.
  const ShadIconButton({
    super.key,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.onFocusChange,
  }) : variant = ShadButtonVariant.primary;

  /// Creates an icon button widget with a specified [variant], offering full
  /// customization.
  const ShadIconButton.raw({
    super.key,
    required this.variant,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
  }) : assert(
         variant != ShadButtonVariant.link,
         "ShadIconButton doesn't support the link variant",
       );

  /// Creates a destructive variant icon button widget, typically for warning or
  /// error actions.
  const ShadIconButton.destructive({
    super.key,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
  }) : variant = ShadButtonVariant.destructive;

  /// Creates an outline variant icon button widget, typically with a bordered
  /// appearance.
  const ShadIconButton.outline({
    super.key,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.onFocusChange,
  }) : variant = ShadButtonVariant.outline;

  /// Creates a secondary variant icon button widget, typically for less
  /// prominent actions.
  const ShadIconButton.secondary({
    super.key,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.onFocusChange,
  }) : variant = ShadButtonVariant.secondary;

  /// Creates a ghost variant icon button widget, typically with minimal
  /// styling.
  const ShadIconButton.ghost({
    super.key,
    required this.icon,
    this.iconSize,
    this.size,
    this.semanticLabel,
    this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.focusNode,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.shadows,
    this.gradient,
    this.decoration,
    this.enabled = true,
    this.onLongPress,
    this.statesController,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.onFocusChange,
  }) : variant = ShadButtonVariant.ghost;

  /// {@macro ShadButton.variant}
  final ShadButtonVariant variant;

  /// {@macro ShadButton.onPressed}
  final VoidCallback? onPressed;

  /// {@macro ShadButton.onLongPress}
  final VoidCallback? onLongPress;

  /// {@template ShadIconButton.icon}
  /// The icon widget displayed within the button.
  /// Typically an [Icon], required to define the button’s content.
  /// {@endtemplate}
  final Widget icon;

  /// {@template ShadIconButton.iconSize}
  /// The size of the icon within the button.
  /// Defaults to the [IconThemeData.size] if not specified.
  /// {@endtemplate}
  final double? iconSize;

  /// {@template ShadIconButton.size}
  /// The button size to resolve metrics from.
  ///
  /// Defaults to [ShadButtonSize.icon] — the square icon size matching
  /// shadcn/ui's `<Button size="icon">`. Pass [ShadButtonSize.sm] or
  /// [ShadButtonSize.lg] for the smaller/larger icon buttons.
  /// {@endtemplate}
  final ShadButtonSize? size;

  /// {@template ShadIconButton.semanticLabel}
  /// The accessible name announced by screen readers.
  ///
  /// An icon-only button has no text for assistive technology to read, so
  /// this should almost always be provided — it is the equivalent of the
  /// `sr-only` span shadcn/ui puts inside `<Button size="icon">`.
  /// {@endtemplate}
  final String? semanticLabel;

  /// {@macro ShadButton.cursor}
  final MouseCursor? cursor;

  /// {@macro ShadButton.width}
  final double? width;

  /// {@macro ShadButton.height}
  final double? height;

  /// {@macro ShadButton.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadButton.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadButton.hoverBackgroundColor}
  final Color? hoverBackgroundColor;

  /// {@macro ShadButton.foregroundColor}
  final Color? foregroundColor;

  /// {@macro ShadButton.hoverForegroundColor}
  final Color? hoverForegroundColor;

  /// {@macro ShadButton.autofocus}
  final bool autofocus;

  /// {@macro ShadButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro ShadButton.pressedBackgroundColor}
  final Color? pressedBackgroundColor;

  /// {@macro ShadButton.pressedForegroundColor}
  final Color? pressedForegroundColor;

  /// {@macro ShadButton.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadButton.gradient}
  final Gradient? gradient;

  /// {@macro ShadButton.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadButton.enabled}
  final bool enabled;

  /// {@macro ShadButton.statesController}
  final ShadStatesController? statesController;

  /// {@macro ShadButton.hoverStrategies}
  final ShadHoverStrategies? hoverStrategies;

  /// {@macro ShadButton.onHoverChange}
  final ValueChanged<bool>? onHoverChange;

  /// {@macro ShadButton.onTapDown}
  final ValueChanged<TapDownDetails>? onTapDown;

  /// {@macro ShadButton.onTapUp}
  final ValueChanged<TapUpDetails>? onTapUp;

  /// {@macro ShadButton.onTapCancel}
  final VoidCallback? onTapCancel;

  /// {@macro ShadButton.onSecondaryTapDown}
  final ValueChanged<TapDownDetails>? onSecondaryTapDown;

  /// {@macro ShadButton.onSecondaryTapUp}
  final ValueChanged<TapUpDetails>? onSecondaryTapUp;

  /// {@macro ShadButton.onSecondaryTapCancel}
  final VoidCallback? onSecondaryTapCancel;

  /// {@macro ShadButton.onLongPressStart}
  final ValueChanged<LongPressStartDetails>? onLongPressStart;

  /// {@macro ShadButton.onLongPressCancel}
  final VoidCallback? onLongPressCancel;

  /// {@macro ShadButton.onLongPressUp}
  final VoidCallback? onLongPressUp;

  /// {@macro ShadButton.onLongPressDown}
  final ValueChanged<LongPressDownDetails>? onLongPressDown;

  /// {@macro ShadButton.onLongPressEnd}
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;

  /// {@macro ShadButton.onDoubleTap}
  final VoidCallback? onDoubleTap;

  /// {@macro ShadButton.onDoubleTapDown}
  final ValueChanged<TapDownDetails>? onDoubleTapDown;

  /// {@macro ShadButton.onDoubleTapCancel}
  final VoidCallback? onDoubleTapCancel;

  /// {@macro ShadButton.longPressDuration}
  final Duration? longPressDuration;

  /// {@macro ShadButton.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  ShadButtonTheme buttonTheme(ShadThemeData theme) {
    return switch (variant) {
      ShadButtonVariant.primary => theme.primaryButtonTheme,
      ShadButtonVariant.destructive => theme.destructiveButtonTheme,
      ShadButtonVariant.secondary => theme.secondaryButtonTheme,
      ShadButtonVariant.ghost => theme.ghostButtonTheme,
      ShadButtonVariant.outline => theme.outlineButtonTheme,
      ShadButtonVariant.link => theme.linkButtonTheme,
    };
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));

    final theme = ShadTheme.of(context);

    final sizesTheme = buttonTheme(theme).sizesTheme;
    // The square sizes, not the text-button ones: shadcn sizes an icon
    // button's glyph independently of a text button's at the same step
    // (`.cn-button-size-icon-sm` keeps 16 where `.cn-button-size-sm` drops
    // to 14).
    final defaultSize = switch (size ?? ShadButtonSize.icon) {
      ShadButtonSize.icon => sizesTheme?.icon ?? theme.buttonSizesTheme.icon!,
      ShadButtonSize.sm =>
        sizesTheme?.iconSm ??
            theme.buttonSizesTheme.iconSm ??
            sizesTheme?.sm ??
            theme.buttonSizesTheme.sm!,
      ShadButtonSize.lg =>
        sizesTheme?.iconLg ??
            theme.buttonSizesTheme.iconLg ??
            sizesTheme?.lg ??
            theme.buttonSizesTheme.lg!,
      ShadButtonSize.regular =>
        sizesTheme?.regular ?? theme.buttonSizesTheme.regular!,
    };

    final effectivePadding = padding ?? defaultSize.padding;

    final effectiveHeight = height ?? defaultSize.height;
    // Only the `icon` size carries an explicit width. For sm/lg/regular fall
    // back to the height so an icon button stays square at every size.
    final effectiveWidth = width ?? defaultSize.width ?? effectiveHeight;

    Widget button = ShadButton.raw(
      variant: variant,
      width: effectiveWidth,
      height: effectiveHeight,
      padding: effectivePadding,
      iconSize: iconSize ?? defaultSize.iconSize,
      onPressed: onPressed,
      onLongPress: onLongPress,
      cursor: cursor,
      backgroundColor: backgroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      foregroundColor: foregroundColor,
      hoverForegroundColor: hoverForegroundColor,
      autofocus: autofocus,
      focusNode: focusNode,
      pressedBackgroundColor: pressedBackgroundColor,
      pressedForegroundColor: pressedForegroundColor,
      shadows: shadows,
      gradient: gradient,
      decoration: decoration,
      enabled: enabled,
      statesController: statesController,
      hoverStrategies: hoverStrategies,
      onHoverChange: onHoverChange,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressCancel: onLongPressCancel,
      onLongPressUp: onLongPressUp,
      onLongPressDown: onLongPressDown,
      onLongPressEnd: onLongPressEnd,
      onDoubleTap: onDoubleTap,
      onDoubleTapDown: onDoubleTapDown,
      onDoubleTapCancel: onDoubleTapCancel,
      longPressDuration: longPressDuration,
      onFocusChange: onFocusChange,
      child: icon,
    );

    if (semanticLabel != null) {
      // An icon-only button carries no text, so without this a screen reader
      // announces nothing at all.
      button = Semantics(
        label: semanticLabel,
        button: true,
        enabled: enabled,
        container: true,
        child: ExcludeSemantics(child: button),
      );
    }

    return button;
  }
}
