import 'dart:async';

import 'golden_config_web.dart' if (dart.library.io) 'golden_config_io.dart';

/// Applies to every test under `test/`.
///
/// Goldens are generated on Linux and compared only there; see
/// `golden_config_io.dart`. The setup sits behind a conditional import
/// because the VM's golden comparator API does not exist when the
/// `*_web_test.dart` files compile for the browser.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  configureGoldens();
  await testMain();
}
