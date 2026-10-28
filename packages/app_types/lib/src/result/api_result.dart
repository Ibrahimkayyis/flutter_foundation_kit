import 'package:app_types/src/result/result.dart';

class APIResult<T> extends Result<T> {
  final int code;

  const APIResult({
    required super.data,
    required super.message,
    required this.code,
  });

  Result<T> get asRepoResult => Result(data: data, message: message);
}
