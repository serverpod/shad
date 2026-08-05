import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum NotifyAbout {
  all('All new messages'),
  mentions('Direct messages and mentions'),
  nothing('Nothing');

  const NotifyAbout(this.message);

  final String message;
}

/// Every form field variant in a single form.
class FormFieldsExample extends StatefulWidget {
  const FormFieldsExample({super.key});

  @override
  State<FormFieldsExample> createState() => _FormFieldsExampleState();
}

class _FormFieldsExampleState extends State<FormFieldsExample> {
  final formKey = GlobalKey<ShadFormState>();

  static const verifiedEmails = [
    'm@example.com',
    'm@google.com',
    'm@support.com',
  ];

  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            ShadInputFormField(
              id: 'username',
              label: const Text('Username'),
              placeholder: const Text('Enter your username'),
            ),
            ShadSelectFormField<String>(
              id: 'email',
              label: const Text('Email'),
              placeholder: const Text('Select a verified email'),
              options: [
                for (final email in verifiedEmails)
                  ShadOption(value: email, child: Text(email)),
              ],
              selectedOptionBuilder: (context, value) => Text(value),
            ),
            ShadTextareaFormField(
              id: 'bio',
              label: const Text('Bio'),
              placeholder: const Text('Tell us about yourself...'),
            ),
            ShadRadioGroupFormField<NotifyAbout>(
              id: 'notify',
              label: const Text('Notify me about'),
              items: [
                for (final option in NotifyAbout.values)
                  ShadRadio(value: option, label: Text(option.message)),
              ],
            ),
            ShadDatePickerFormField(
              id: 'date',
              label: const Text('Date of birth'),
            ),
            ShadTimePickerFormField(
              id: 'time',
              label: const Text('Pick a time'),
            ),
            ShadSwitchFormField(
              id: 'marketing',
              initialValue: false,
              inputLabel: const Text('Marketing emails'),
            ),
            ShadButton(
              child: const Text('Submit'),
              onPressed: () => formKey.currentState!.saveAndValidate(),
            ),
          ],
        ),
      ),
    );
  }
}
