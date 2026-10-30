import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/extensions/text_style.dart';

/// Lays out a form field: a [label] above [child], then a [description] and an
/// [error] below it.
///
/// Styles and paddings come from [decoration] merged over
/// `ShadThemeData.decoration`.
class ShadInputDecorator extends StatelessWidget {
  /// Creates an input decorator.
  const ShadInputDecorator({
    super.key,
    this.child,
    this.label,
    this.error,
    this.description,
    this.decoration,
  });

  /// The field itself.
  final Widget? child;

  /// The label shown above [child].
  final Widget? label;

  /// The error message shown below [child].
  final Widget? error;

  /// The help text shown below [child], above [error].
  final Widget? description;

  /// Overrides for the label, description and error styles and paddings.
  final ShadDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final effectiveDecoration = theme.decoration.merge(decoration);
    final hasError = effectiveDecoration.hasError ?? false;

    final effectiveFallbackToLabelStyle =
        effectiveDecoration.fallbackToLabelStyle ?? true;

    final defaultErrorStyle = theme.textTheme.muted.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.destructive,
    );

    final defaultLabelStyle = theme.textTheme.muted.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.foreground,
    );

    final effectiveErrorStyle =
        effectiveDecoration.errorStyle ?? defaultErrorStyle;

    var effectiveLabelStyle = switch (hasError) {
      true => effectiveDecoration.errorLabelStyle,
      false => effectiveDecoration.labelStyle,
    };

    if (effectiveFallbackToLabelStyle && effectiveLabelStyle == null) {
      effectiveLabelStyle =
          effectiveDecoration.labelStyle ??
          switch (hasError) {
            true => defaultErrorStyle,
            false => defaultLabelStyle,
          };
    }

    final effectiveDescriptionStyle =
        (effectiveDecoration.descriptionStyle ?? theme.textTheme.muted)
            .fallback(color: theme.colorScheme.mutedForeground);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding:
                effectiveDecoration.labelPadding ??
                const EdgeInsets.only(bottom: 8),
            // With fallbackToLabelStyle off and no label style set, the
            // label keeps the ambient style; this used to throw on a null
            // check.
            child: effectiveLabelStyle == null
                ? label!
                : DefaultTextStyle(style: effectiveLabelStyle, child: label!),
          ),
        ?child,
        if (description != null)
          Padding(
            padding:
                effectiveDecoration.descriptionPadding ??
                const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: effectiveDescriptionStyle,
              child: description!,
            ),
          ),
        if (error != null)
          Padding(
            padding:
                effectiveDecoration.errorPadding ??
                const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: effectiveErrorStyle,
              child: error!,
            ),
          ),
      ],
    );
  }
}
