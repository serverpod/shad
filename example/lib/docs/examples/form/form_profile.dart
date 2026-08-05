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
