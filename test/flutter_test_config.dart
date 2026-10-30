import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tolerant_golden_comparator.dart';

/// Applies to every test under `test/`.
///
/// Goldens are generated on Linux, in CI (`update-goldens.yml`), and only
/// compared on Linux: macOS and Windows anti-alias text and hairlines
/// differently, by several percent on the small images here. Elsewhere
/// pixel comparison is skipped, and `--update-goldens` writes nothing, so a
/// non-Linux run can neither fail on nor commit platform-specific pixels.
///
/// Set `SHAD_COMPARE_GOLDENS=1` to compare anyway, or `SHAD_SKIP_GOLDENS=1`
/// to skip on Linux too, as the minimum-Flutter CI job does: an older engine
/// rasterises differently, and that job is there for the API, not the
/// pixels. A small tolerance absorbs engine-version noise on Linux.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final env = Platform.environment;
  final compare =
      env['SHAD_SKIP_GOLDENS'] != '1' &&
      (Platform.isLinux || env['SHAD_COMPARE_GOLDENS'] == '1');
  final previous = goldenFileComparator;
  if (previous is LocalFileComparator) {
    goldenFileComparator = compare
        ? TolerantGoldenFileComparator(
            previous.basedir.resolve('placeholder_test.dart'),
            precisionTolerance: 0.005,
          )
        : _AlwaysMatchesComparator(previous.basedir);
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
