import 'dart:typed_data';

import 'package:shad/src/utils/clipboard/clipboard_service_stub.dart'
    if (dart.library.js_interop) 'package:shad/src/utils/clipboard/clipboard_service_web.dart'
    as impl;

/// A single item read from the system clipboard.
typedef ShadClipboardItem = ({String mimeType, Uint8List bytes});

/// Callback for receiving pasted file items.
typedef ShadPasteFilesCallback = void Function(List<ShadClipboardItem> files);

/// Callback for receiving errors during paste file extraction.
typedef ShadPasteFilesErrorCallback = void Function(Object error);

/// Listens for files pasted into the app.
///
/// On web, listens to the browser `paste` event and extracts file items from
/// the clipboard data. On other platforms, every method is a no-op.
abstract final class ShadClipboard {
  /// Registers a listener for paste events containing file data.
  ///
  /// The [callback] is invoked only when the paste contains file items.
  static void addPasteFilesListener(ShadPasteFilesCallback callback) =>
      impl.addPasteFilesListener(callback);

  /// Removes a previously registered paste files listener.
  static void removePasteFilesListener(ShadPasteFilesCallback callback) =>
      impl.removePasteFilesListener(callback);

  /// Registers a listener for errors that occur during paste file
  /// extraction.
  static void addPasteFilesErrorListener(
    ShadPasteFilesErrorCallback callback,
  ) => impl.addPasteFilesErrorListener(callback);

  /// Removes a previously registered paste files error listener.
  static void removePasteFilesErrorListener(
    ShadPasteFilesErrorCallback callback,
  ) => impl.removePasteFilesErrorListener(callback);
}

/// Registers a listener for paste events containing file data.
@Deprecated(
  'Use ShadClipboard.addPasteFilesListener. '
  'Will be removed in the next major version.',
)
void addPasteFilesListener(ShadPasteFilesCallback callback) =>
    ShadClipboard.addPasteFilesListener(callback);

/// Removes a previously registered paste files listener.
@Deprecated(
  'Use ShadClipboard.removePasteFilesListener. '
  'Will be removed in the next major version.',
)
void removePasteFilesListener(ShadPasteFilesCallback callback) =>
    ShadClipboard.removePasteFilesListener(callback);

/// Registers a listener for errors that occur during paste file extraction.
@Deprecated(
  'Use ShadClipboard.addPasteFilesErrorListener. '
  'Will be removed in the next major version.',
)
void addPasteFilesErrorListener(ShadPasteFilesErrorCallback callback) =>
    ShadClipboard.addPasteFilesErrorListener(callback);

/// Removes a previously registered paste files error listener.
@Deprecated(
  'Use ShadClipboard.removePasteFilesErrorListener. '
  'Will be removed in the next major version.',
)
void removePasteFilesErrorListener(ShadPasteFilesErrorCallback callback) =>
    ShadClipboard.removePasteFilesErrorListener(callback);
