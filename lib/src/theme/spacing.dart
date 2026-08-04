import 'package:flutter/widgets.dart';

/// A spacing scale, the Dart counterpart of Tailwind's `--spacing`.
///
/// Every padding and gap in shadcn/ui is a multiple of one variable — `p-4`,
/// `gap-2` and `py-1.5` are `4 × 1rem/4`, `2 ×` and `1.5 ×` that same step.
/// Modelling it the same way is what makes paddings reproducible: a component
/// asks for `spacing(6)` rather than for `24`, so the whole UI keeps its
/// proportions when the step changes, and any layout written against the scale
/// lines up with the components exactly.
///
/// ```dart
/// final spacing = ShadTheme.of(context).spacing;
/// Padding(padding: spacing.all(6), child: ...); // 24px with the default step
/// ```
///
/// Prefer `ShadGap` and `ShadPadding` over reading the scale by hand — they do
/// the lookup for you.
@immutable
class ShadSpacing {
  /// Creates a scale whose unit step is [step] logical pixels.
  ///
  /// The default matches Tailwind's `0.25rem`.
  const ShadSpacing({this.step = 4});

  /// The size of one step on the scale.
  final double step;

  /// [steps] steps, in logical pixels. `spacing(6)` is `24` by default.
  double call(double steps) => step * steps;

  /// Named steps, for the common cases.
  double get xs => call(1);
  double get sm => call(2);
  double get md => call(4);
  double get lg => call(6);
  double get xl => call(8);

  /// `EdgeInsets.all`, in steps.
  EdgeInsets all(double steps) => EdgeInsets.all(call(steps));

  /// `EdgeInsets.symmetric`, in steps.
  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(
        horizontal: call(horizontal),
        vertical: call(vertical),
      );

  /// `EdgeInsets.only`, in steps.
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: call(left),
    top: call(top),
    right: call(right),
    bottom: call(bottom),
  );

  /// `EdgeInsetsDirectional.only`, in steps.
  EdgeInsetsDirectional directional({
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) => EdgeInsetsDirectional.only(
    start: call(start),
    top: call(top),
    end: call(end),
    bottom: call(bottom),
  );

  ShadSpacing copyWith({double? step}) => ShadSpacing(step: step ?? this.step);

  static ShadSpacing lerp(ShadSpacing a, ShadSpacing b, double t) =>
      ShadSpacing(step: a.step + (b.step - a.step) * t);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ShadSpacing && other.step == step);

  @override
  int get hashCode => step.hashCode;

  @override
  String toString() => 'ShadSpacing(step: $step)';
}
