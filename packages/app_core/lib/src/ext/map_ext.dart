extension MapExtension<Key, Value> on Map<Key, Value> {
  Value? getOrNull(Key key) {
    if (!containsKey(key)) return null;
    if (this[key] is Value) return this[key];
    return null;
  }

  Result? getAndMapOrNull<Result>(
    Key key,
    Result Function(Value expected) mapper,
  ) {
    if (!containsKey(key)) return null;
    final value = this[key];
    if (value is Value) return mapper(value);
    return null;
  }

  void addAllIfNotNull(Map<Key, Value>? value) {
    if (value == null) return;
    addAll(value);
  }
}
