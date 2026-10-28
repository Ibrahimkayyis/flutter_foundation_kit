import 'package:app_types/src/resource/resource.dart';

class Result<T> {
  final T data;
  final String message;

  const Result({required this.data, required this.message});

  Resource<T> get asResource => Resource.success(data, message);

  Result<Y> copyWith<Y>({required Y data, String? message}) =>
      Result(data: data, message: message ?? this.message);
}

extension FutureValueExt<T> on Future<T> {
  Future<Result<T>> asResult({String message = ""}) async =>
      Result(data: await this, message: message);
}

extension FutureResultExt<T> on Future<Result<T>> {
  Future<T> get dataFuture async => (await this).data;
}
