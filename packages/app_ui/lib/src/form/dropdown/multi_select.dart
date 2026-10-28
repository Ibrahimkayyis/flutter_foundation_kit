part of 'dropdown.dart';

typedef NTIMultiSelectedSelectedtemBuilder<T> =
    Widget Function(BuildContext context, T data, VoidCallback removeAction);

class NTIMultiSelect<T> extends StatefulWidget {
  final String? title;
  final List<T>? initialValue;
  final List<T> items;
  final String? dialogTitle;
  final String? dialogSubtitle;
  final String Function(T data)? itemAsString;
  final NTIMultiSelectedSelectedtemBuilder<T>? selectedItemBuilder;
  final Widget Function(BuildContext context, T data, bool isSelected)?
  dialogItemBuilder;
  final AppDropdownAsyncConfig<T>? asyncConfig;
  final String hintText;
  final EdgeInsets? padding;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isFilled;
  final FocusNode? focusNode;
  final double? loadingHeight;
  final double? emptyHeight;
  final FormFieldSetter<List<T>>? onSaved;
  final Widget? emptyWidget;
  final Widget? onLoading;
  final bool isLoading;
  final Widget? footer;
  final TextStyle? hintStyle;
  final String? initialSearch;
  final AppDropdownSearchCompareFn<T>? searchCompare;
  final NTIMultiSelectController<T>? controller;
  final ValueChanged<List<T>?>? onChange;
  final FormFieldValidator<List<T>>? validator;
  final TextStyle? labelStyle;
  final EdgeInsets containerPadding;
  final EdgeInsets itemPading;
  final Color? containerColor;
  final bool showBoder;
  final AppDropdownItemCompareFn<T>? itemCompare;

  const NTIMultiSelect({
    super.key,
    this.selectedItemBuilder,
    this.dialogTitle,
    this.dialogSubtitle,
    this.containerColor,
    this.prefixIcon,
    this.title,
    this.itemAsString,
    this.showBoder = true,
    this.controller,
    this.dialogItemBuilder,
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
  State<NTIMultiSelect<T>> createState() => _NTIMultiSelect<T>();
}

class NTIMultiSelectController<T> extends ValueNotifier<List<T>> {
  NTIMultiSelectController({List<T>? initialValue}) : super(initialValue ?? []);

  deleteItem(T item) {
    value.removeWhere((e) => e == item);
    notifyListeners();
  }

  clear() {
    super.value = [];
  }
}

class _NTIMultiSelect<T> extends State<NTIMultiSelect<T>> {
  final _dropdownKey = GlobalKey<DropdownSearchState<T>>();
  late final NTIMultiSelectController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        NTIMultiSelectController(initialValue: widget.initialValue);
    _dropdownKey.currentState?.changeSelectedItems(_controller.value);
    _controller.addListener(_onValueChange);
  }

  void _onValueChange() {
    widget.onChange?.call(_controller.value);
    _dropdownKey.currentState?.changeSelectedItems(_controller.value);
  }

  Color getFillColor(BuildContext ctx) {
    if (!widget.enabled) return context.colorTheme.basic4Reverse;
    if (_controller.value.isNotEmpty) {
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
    // _dropdownKey.currentState?.getPopupState.ITEM;
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
                    builder: (context, value, child) {
                      return DropdownSearch<T>.multiSelection(
                        key: _dropdownKey,
                        enabled: widget.enabled,
                        compareFn: _compare,
                        selectedItems: value,
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
                        validator: (List<T>? value) {
                          final error = widget.validator?.call(value);
                          return error;
                        },

                        dropdownBuilder:
                            (context, selectedItems) => Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: _SelectedItemListBuilder(
                                onRemove: (item) {
                                  _controller.deleteItem(item);
                                },
                                items: selectedItems,

                                itemAsString: widget.itemAsString,
                                itemBuilder: widget.selectedItemBuilder,
                                color: color,
                              ),
                            ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: AppInputDecoration.inputDecoration(
                            context,
                            prefixIcon: widget.prefixIcon,
                            showBorder: widget.showBoder,
                            hintText: widget.hintText,
                            fillColor: getFillColor(context),
                            hintStyle: widget.hintStyle,
                            enabled: widget.enabled,
                            padding:
                                widget.title != null
                                    ? const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 28,
                                    ).copyWith(bottom: 10)
                                    : const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                            isFilled: true,
                          ),
                        ),
                        filterFn:
                            widget.asyncConfig != null
                                ? widget.searchCompare
                                : null,
                        popupProps: PopupPropsMultiSelection.dialog(
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
                          containerBuilder:
                              (context, child) => Container(
                                padding: const EdgeInsets.all(16),
                                child: child,
                              ),
                          dialogProps: DialogProps(
                            backgroundColor: context.colorTheme.basic12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          title: Column(
                            children: [
                              if (widget.dialogTitle != null ||
                                  widget.dialogSubtitle != null)
                                _MultiSelectDialogHeader(
                                  widget: widget,
                                  color: color,
                                ),

                              // _SelectedItemListBuilder(
                              //   items: _controller.value,
                              //   itemAsString: widget.itemAsString,
                              //   itemBuilder: widget.selectedItemBuilder,
                              //   color: color,

                              //   onRemove: _controller.deleteItem,
                              // ),
                              // 16.verticalSpace,
                            ],
                          ),
                          loadingBuilder:
                              (_, __) => widget.onLoading ?? _defaultLoading(),
                          fit: FlexFit.loose,
                          emptyBuilder:
                              widget.emptyWidget != null
                                  ? (_, __) => widget.emptyWidget!
                                  : null,
                          showSelectedItems: true,

                          itemBuilder:
                              (context, item, isSelected, _) => _DropdownItem(
                                padding: widget.itemPading,
                                isSelected: item == _controller.value,
                                data: item,
                                itemAsString: widget.itemAsString,
                                itemBuilder: widget.dialogItemBuilder,
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

class _MultiSelectDialogHeader extends StatelessWidget {
  const _MultiSelectDialogHeader({required this.widget, required this.color});

  final NTIMultiSelect widget;
  final ColorTheme color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 24.bottomPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.dialogTitle != null)
            Text(
              widget.dialogTitle ?? '',
              style: context.text.lg.bold.applyColor(color.basic3),
            ),
          if (widget.dialogSubtitle != null)
            Padding(
              padding: 2.topPadding,
              child: Text(
                widget.dialogSubtitle ?? '',
                style: context.text.base.applyColor(color.basic3),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectedItemListBuilder<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item)? itemAsString;
  final NTIMultiSelectedSelectedtemBuilder<T>? itemBuilder;
  final ColorTheme color;
  final void Function(T item) onRemove;
  const _SelectedItemListBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemAsString,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children:
          items
              .map(
                (item) =>
                    itemBuilder?.call(context, item, () => onRemove(item)) ??
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: color.basic8),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            itemAsString?.call(item) ?? item.toString(),
                            style: context.text.sm.medium.applyColor(
                              color.basic3,
                            ),
                          ),
                          8.w.horizontalSpace,
                          InkWell(
                            onTap: () => onRemove(item),
                            child: AppIcon(AppIcons.closeCircle, height: 16.r),
                          ),
                        ],
                      ),
                    ),
              )
              .toList(),
    );
  }
}
