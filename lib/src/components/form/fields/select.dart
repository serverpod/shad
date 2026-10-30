import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shad/src/components/form/field.dart';
import 'package:shad/src/components/popover.dart';
import 'package:shad/src/components/select.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';

/// A single-choice [ShadSelect] that takes part in a `ShadForm`, with a
/// label, a description and validation.
///
/// For a field that holds several values, use [ShadSelectMultipleFormField].
class ShadSelectFormField<T> extends ShadFormField<T> {
  /// Creates a select form field, like [ShadSelect.new].
  ShadSelectFormField({
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,

    /// {@macro ShadSelect.selectedOptionBuilder}
    required ShadSelectedOptionBuilder<T> selectedOptionBuilder,

    /// {@macro ShadSelect.options}
    Iterable<Widget>? options,

    /// {@macro ShadSelect.optionsBuilder}
    Widget? Function(BuildContext, int)? optionsBuilder,

    /// {@macro ShadSelect.placeholder}
    Widget? placeholder,

    /// {@macro ShadSelect.closeOnTapOutside}
    bool closeOnTapOutside = true,

    /// {@macro ShadSelect.minWidth}
    double? minWidth,

    /// {@macro ShadSelect.maxWidth}
    double? maxWidth,

    /// {@macro ShadSelect.maxHeight}
    double? maxHeight,

    /// {@macro ShadSelect.decoration}
    ShadDecoration? decoration,

    /// {@macro ShadSelect.trailing}
    Widget? trailing,

    /// {@macro ShadSelect.padding}
    EdgeInsetsGeometry? padding,

    /// {@macro ShadSelect.optionsPadding}
    EdgeInsetsGeometry? optionsPadding,

    /// {@macro ShadSelect.showScrollToTopChevron}
    bool? showScrollToTopChevron,

    /// {@macro ShadSelect.showScrollToBottomChevron}
    bool? showScrollToBottomChevron,

    /// {@macro ShadSelect.scrollController}
    ScrollController? scrollController,

    /// {@macro ShadSelect.anchor}
    ShadAnchorBase? anchor,

    /// {@macro ShadPopover.filter}
    ImageFilter? filter,

    /// {@macro ShadSelect.popoverController}
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,

    /// {@macro ShadSelect.allowDeselection}
    bool allowDeselection = false,

    /// {@macro ShadSelect.closeOnSelect}
    bool closeOnSelect = true,

    /// {@macro ShadPopover.groupId}
    Object? groupId,

    /// {@macro ShadSelect.itemCount}
    int? itemCount,

    /// {@macro ShadSelect.shrinkWrap}
    bool? shrinkWrap,
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,
  }) : super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectFormFieldState<T>;

           return ShadSelect<T>(
             options: options,
             allowDeselection: allowDeselection,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             onPressed: onPressed,
           );
         },
       );

  /// Creates a select form field with a search input, like
  /// [ShadSelect.withSearch].
  ShadSelectFormField.withSearch({
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.forceErrorText,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    required ShadSelectedOptionBuilder<T> selectedOptionBuilder,
    Iterable<Widget>? options,

    /// The builder for the options of the [ShadSelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    ShadDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    ShadAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    Widget? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,
    bool allowDeselection = false,
    bool closeOnSelect = true,

    /// {@macro ShadPopover.groupId}
    Object? groupId,

    /// {@macro ShadSelect.itemCount}
    int? itemCount,

    /// {@macro ShadSelect.shrinkWrap}
    bool? shrinkWrap,

    /// {@macro ShadSelect.controller}
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro ShadSelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,
  }) : super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectFormFieldState<T>;

           return ShadSelect<T>.withSearch(
             options: options,
             allowDeselection: allowDeselection,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
             onPressed: onPressed,
           );
         },
       );

  /// Creates a select form field with an explicit [variant], like
  /// [ShadSelect.raw]. [variant] must be [ShadSelectVariant.primary] or
  /// [ShadSelectVariant.search].
  ShadSelectFormField.raw({
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    super.forceErrorText,
    required ShadSelectVariant variant,
    required ShadSelectedOptionBuilder<T> selectedOptionBuilder,
    Iterable<Widget>? options,

    /// The builder for the options of the [ShadSelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxHeight,
    ShadDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    ShadAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    Widget? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,
    bool allowDeselection = false,
    bool closeOnSelect = true,

    /// {@macro ShadPopover.groupId}
    Object? groupId,

    /// {@macro ShadSelect.itemCount}
    int? itemCount,

    /// {@macro ShadSelect.shrinkWrap}
    bool? shrinkWrap,

    /// {@macro ShadSelect.controller}
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro ShadSelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,
  }) : assert(
         variant == ShadSelectVariant.primary ||
             variant == ShadSelectVariant.search,
         '''The variant is not supported. Use primary or search or use ShadSelectMultipleFormField instead.''',
       ),
       super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectFormFieldState<T>;

           return ShadSelect<T>.raw(
             variant: variant,
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
             onPressed: onPressed,
           );
         },
       );

  /// {@macro ShadSelect.controller}
  final ShadSelectController<T>? controller;

  @override
  ShadFormFieldState<ShadSelectFormField<T>, T> createState() =>
      ShadSelectFormFieldState<T>();
}

/// The state of a [ShadSelectFormField].
class ShadSelectFormFieldState<T>
    extends ShadFormFieldState<ShadSelectFormField<T>, T> {
  ShadSelectController<T>? _controller;

  /// The controller in use: [ShadSelectFormField.controller] when given,
  /// otherwise an internal one created from the initial value.
  ShadSelectController<T> get controller =>
      widget.controller ??
      (_controller ??= ShadSelectController<T>(
        initialValue: {if (initialValue is T) initialValue as T},
      ));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    controller.value = value is T ? <T>{value} : <T>{};
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  /// Copies the controller's selection into the field's value.
  void onControllerChange() {
    if (controller.value.firstOrNull != value) {
      didChange(controller.value.firstOrNull);
    }
  }

  @override
  void reset() {
    super.reset();
    controller.value = initialValue is T ? <T>{initialValue as T} : <T>{};
  }
}

/// A multiple-choice [ShadSelect] that takes part in a `ShadForm`, with a
/// label, a description and validation. Its value is the set of selected
/// options.
class ShadSelectMultipleFormField<T> extends ShadFormField<Set<T>> {
  /// Creates a multiple select form field, like [ShadSelect.multiple].
  ShadSelectMultipleFormField({
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    super.forceErrorText,
    required ShadSelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    Iterable<Widget>? options,

    /// The builder for the options of the [ShadSelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    ShadDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    ShadAnchorBase? anchor,
    ImageFilter? filter,
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,
    bool closeOnSelect = true,

    /// {@macro ShadSelect.allowDeselection}
    bool allowDeselection = true,
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,

    /// {@macro ShadPopover.groupId}
    Object? groupId,
  }) : super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectMultipleFormFieldState<T>;

           return ShadSelect<T>.multiple(
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             allowDeselection: allowDeselection,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             onPressed: onPressed,
             groupId: groupId,
           );
         },
       );

  /// Creates a multiple select form field with a search input, like
  /// [ShadSelect.multipleWithSearch].
  ShadSelectMultipleFormField.withSearch({
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    super.forceErrorText,
    required ShadSelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    Iterable<Widget>? options,

    /// The builder for the options of the [ShadSelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    ShadDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    ShadAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    Widget? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,
    bool closeOnSelect = true,

    /// {@macro ShadSelect.allowDeselection}
    bool allowDeselection = true,
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro ShadSelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,

    /// {@macro ShadPopover.groupId}
    Object? groupId,
  }) : super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectMultipleFormFieldState<T>;

           return ShadSelect<T>.multipleWithSearch(
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             allowDeselection: allowDeselection,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
             onPressed: onPressed,
             groupId: groupId,
           );
         },
       );

  /// Creates a multiple select form field with an explicit [variant], like
  /// [ShadSelect.raw]. [variant] must be [ShadSelectVariant.multiple] or
  /// [ShadSelectVariant.multipleWithSearch].
  ShadSelectMultipleFormField.raw({
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    super.forceErrorText,
    required ShadSelectVariant variant,
    required ShadSelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    Iterable<Widget>? options,

    /// The builder for the options of the [ShadSelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxHeight,
    ShadDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    ShadAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    Widget? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    ShadPopoverController? popoverController,

    /// {@macro ShadSelect.header}
    Widget? header,

    /// {@macro ShadSelect.footer}
    Widget? footer,
    bool allowDeselection = true,
    bool closeOnSelect = true,
    this.controller,

    /// {@macro ShadSelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro ShadSelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro ShadSelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,

    /// {@macro ShadSelect.onPressed}
    VoidCallback? onPressed,

    /// {@macro ShadPopover.groupId}
    Object? groupId,
  }) : assert(
         variant == ShadSelectVariant.multiple ||
             variant == ShadSelectVariant.multipleWithSearch,
         '''The variant is not supported. Use multiple or multipleWithSearch or use ShadSelectFormField instead.''',
       ),
       super(
         decorationBuilder: (context) =>
             (ShadTheme.of(context).selectTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSelectMultipleFormFieldState<T>;

           return ShadSelect<T>.raw(
             variant: variant,
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             onMultipleChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
             onPressed: onPressed,
             groupId: groupId,
           );
         },
       );

  /// {@macro ShadSelect.controller}
  final ShadSelectController<T>? controller;

  @override
  ShadFormFieldState<ShadSelectMultipleFormField<T>, Set<T>> createState() =>
      ShadSelectMultipleFormFieldState<T>();
}

/// The state of a [ShadSelectMultipleFormField].
class ShadSelectMultipleFormFieldState<T>
    extends ShadFormFieldState<ShadSelectMultipleFormField<T>, Set<T>> {
  ShadSelectController<T>? _controller;

  /// The controller in use: [ShadSelectMultipleFormField.controller] when
  /// given, otherwise an internal one created from the initial value.
  ShadSelectController<T> get controller =>
      widget.controller ??
      (_controller ??= ShadSelectController<T>(initialValue: initialValue));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
  }

  @override
  void didChange(Set<T>? value) {
    super.didChange(value);
    controller.value = value ?? {};
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  /// Copies the controller's selection into the field's value.
  void onControllerChange() {
    if (controller.value != value) {
      didChange(controller.value.toSet());
    }
  }

  @override
  void reset() {
    super.reset();
    controller.value = initialValue ?? {};
  }
}

/// The old name of [ShadSelectMultipleFormFieldState].
@Deprecated(
  'Use ShadSelectMultipleFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderSelectMultipleState<T> =
    ShadSelectMultipleFormFieldState<T>;

/// The old name of [ShadSelectFormFieldState].
@Deprecated(
  'Use ShadSelectFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderSelectState<T> = ShadSelectFormFieldState<T>;
