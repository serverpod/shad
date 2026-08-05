import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
