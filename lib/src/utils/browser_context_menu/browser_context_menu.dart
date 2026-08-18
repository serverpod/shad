import 'package:shad/src/utils/browser_context_menu/browser_context_menu_stub.dart'
    if (dart.library.js_interop) 'package:shad/src/utils/browser_context_menu/browser_context_menu_web.dart'
    as impl;

/// Suppresses the browser's native context menu for the right-click that is
/// currently being handled.
///
/// `ShadContextMenuRegion` used to reach for
/// `BrowserContextMenu.disableContextMenu()`/`enableContextMenu()` around
/// each right-click instead. That flips a **global** flag that
/// `SelectableRegion.build` reads to decide whether to wrap its content in a
/// `PlatformSelectableRegionContextMenu` — so every `SelectionArea` that
/// rebuilt inside the disable→enable window changed tree shape and remounted
/// its internal `SelectionContainer`. The new container registers in
/// `initState` while the old one only unregisters in its end-of-frame
/// `dispose`, tripping `SelectableRegion`'s `assert(_selectable == null)`.
///
/// Cancelling the single DOM `contextmenu` event instead — what
/// `preventDefault()` is for, and what web frameworks including the shadcn
/// reference do — leaves the global flag alone, so selection containers are
/// never remounted.
///
/// The suppression is armed for a short window rather than one event: on
/// Windows the `contextmenu` event fires on button *up*, so the handler arms
/// on tap-down and re-arms on tap-up to survive an arbitrarily long press.
/// On other platforms it fires on button down, right after the arm.
///
/// No-op off the web.
void suppressBrowserContextMenu() => impl.suppressBrowserContextMenu();
