import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tolerant_golden_comparator.dart';

/// Applies to every test under `test/`.
///
/// Goldens are compared with a small tolerance: they are generated on Linux
/// in CI (`update-goldens.yml`), and anti-aliasing differs by a fraction of a
/// percent between platforms and Flutter versions.
///
/// Set `SHAD_SKIP_GOLDENS=1` to run the suite without comparing pixels, as
/// the minimum-Flutter CI job does: an older engine rasterises differently,
/// and that job is there for the API, not the pixels.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final skip = Platform.environment['SHAD_SKIP_GOLDENS'] == '1';
  final previous = goldenFileComparator;
  if (previous is LocalFileComparator) {
    goldenFileComparator = skip
        ? _AlwaysMatchesComparator(previous.basedir)
        : TolerantGoldenFileComparator(
            previous.basedir.resolve('placeholder_test.dart'),
            precisionTolerance: 0.005,
          );
  }
  await testMain();
}

class _AlwaysMatchesComparator extends LocalFileComparator {
  _AlwaysMatchesComparator(Uri basedir)
    : super(basedir.resolve('placeholder_test.dart'));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
