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
