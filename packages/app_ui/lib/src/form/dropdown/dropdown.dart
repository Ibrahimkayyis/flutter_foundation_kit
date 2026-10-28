import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_ui/nti_ui.dart';

part 'dropdown_item.dart';
part 'dropdown_content.dart';
part 'multi_select.dart';

class AppDropdownAsyncConfig<T> {
  final FutureOr<List<T>> Function(String text) searchFunc;
  final String? hintSearch;

  AppDropdownAsyncConfig({required this.searchFunc, this.hintSearch});
}

typedef AppDropdownSearchCompareFn<T> = bool Function(T item, String key);
typedef AppDropdownItemCompareFn<T> = bool Function(T item1, T item2);

class AppDropdown<T> extends StatefulWidget {
  final String? title;
  final T? initialValue;
  final List<T> items;

  final String Function(T data)? itemAsString;
  final Widget? Function(BuildContext context, T? data)? selectedBuilder;
  final Widget Function(BuildContext context, T data, bool isSelected)?
  itemBuilder;
  final AppDropdownAsyncConfig<T>? asyncConfig;
  final String hintText;
  final EdgeInsets? padding;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isFilled;
  final FocusNode? focusNode;
  final double? loadingHeight;
  final double? emptyHeight;
  final FormFieldSetter<T>? onSaved;
  final Widget? emptyWidget;
  final Widget? onLoading;
  final bool isLoading;
  final Widget? footer;
  final TextStyle? hintStyle;
  final String? initialSearch;
  final AppDropdownSearchCompareFn<T>? searchCompare;
  final AppDropdownController<T>? controller;
  final ValueChanged<T?>? onChange;
  final FormFieldValidator<T>? validator;
  final TextStyle? labelStyle;
  final EdgeInsets containerPadding;
  final EdgeInsets itemPading;
  final Color? containerColor;
  final bool showBoder;
  final AppDropdownItemCompareFn<T>? itemCompare;

  const AppDropdown({
    super.key,
    this.selectedBuilder,
    this.containerColor,
    this.prefixIcon,
    this.title,
    this.itemAsString,
    this.showBoder = true,
    this.controller,
    this.itemBuilder,
    this.initialValue,
    this.items = const [],
    this.emptyHeight,
    this.loadingHeight,
    this.padding,
    this.searchCompare,
    this.hintStyle,
    this.hintText = '',
    this.onLoading,
    this.enabled = true,
    this.isFilled = false,
    this.onSaved,
    this.isLoading = false,
    this.validator,
    this.emptyWidget,
    this.onChange,
    this.containerPadding = const EdgeInsets.all(8),
    this.itemPading = const EdgeInsets.only(
      top: 15.0,
      bottom: 15.0,
      left: 10.0,
      right: 10.0,
    ),
    this.footer,
    this.labelStyle,
    this.asyncConfig,
    this.initialSearch,
    this.itemCompare,
    this.focusNode,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdown<T>();
}

class AppDropdownController<T> extends ValueNotifier<T?> {
  AppDropdownController({T? initialValue}) : super(initialValue);

  clear() {
    super.value = null;
  }
}

class _AppDropdown<T> extends State<AppDropdown<T>> {
  late final AppDropdownController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        AppDropdownController(initialValue: widget.initialValue);
    _controller.addListener(_onValueChange);
  }

  void _onValueChange() {
    widget.onChange?.call(_controller.value);
  }

  Color getFillColor(BuildContext ctx) {
    if (!widget.enabled) return context.colorTheme.basic4Reverse;

    if (_controller.value != null) {
      return widget.containerColor ?? Colors.transparent;
    }
    return widget.containerColor ?? context.colorTheme.basic4Reverse;
  }

  @override
  void dispose() {
    _controller.removeListener(_onValueChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _compare(T item1, T item2) {
    final compareFn = widget.itemCompare;
    if (compareFn == null) return item1 == item2;
    return compareFn(item1, item2);
  }

  @override
  Widget build(BuildContext context) {
    final searchFunc = widget.asyncConfig?.searchFunc;
    final color = context.colorTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, selectedItem, ___) {
                      return DropdownSearch<T>(
                        enabled: widget.enabled,
                        compareFn: _compare,
                        items: (filter, loadProps) {
                          if (searchFunc != null) {
                            return searchFunc(filter);
                          }

                          return widget.items;
                        },

                        onChanged: (value) {
                          _controller.value = value;
                        },
                        onSaved: (_) {
                          widget.onSaved?.call(_controller.value);
                        },
                        validator: (T? value) {
                          final error = widget.validator?.call(value);
                          return error;
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: AppInputDecoration.inputDecoration(
                            context,
                            prefixIcon: widget.prefixIcon,
                            showBorder: widget.showBoder,
                            hintText: widget.hintText,
                            fillColor: getFillColor(context),
                            hintStyle: widget.hintStyle,
                            enabled: widget.enabled,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            isFilled: true,
                          ),
                        ),
                        selectedItem: selectedItem,
                        filterFn:
                            widget.asyncConfig != null
                                ? widget.searchCompare
                                : null,
                        dropdownBuilder:
                            (context, selectedItem) => Container(
                              padding:
                                  widget.title == null
                                      ? const EdgeInsets.fromLTRB(0, 20, 0, 20)
                                      : const EdgeInsets.fromLTRB(0, 30, 0, 10),
                              color: Colors.transparent,
                              child: _DropdownSelectedItem(
                                itemAsString: widget.itemAsString,
                                selectedBuilder: widget.selectedBuilder,
                                data: selectedItem,
                              ),
                            ),
                        popupProps: PopupProps.menu(
                          showSearchBox:
                              widget.asyncConfig != null ||
                              widget.searchCompare != null,

                          searchFieldProps: TextFieldProps(
                            decoration: AppInputDecoration.inputDecoration(
                              context,
                              hintText: widget.asyncConfig?.hintSearch,
                              fillColor: Colors.white,
                            ),
                          ),
                          loadingBuilder:
                              (_, __) => widget.onLoading ?? _defaultLoading(),
                          fit: FlexFit.loose,
                          menuProps: const MenuProps(
                            borderRadius: AppInputDecoration.radius,
                          ),
                          emptyBuilder:
                              widget.emptyWidget != null
                                  ? (_, __) => widget.emptyWidget!
                                  : null,
                          itemBuilder:
                              (context, item, isSelected, isDisabled) =>
                                  _DropdownItem(
                                    padding: widget.itemPading,
                                    isSelected: item == _controller.value,
                                    data: item,
                                    itemAsString: widget.itemAsString,
                                    itemBuilder: widget.itemBuilder,
                                  ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: widget.prefixIcon == null ? 16 : 48,
                    child: Text(
                      widget.title ?? '',
                      style:
                          widget.labelStyle ??
                          TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: context.colorTheme.basic7Reverse,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.enabled)
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (_controller.value == null) return const SizedBox.shrink();
              return InkWell(
                onTap: () => _controller.clear(),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(8),
                  child: AppIcon(
                    AppIcons.close,
                    color: color.systemDanger,
                    height: 20,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _defaultLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [NTICircularLoading()],
      ),
    );
  }
}


typedef NTIDropdown<T> = AppDropdown<T>;
