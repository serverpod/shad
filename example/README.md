# shad docs site

The source of <https://shad.serverpod.dev/>: the component browser, the docs
for every `shad` component, and a theme editor that mirrors shadcn/ui's
`/create`.

For a minimal app, see [example.md](example.md).

## Running it

```bash
cd example
flutter pub get
flutter run -d chrome
```

It also runs on macOS, Windows, Linux, iOS and Android.

- **Fonts.** The theme editor loads its fonts from Google Fonts at runtime
  (`google_fonts`). On macOS the app needs network access. Flutter does not
  commit `macos/`, so after `flutter create --platforms=macos .` add
  `com.apple.security.network.client` to both
  `macos/Runner/DebugProfile.entitlements` and
  `macos/Runner/Release.entitlements`.
- **Driving the app from tools.** `test_driver/app.dart` enables the Flutter
  Driver extension:

  ```bash
  flutter run -t test_driver/app.dart
  ```

  Doc previews contain spinners that animate forever, so turn frame
  syncing off (`set_frame_sync: false`) before sending driver commands.

## Layout

| Path | Contents |
| --- | --- |
| `lib/main.dart` | Entry point and the app-wide theme, built from the editor's configuration. |
| `lib/common/` | The app shell, top navigation and the theme editor. |
| `lib/docs/` | The docs pages, their registry, and one runnable file per example under `examples/`. Each example is also bundled as an asset, so the code shown is the code that runs. |
| `lib/screens/` | The playground and the components browser. |
