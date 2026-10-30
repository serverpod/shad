import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';

/// A widget that displays an avatar image with customizable size, shape, and
/// fallback.
///
/// The [ShadAvatar] widget renders an image from a provided source, falling
/// back to [fallback] while the image loads, if it fails to load, or when
/// there is no source.
class ShadAvatar extends StatelessWidget {
  /// Creates an avatar showing the image at [src], a URL or an asset path.
  ///
  /// A `String` starting with `http://` or `https://` is loaded with a
  /// [NetworkImage]; any other is loaded as an asset with [AssetImage], from
  /// [package] if set. Null or an empty string shows [fallback].
  const ShadAvatar(
    this.src, {
    super.key,
    Widget? fallback,
    @Deprecated(
      'Use fallback, as shadcn names it (AvatarFallback). '
      'Will be removed in the next major version.',
    )
    Widget? placeholder,
    this.size,
    this.shape,
    this.backgroundColor,
    this.package,
    this.fit,
  }) : image = null,
       fallback = fallback ?? placeholder;

  /// Creates an avatar showing [image], for any other source: a file, memory
  /// bytes, a cached network image, or an SVG rasterised by an
  /// `ImageProvider`. Null shows [fallback].
  const ShadAvatar.image(
    this.image, {
    super.key,
    this.fallback,
    this.size,
    this.shape,
    this.backgroundColor,
    this.fit,
  }) : src = null,
       package = null;

  /// {@template ShadAvatar.src}
  /// The URL or asset path of the image, for the default constructor.
  /// {@endtemplate}
  final String? src;

  /// {@template ShadAvatar.image}
  /// The image, for [ShadAvatar.image].
  /// {@endtemplate}
  final ImageProvider? image;

  /// {@template ShadAvatar.fallback}
  /// The widget shown while the image loads, if it fails to load, or when
  /// there is no image. Usually initials or an icon.
  /// {@endtemplate}
  final Widget? fallback;

  /// The old name of [fallback].
  @Deprecated(
    'Use fallback, as shadcn names it (AvatarFallback). '
    'Will be removed in the next major version.',
  )
  Widget? get placeholder => fallback;

  /// {@template ShadAvatar.size}
  /// The size of the avatar, overriding the theme default if specified.
  /// Defines both width and height; defaults to 40x40 if not set.
  /// {@endtemplate}
  final Size? size;

  /// {@template ShadAvatar.shape}
  /// The shape of the avatar's border, overriding the theme default if
  /// specified.
  /// Typically a [CircleBorder], but can be customized
  /// (e.g., [RoundedRectangleBorder]).
  /// {@endtemplate}
  final ShapeBorder? shape;

  /// {@template ShadAvatar.backgroundColor}
  /// The background color of the avatar, displayed behind the image.
  /// Overrides the theme's muted color if provided.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template ShadAvatar.package}
  /// The package name for asset images, used when [src] is an asset path.
  /// Optional and only relevant for asset-based images.
  /// {@endtemplate}
  final String? package;

  /// {@template ShadAvatar.fit}
  /// How the image should fit within the avatar's bounds.
  /// Overrides the theme default if specified; affects image scaling and
  /// cropping.
  /// {@endtemplate}
  final BoxFit? fit;

  /// The provider to load, or null when there is nothing to load.
  ImageProvider? get _image {
    if (image != null) return image;
    final value = src?.trim() ?? '';
    if (value.isEmpty) return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    return AssetImage(value, package: package);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final avatarTheme = theme.avatarTheme;
    final size = this.size ?? avatarTheme.size ?? const Size.square(40);
    final shape = this.shape ?? avatarTheme.shape ?? const CircleBorder();
    final backgroundColor =
        this.backgroundColor ??
        avatarTheme.backgroundColor ??
        theme.colorScheme.muted;
    final fit = this.fit ?? avatarTheme.fit;
    final fallback = this.fallback == null
        ? null
        : Center(child: this.fallback);
    final image = _image;

    return Container(
      width: size.width,
      height: size.height,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: ShapeDecoration(shape: shape, color: backgroundColor),
      child: image == null
          ? fallback
          : Image(
              image: image,
              width: size.width,
              height: size.height,
              fit: fit,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return fallback ?? const SizedBox.shrink();
              },
              errorBuilder: (context, error, stackTrace) =>
                  fallback ?? const SizedBox.shrink(),
            ),
    );
  }
}
