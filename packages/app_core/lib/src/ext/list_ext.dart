extension IterableExtension<E> on Iterable<E> {
  int get lastIndex => length - 1;

  bool isLastIndex(int index) => index == lastIndex;

  Iterable<T> mapIndexed<T>(T Function(int index, E item) mapper) {
    return Iterable.generate(
      length,
      (index) => mapper(index, elementAt(index)),
    );
  }

  E? getAtOrNull(int index) {
    if (index < length && index >= 0) return elementAt(index);
    return null;
  }

  Iterable<T> whereMap<T>(
    T Function(E item) mapper,
    bool Function(E item) condition,
  ) {
    final List<T> result = [];
    for (final element in this) {
      if (condition(element)) {
        result.add(mapper(element));
      }
    }
    return result;
  }

  Iterable<T> whereMapIndexed<T>(
    T Function(int newIndex, int oldIndex, E item) mapper,
    bool Function(int index, E item) condition,
  ) {
    final List<T> result = [];
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) {
        result.add(mapper(result.length, i, element));
      }
    }
    return result;
  }

  E? firstWhereOrNull<T>(bool Function(int index, E item) condition) {
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) return element;
    }
    return null;
  }

  int? indexWhereOrNull<T>(bool Function(int index, E item) condition) {
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) return i;
    }
    return null;
  }

  Map<Key, Value> toMap<Key, Value>(
    MapEntry<Key, Value> Function(E item) mapper,
  ) {
    final Map<Key, Value> result = {};
    for (final element in this) {
      final mapped = mapper(element);
      result[mapped.key] = mapped.value;
    }
    return result;
  }

  bool equalTo(Iterable<E> other, {bool Function(E a, E b)? compareFunc}) {
    final a = this;
    final b = other;
    final bool Function(E a, E b) compare = compareFunc ?? (a, b) => a == b;
    if (a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      final compareResult = compare(a.elementAt(index), b.elementAt(index));
      if (!compareResult) return false;
    }
    return true;
  }
}
