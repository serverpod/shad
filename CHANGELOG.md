## 0.99.4

- Fixes the whole app freezing — no repaints, no input, no response to a window
  resize — when the pointer left and re-entered a `ShadSelect`'s scroll chevron
  within a fifth of a second. Two auto-scroll loops then ran against the same
  scroll controller and cancelled each other forever without yielding to the
  event loop. Only one loop can run now, and it always yields.
  `ShadSelectState.animateToTop`/`animateToBottom` and the
  `shouldAnimateToTop`/`shouldAnimateToBottom` flags are replaced by
  `startAutoScroll`/`stopAutoScroll`.
- Fixes `ShadSonner` leaking an `AnimationController`, and leaving a timer
  running, for every toast queued behind `visibleToastsAmount` and later shown.
- Fixes `ShadInputOTP` never dropping slots or groups that unmount, which grew
  its registry past `maxLength` and could then write out of range.
- Fixes an auto-anchored `ShadPortal` queueing an unbounded number of
  reposition callbacks while its overlay had no size yet.
- Fixes right-clicking a `ShadContextMenuRegion` on the web crashing any
  enclosing `SelectionArea` with `SelectableRegion`'s
  `assert(_selectable == null)`. The region toggled the global
  `BrowserContextMenu` around every click, and `SelectionArea` changes its
  tree shape on that flag; it now cancels the browser's own menu per event
  with a DOM-level `preventDefault` and leaves the global alone.

## 0.99.3

- Fixes the tooltip arrow pointing at nothing when the bubble is near a window
  edge. The bubble slides inward to stay on screen; the arrow now slides back
  with it and keeps pointing at the trigger, stopping short of the bubble's
  rounded corners.

## 0.99.2

- Fixes outer shadows being clipped to the wrong shape. Dialogs, sheets, cards,
  popovers, toasts, menus, the sidebar and every decorated control lost the
  shadow immediately around them and picked it up again a few pixels out with a
  hard edge. Shadows now paint the way CSS paints `box-shadow`: blurred, and
  clipped to outside the element itself.

## 0.99.1

- Fixes heights of components to comply with original Shadcn.

## 0.99.0

- Initial version.
