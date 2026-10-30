import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// How long an arm stays valid.
///
/// Long enough to cover the gap between a tap-down/tap-up and the browser
/// dispatching `contextmenu` (typically the same task), short enough that a
/// stray arm cannot swallow an unrelated right-click later on.
const _armWindow = Duration(milliseconds: 500);

bool _initialized = false;
DateTime? _armedAt;

void _ensureInitialized() {
  if (_initialized) return;
  _initialized = true;
  // Capture phase, so a page handler that stops propagation on the way up
  // cannot starve the suppression.
  web.document.addEventListener('contextmenu', _onContextMenu.toJS, true.toJS);
}

void _onContextMenu(web.Event event) {
  final armedAt = _armedAt;
  if (armedAt == null) return;
  _armedAt = null;
  if (DateTime.now().difference(armedAt) <= _armWindow) {
    event.preventDefault();
  }
}

/// Stops the browser from showing its own context menu for the next
/// `contextmenu` event, if that event comes within 500 milliseconds.
void suppressBrowserContextMenu() {
  _ensureInitialized();
  _armedAt = DateTime.now();
}
