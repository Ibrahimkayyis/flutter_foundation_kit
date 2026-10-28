import 'package:app_types/src/exception/base_exception.dart';
import 'package:app_types/src/result/result.dart';

part 'success.dart';
part 'error.dart';

sealed class Resource<T> {
  static Resource<T> success<T>(T data, String message) =>
      Success<T>(data, message);

  static Resource<T> error<T>(BaseException exception) => Error<T>(exception);

  const Resource();

  static Future<Resource<(T, Y)>> merge2<T, Y>(
    Future<Resource<T>> Function() first,
    Future<Resource<Y>> Function() second,
  ) async {
    final firstCall = first();
    final secondCall = second();
    final firstResult = await firstCall;
    final secondResult = await secondCall;
    if (firstResult is Success<T> && secondResult is Success<Y>) {
      return Success<(T, Y)>((
        firstResult.data,
        secondResult.data,
      ), 'Both operations succeeded');
    } else if (firstResult is Error<T>) {
      return Error<(T, Y)>(firstResult.exception);
    } else if (secondResult is Error<Y>) {
      return Error<(T, Y)>(secondResult.exception);
    } else {
      throw Exception('Unexpected state');
    }
  }

  void when({
    void Function(T data)? success,
    void Function(BaseException exception)? error,
  }) {
    final current = this;
    switch (current) {
      case Success():
        success?.call(current.data);
        return;
      case Error():
        error?.call(current.exception);
        return;
    }
  }

  T? get data => this is Success<T> ? (this as Success<T>).data : null;

  BaseException? get exception =>
      this is Error<T> ? (this as Error<T>).exception : null;

  bool get isSuccess => this is Success<T>;

  bool get isError => this is Error<T>;
}

extension ResourceFutureExt<T> on Future<Resource<T>> {
  Future<Resource<Y>> mapWhenSucces<Y>(
    Y Function(Success<T> result) map,
  ) async {
    final result = await this;
    switch (result) {
      case Success():
        final mappedResult = map(result);
        return Success(mappedResult, result.message);
      case Error():
        return Error(result.exception);
    }
  }

  Future<T> getDataOrDefault(T defaultValue) async {
    final result = await this;
    switch (result) {
      case Success():
        return (result).data;
      case Error():
        return defaultValue;
    }
  }
}

extension RepoResultResourceExt<T> on Future<Result<T>> {
  Future<Resource<T>> get asFutureResource async {
    return (await this).asResource;
  }
}
