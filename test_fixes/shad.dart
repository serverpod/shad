import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

void main() {
  // Types.
  const List<BoxShadow> shadows = Shadows.sm;
  GoogleFontBuilder? builder;
  ShadFormBuilderField<String>? field;
  ShadFormBuilderInputState? inputState;
  ToValueTransformer<int>? toValue;
  RestorableShadTabsController<int>? restorable;

  // Enum value.
  const variant = ShadToggleVariant.default_;

  // Constructor parameters.
  const ShadToast(duration: Duration(seconds: 1));
  const ShadToast.destructive(duration: Duration(seconds: 1));
  const ShadAvatar('', placeholder: Text('AB'));
  const ShadSonner(visibleToastsAmount: 2, child: SizedBox());
  ShadInput(onLineCountChange: (_) {});
  const ShadCalendar(
    selectedDayButtonOusideMonthVariant: ShadButtonVariant.secondary,
  );
  ShadInputFormField(valueTransformer: (v) => v);

  // Members.
  const toast = ShadToast();
  toast.duration;
}
