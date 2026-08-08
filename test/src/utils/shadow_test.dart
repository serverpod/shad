import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

// The element painted by [_render], centred in a 400x400 white canvas.
const _canvas = 400;
const _rect = Rect.fromLTRB(100, 150, 300, 250);

/// Paints [decoration] on white and returns the red channel of every pixel.
///
/// Shadows are real here: [debugDisableShadows] — which flutter_test turns on
/// — drops the mask filter, which is the whole thing under test.
Future<List<int>> _render(Decoration decoration) async {
  debugDisableShadows = false;
  try {
    final recorder = ui.PictureRecorder();
    const full = Rect.fromLTWH(0, 0, _canvas * 1.0, _canvas * 1.0);
    final canvas = Canvas(recorder, full);
    canvas.drawRect(full, Paint()..color = const Color(0xFFFFFFFF));
    decoration.createBoxPainter().paint(
      canvas,
      _rect.topLeft,
      ImageConfiguration(
        size: _rect.size,
        textDirection: TextDirection.ltr,
      ),
    );
    final image = await recorder.endRecording().toImage(_canvas, _canvas);
    final data = await image.toByteData();
    image.dispose();
    final bytes = data!.buffer.asUint8List();
    return [
      for (var i = 0; i < _canvas * _canvas; i++) bytes[i * 4],
    ];
  } finally {
    debugDisableShadows = true;
  }
}

extension on List<int> {
  int at(int x, int y) => this[y * _canvas + x];
}

void main() {
  test(
    'an outer shadow fades away from the element without a hard edge',
    () async {
      final pixels = await _render(
        ShadShadowDecoration.box(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          shadows: Shadows.lg,
        ),
      );

      // Directly under the element the shadow is at its darkest, and from
      // there it only ever gets lighter. BlurStyle.outer cut the shadow out
      // along `rect.shift(offset).inflate(spread)` rather than the element,
      // which put a step back to full strength 7px below a `shadow-lg` box.
      final below = [
        for (var y = _rect.bottom.toInt(); y < _rect.bottom + 60; y++)
          pixels.at(200, y),
      ];
      expect(below.first, lessThan(250), reason: 'no shadow under the element');
      expect(below.last, 255, reason: 'shadow reaches past its own extent');
      for (var i = 1; i < below.length; i++) {
        expect(
          below[i],
          greaterThanOrEqualTo(below[i - 1]),
          reason: 'shadow gets darker again ${i}px below the element',
        );
      }

      // The same going up and sideways.
      final above = [
        for (var y = _rect.top.toInt() - 1; y > _rect.top - 40; y--)
          pixels.at(200, y),
      ];
      for (var i = 1; i < above.length; i++) {
        expect(above[i], greaterThanOrEqualTo(above[i - 1]));
      }
      final left = [
        for (var x = _rect.left.toInt() - 1; x > _rect.left - 40; x--)
          pixels.at(x, 200),
      ];
      for (var i = 1; i < left.length; i++) {
        expect(left[i], greaterThanOrEqualTo(left[i - 1]));
      }
    },
  );

  test('an outer shadow never paints inside the element', () async {
    // A translucent surface (the menu finish) would otherwise show the shadow
    // through it as a grey wash.
    final pixels = await _render(
      ShadShadowDecoration.box(
        borderRadius: BorderRadius.circular(10),
        shadows: Shadows.xl2,
      ),
    );

    for (final point in [
      const Offset(200, 200), // centre
      Offset(_rect.left + 20, _rect.top + 20), // just inside each corner
      Offset(_rect.right - 20, _rect.top + 20),
      Offset(_rect.left + 20, _rect.bottom - 20),
      Offset(_rect.right - 20, _rect.bottom - 20),
    ]) {
      expect(
        pixels.at(point.dx.toInt(), point.dy.toInt()),
        255,
        reason: 'shadow shows through the fill at $point',
      );
    }
  });

  test(
    'a spread-only shadow is a crisp hairline outside the element',
    () async {
      // `shadow-[0_0_0_1px_...]`, which the sidebar's outline menu button uses
      // as a border that does not take part in layout.
      final pixels = await _render(
        ShadShadowDecoration.box(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          shadows: const [BoxShadow(spreadRadius: 1)],
        ),
      );

      expect(pixels.at(_rect.left.toInt() - 1, 200), 0, reason: 'the hairline');
      expect(pixels.at(_rect.left.toInt() - 2, 200), 255, reason: 'outside it');
      expect(pixels.at(_rect.left.toInt() + 1, 200), 255, reason: 'inside it');
      expect(pixels.at(200, _rect.top.toInt() - 1), 0);
      expect(pixels.at(200, _rect.bottom.toInt()), 0);
    },
  );
}
