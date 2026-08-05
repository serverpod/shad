import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputOtpBasicExample extends StatelessWidget {
  const InputOtpBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInputOTP(
      maxLength: 6,
      onChanged: (value) {},
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
    );
  }
}
