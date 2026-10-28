part of 'form_builder.dart';

class _NTIFormItem<T> {
  final String key;
  final T data;

  _NTIFormItem(this.key, this.data);
}

class NTIFormList<T> extends StatefulWidget {
  final List<T> initialValues;
  final void Function(List<T> t)? onSaved;
  final Widget Function(List<Widget> builder, VoidCallback onAdd) widgetBuiler;
  final NTIFormListController<T>? controller;
  final Future<T?> Function(int index)? onNew;

  final Function(
    String key,
    int index,
    T value,
    void Function() onAdd,
    void Function() onRemove,
    void Function(T) onChange,
  )
  itemBuilder;

  const NTIFormList({
    super.key,
    this.onSaved,
    required this.widgetBuiler,
    this.controller,
    required this.itemBuilder,
    this.initialValues = const [],
    this.onNew,
  });

  @override
  State<NTIFormList<T>> createState() => _NTIFormListState<T>();
}

class NTIFormListController<T> extends ValueNotifier<List<_NTIFormItem<T>>> {
  NTIFormListController({List<T> initial = const []})
    : super(
        initial
            .map((e) => _NTIFormItem(DateTime.now().toIso8601String(), e))
            .toList(),
      );

  void insert(T data) {
    insertAt(value.length, data);
  }

  void insertAll(List<T> data) {
    insertAllAt(value.length, data);
    notifyListeners();
  }

  void insertAllAt(int index, List<T> data) {
    value.insertAll(
      index,
      data.map((e) => _NTIFormItem(DateTime.now().toIso8601String(), e)),
    );
  }

  void insertAt(int index, T data) {
    value.insert(index, _NTIFormItem(DateTime.now().toIso8601String(), data));
    notifyListeners();
  }

  void swap(int firstIndex, int secondIndex) {
    final firstValue = value[firstIndex];
    final secondValue = value[secondIndex];
    value[firstIndex] = secondValue;
    value[secondIndex] = firstValue;
    notifyListeners();
  }

  void removeAt(int index) {
    value.removeAt(index);
    notifyListeners();
  }

  void replaceAt(int index, T data) {
    final currentData = value.length > index ? value[index] : null;
    if (currentData == null) return;
    value[index] = _NTIFormItem(currentData.key, data);
    notifyListeners();
  }
}

class _NTIFormListState<T> extends State<NTIFormList<T>> {
  late final NTIFormListController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        NTIFormListController(initial: widget.initialValues);
  }

  void _onAdd(int index) async {
    final newValue = await widget.onNew?.call(index);
    if (newValue == null) return;
    _controller.insertAt(index + 1, newValue);
  }

  void _onRemove(int index) {
    _controller.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      onSaved:
          (onSaved) => widget.onSaved?.call(
            _controller.value.map((e) => e.data).toList(),
          ),
      builder:
          (state) => ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              return widget.widgetBuiler(
                value.mapIndexed(
                  (i, e) => SizedBox(
                    key: Key(e.key),
                    child: widget.itemBuilder(
                      e.key,
                      i,
                      e.data,
                      () => _onAdd(i),
                      () => _onRemove(i),
                      (data) => _controller.replaceAt(i, data),
                    ),
                  ),
                ),
                () => _onAdd(value.length - 1),
              );
            },
          ),
    );
  }
}

extension _ListExtension<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E item) mapper) {
    return List.generate(length, (index) => mapper(index, this[index]));
  }
}
