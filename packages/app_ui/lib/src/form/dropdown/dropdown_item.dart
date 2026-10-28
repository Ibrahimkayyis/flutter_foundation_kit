part of 'dropdown.dart';

class _DropdownSelectedItem<T> extends StatelessWidget {
  const _DropdownSelectedItem({
    super.key,
    required this.selectedBuilder,
    this.itemAsString,
    required this.data,
  });

  final T? data;
  final String Function(T data)? itemAsString;
  final Widget? Function(BuildContext context, T? data)? selectedBuilder;

  Widget child(BuildContext context) {
    final selectedBuilder = this.selectedBuilder;
    return selectedBuilder?.call(context, data) ??
        DecoratedBox(
          decoration: BoxDecoration(
            color:
                data != null
                    ? Colors.transparent
                    : context.colorTheme.basic4Reverse,
          ),
          child: Text(
            shownItem,
            style: TextStyle(
              fontSize: 16,
              color: context.colorTheme.basic10Reverse,
            ),
          ),
        );
  }

  String get shownItem {
    final data = this.data;
    if (data == null) return "";
    final itemString =
        itemAsString != null ? itemAsString!(data) : data.toString();
    return itemString;
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: child(context));
  }
}

class _DropdownItem<T> extends StatelessWidget {
  const _DropdownItem({
    super.key,
    required this.padding,
    required this.isSelected,
    this.itemAsString,
    this.itemBuilder,
    required this.data,
  });

  final EdgeInsets padding;
  final bool isSelected;
  final T data;
  final String Function(T data)? itemAsString;
  final Widget Function(BuildContext context, T data, bool isSelected)?
  itemBuilder;

  Widget child(BuildContext context) {
    if (itemBuilder != null) return itemBuilder!(context, data, isSelected);
    final itemString =
        itemAsString != null ? itemAsString!(data) : data.toString();
    return Text(
      itemString,
      style: TextStyle(fontSize: 16, color: context.colorTheme.basic10Reverse),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            isSelected
                ? context.colorTheme.basic4Reverse
                : context.colorTheme.basic1Reverse,
      ),
      child: child(context),
    );
  }
}
