extension DynamicExt<T extends dynamic> on T {
  Y let<Y>(Y Function(T value) fun) => fun(this);

  void run(void Function(T value) fun) => fun(this);
}
