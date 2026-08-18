// Runs under `flutter test --platform chrome`; the VM suite skips it.
@TestOn('browser')
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  testWidgets(
    'right-clicking a context menu region never flips '
    'BrowserContextMenu.enabled',
    (tester) async {
      // The invariant under test: the region must suppress the browser's
      // native menu per event (DOM preventDefault), never by toggling this
      // global. `SelectableRegion.build` changes its tree shape on the
      // global, so flipping it remounts every `SelectionArea`'s selection
      // container mid-frame and trips `assert(_selectable == null)` —
      // registration happens in the new container's initState, removal only
      // in the old one's end-of-frame dispose.
      expect(BrowserContextMenu.enabled, isTrue);

      // Make `flutter/contextmenu` resolvable: inside the test zone the real
      // engine's reply never lands, so without this a
      // `disableContextMenu()` call would sit unresolved and the flag flip
      // it performs in `.then` would escape the assertions below.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.contextMenu,
        (call) async => null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.contextMenu,
          null,
        ),
      );

      await tester.pumpWidget(
        const ShadApp(
          home: Scaffold(
            body: ShadContextMenuRegion(
              items: [
                ShadContextMenuItem(child: Text('Copy')),
              ],
              child: SizedBox(
                key: Key('region'),
                width: 200,
                height: 200,
                child: ColoredBox(color: Colors.black12),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('region'))),
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      // Past the recognizer's deadline so onSecondaryTapDown has fired, and
      // through the microtasks of any platform-channel calls it made.
      await tester.pump(kPressTimeout);
      expect(
        BrowserContextMenu.enabled,
        isTrue,
        reason:
            'the browser context menu must not be globally disabled '
            'while the right button is down',
      );

      await gesture.up();
      await tester.pump();
      expect(
        BrowserContextMenu.enabled,
        isTrue,
        reason:
            'the browser context menu must not be globally toggled '
            'after the click either',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
