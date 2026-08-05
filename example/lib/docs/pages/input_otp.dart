import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/input_otp/input_otp_basic.dart';

final inputOtpDoc = ComponentDoc(
  slug: 'input_otp',
  title: 'Input OTP',
  description: 'A one-time password input with copy-paste support.',
  playgroundRoute: '/input-OTP',
  examples: [
    ComponentExample(
      id: 'input_otp_basic',
      title: 'Default',
      builder: (_) => const InputOtpBasicExample(),
    ),
  ],
);
