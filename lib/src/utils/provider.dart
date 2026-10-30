import 'package:flutter/widgets.dart';

/// Reads a [ShadProvider] value without a dependency on it.
extension ProviderReadExt on BuildContext {
  /// Returns the value of the nearest `ShadProvider<T>`. Throws when there is
  /// none. Does not rebuild the caller when the value changes.
  T read<T>() => ShadProvider.of<T>(this, listen: false);

  /// Returns the value of the nearest `ShadProvider<T>`, or null when there is
  /// none. Does not rebuild the caller when the value changes.
  T? maybeRead<T>() => ShadProvider.maybeOf<T>(this, listen: false);
}

/// Reads a [ShadProvider] value and depends on it.
extension ProviderWatchExt on BuildContext {
  /// Returns the value of the nearest `ShadProvider<T>`. Throws when there is
  /// none. Rebuilds the caller when the provider notifies.
  T watch<T>() => ShadProvider.of<T>(this);

  /// Returns the value of the nearest `ShadProvider<T>`, or null when there is
  /// none. Rebuilds the caller when the provider notifies.
  T? maybeWatch<T>() => ShadProvider.maybeOf<T>(this);
}

/// Provides a value of type [T] to its descendants.
///
/// Read it with `context.read<T>()` or `context.watch<T>()`. Dependents
/// rebuild only when [notifyUpdate] returns true.
class ShadProvider<T> extends InheritedWidget {
  /// Creates a provider of [data].
  const ShadProvider({
    super.key,
    required super.child,
    required this.data,
    this.notifyUpdate,
  });

  /// The data to be provided
  final T data;

  /// Whether to notify the update of the provider, defaults to false
  final bool Function(ShadProvider<T> oldWidget)? notifyUpdate;

  /// Returns the value of the nearest `ShadProvider<T>`.
  ///
  /// Throws a [FlutterError] when there is none. When [listen] is true, the
  /// default, [context] depends on the provider.
  static T of<T>(BuildContext context, {bool listen = true}) {
    final inherited = maybeOf<T>(context, listen: listen);
    if (inherited == null) {
      throw FlutterError(
        'Could not find $T InheritedWidget in the ancestor widget tree.',
      );
    }
    return inherited;
  }

  /// Returns the value of the nearest `ShadProvider<T>`, or null when there is
  /// none.
  ///
  /// When [listen] is true, the default, [context] depends on the provider.
  static T? maybeOf<T>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<ShadProvider<T>>()
          ?.data;
    }
    final provider = context
        .getElementForInheritedWidgetOfExactType<ShadProvider<T>>()
        ?.widget;
    return (provider as ShadProvider<T>?)?.data;
  }

  @override
  bool updateShouldNotify(covariant ShadProvider<T> oldWidget) {
    return notifyUpdate?.call(oldWidget) ?? false;
  }
}
