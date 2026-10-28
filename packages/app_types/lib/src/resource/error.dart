part of 'resource.dart';

class Error<T> extends Resource<T> {
  @override
  final BaseException exception;

  const Error(this.exception);
}
