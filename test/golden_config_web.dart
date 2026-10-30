/// Browser test runs (`--platform chrome`) compare no goldens: the web
/// `LocalFileComparator` has a different API, and the `*_web_test.dart` files
/// assert behaviour, not pixels.
void configureGoldens() {}
