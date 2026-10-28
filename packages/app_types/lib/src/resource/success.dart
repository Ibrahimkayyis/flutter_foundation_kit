part of 'resource.dart';

class Success<T> extends Resource<T> {
  @override
  final T data;
  final String message;

  const Success(this.data, this.message);

  Success<Y> map<Y>(Y Function(T data) map) {
    return Success(map(data), message);
  }
}
