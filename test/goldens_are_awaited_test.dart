import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `matchesGoldenFile` is an async matcher: inside a plain `expect` a
/// mismatch is never reported, which is how 52 of this suite's goldens went
/// stale without failing. Every golden assertion must be awaited.
void main() {
  test('every matchesGoldenFile is used with await expectLater', () {
    final offenders = <String>[];
    final unawaited = RegExp(
      r'(?<![\w.])expect\(\s*[^;]*?matchesGoldenFile\(',
      multiLine: true,
    );
    for (final file in Directory('test').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('_test.dart')) continue;
      final source = file.readAsStringSync();
      for (final match in unawaited.allMatches(source)) {
        final line = source.substring(0, match.start).split('\n').length;
        offenders.add('${file.path}:$line');
      }
    }
    expect(offenders, isEmpty);
  });
}
