import 'package:example/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

/// Entrypoint used by tooling (e.g. the Dart MCP server) to drive the app:
/// `flutter run -t test_driver/app.dart`.
void main() {
  enableFlutterDriverExtension();
  app.main();
}
