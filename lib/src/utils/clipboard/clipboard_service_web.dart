import 'dart:js_interop';

import 'package:shad/src/utils/clipboard/clipboard_service.dart';
import 'package:web/web.dart' as web;

final _listeners = <ShadPasteFilesCallback>{};
final _errorListeners = <ShadPasteFilesErrorCallback>{};
bool _initialized = false;

void _ensureInitialized() {
  if (_initialized) return;
  _initialized = true;
  web.document.addEventListener(
    'paste',
    _onPaste.toJS,
  );
}

void _onPaste(web.Event event) {
  if (_listeners.isEmpty) return;
  final clipboardEvent = event as web.ClipboardEvent;
  final data = clipboardEvent.clipboardData;
  if (data == null) return;

  _extractFiles(data).then(
    (files) {
      if (files.isNotEmpty) {
        for (final listener in [..._listeners]) {
          listener(files);
        }
      }
    },
    onError: (Object error) {
      for (final listener in [..._errorListeners]) {
        listener(error);
      }
    },
  );
}

Future<List<ShadClipboardItem>> _extractFiles(web.DataTransfer data) async {
  final results = <ShadClipboardItem>[];
  final items = data.items;
  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    if (item.kind == 'file') {
      final file = item.getAsFile();
      if (file != null) {
        final buffer = await file.arrayBuffer().toDart;
        results.add((
          mimeType: file.type,
          bytes: buffer.toDart.asUint8List(),
        ));
      }
    }
  }
  return results;
}

void addPasteFilesListener(ShadPasteFilesCallback callback) {
  _ensureInitialized();
  _listeners.add(callback);
}

void removePasteFilesListener(ShadPasteFilesCallback callback) {
  _listeners.remove(callback);
}

void addPasteFilesErrorListener(ShadPasteFilesErrorCallback callback) {
  _ensureInitialized();
  _errorListeners.add(callback);
}

void removePasteFilesErrorListener(ShadPasteFilesErrorCallback callback) {
  _errorListeners.remove(callback);
}
