import 'dart:typed_data';

import 'package:shadcn_ui/src/utils/clipboard/clipboard_service_stub.dart'
    if (dart.library.js_interop) 'package:shadcn_ui/src/utils/clipboard/clipboard_service_web.dart'
    as impl;

/// A single item read from the system clipboard.
typedef ShadClipboardItem = ({String mimeType, Uint8List bytes});

/// Callback for receiving pasted file items.
typedef ShadPasteFilesCallback = void Function(List<ShadClipboardItem> files);

/// Callback for receiving errors during paste file extraction.
typedef ShadPasteFilesErrorCallback = void Function(Object error);

/// Registers a listener for paste events containing file data.
///
/// On web, listens to the browser `paste` event and extracts file items
/// from the clipboard data. On other platforms, this is a no-op.
///
/// The [callback] is invoked only when the paste contains file items.
void addPasteFilesListener(ShadPasteFilesCallback callback) =>
    impl.addPasteFilesListener(callback);

/// Removes a previously registered paste files listener.
void removePasteFilesListener(ShadPasteFilesCallback callback) =>
    impl.removePasteFilesListener(callback);

/// Registers a listener for errors that occur during paste file extraction.
void addPasteFilesErrorListener(ShadPasteFilesErrorCallback callback) =>
    impl.addPasteFilesErrorListener(callback);

/// Removes a previously registered paste files error listener.
void removePasteFilesErrorListener(ShadPasteFilesErrorCallback callback) =>
    impl.removePasteFilesErrorListener(callback);

@Deprecated(
  'Renamed to ShadPasteFilesCallback. This name will be removed in v1.0.0.',
)
typedef PasteFilesCallback = ShadPasteFilesCallback;

@Deprecated(
  'Renamed to ShadPasteFilesErrorCallback. '
  'This name will be removed in v1.0.0.',
)
typedef PasteFilesErrorCallback = ShadPasteFilesErrorCallback;
