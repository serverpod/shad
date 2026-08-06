# Form

Building forms with `ShadForm`: field values collect under their ids, and validation runs per field.

## Validation and submit

`saveAndValidate` runs every validator and returns whether the form is valid. Values collect in `formKey.currentState!.value`.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class FormProfileExample extends StatefulWidget {
  const FormProfileExample({super.key});

  @override
  State<FormProfileExample> createState() => _FormProfileExampleState();
}

class _FormProfileExampleState extends State<FormProfileExample> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            ShadInputFormField(
              id: 'username',
              label: const Text('Username'),
              placeholder: const Text('Enter your username'),
              description: const Text('This is your public display name.'),
              validator: (v) {
                if (v.length < 2) {
                  return 'Username must be at least 2 characters.';
                }
                return null;
              },
            ),
            ShadCheckboxFormField(
              id: 'terms',
              initialValue: false,
              inputLabel: const Text('I accept the terms and conditions'),
              validator: (v) {
                if (!v) {
                  return 'You must accept the terms and conditions';
                }
                return null;
              },
            ),
            ShadButton(
              child: const Text('Submit'),
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()) {
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text('Form submitted'),
                      description: Text('${formKey.currentState!.value}'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

## Every field type

Each input component has a `*FormField` counterpart that plugs into `ShadForm` the same way: `ShadInputFormField`, `ShadSelectFormField`, `ShadTextareaFormField`, `ShadRadioGroupFormField`, `ShadDatePickerFormField`, `ShadDateRangePickerFormField`, `ShadTimePickerFormField`, `ShadCheckboxFormField`, `ShadSwitchFormField`, and `ShadInputOTPFormField`. See `example/lib/docs/examples/form/form_fields.dart` for one of each wired into a single form.

## OTP verification

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class FormOtpExample extends StatefulWidget {
  const FormOtpExample({super.key});

  @override
  State<FormOtpExample> createState() => _FormOtpExampleState();
}

class _FormOtpExampleState extends State<FormOtpExample> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          ShadInputOTPFormField(
            id: 'otp',
            maxLength: 6,
            label: const Text('OTP'),
            description: const Text('Enter your one-time password.'),
            validator: (v) => v.contains(' ') ? 'Fill the whole code' : null,
            children: const [
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
              Icon(LucideIcons.dot),
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
            ],
          ),
          ShadButton(
            child: const Text('Verify'),
            onPressed: () => formKey.currentState!.saveAndValidate(),
          ),
        ],
      ),
    );
  }
}
```
