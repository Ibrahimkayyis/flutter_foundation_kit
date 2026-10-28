import 'dart:io';

import 'package:app_types/app_types.dart';

/// Config For Usecase
/// [onSessionException] : Function to handle session exception
/// [errorLogger] : Function to log error
class UsecaseConfig {
  final UsecaseSessionException? onSessionException;
  final UsecaseErrorLogger? errorLogger;

  const UsecaseConfig({this.onSessionException, this.errorLogger});
}

typedef UsecaseSessionException = Future<void> Function(SessionException e);
typedef UsecaseErrorLogger = void Function(Object e, StackTrace stackTrace);

UsecaseErrorLogger? _errorLogger;
UsecaseSessionException? _sessionException;

/// Util For Usecase
class UsecaseUtil {
  /// Set All Usecase Config
  static void setConfig(UsecaseConfig? config) {
    if (config == null) return;
    setErrorLogger(config.errorLogger);
    setSessionException(config.onSessionException);
  }

  /// Set Error Logger
  static void setErrorLogger(UsecaseErrorLogger? errorLogger) {
    _errorLogger = errorLogger;
  }

  /// Set Session Exception
  static void setSessionException(UsecaseSessionException? onSessionException) {
    _sessionException = onSessionException;
  }
}

/// Handle Error For Usecase
Future<Resource<Result>> _handleError<Result>(
  Object e,
  StackTrace stackTrace,
) async {
  if (e is! BaseException) {
    if (e is SocketException) {
      return Resource.error(const ConnectionException(url: "UNKNOWN_URL"));
    }
    return Resource.error<Result>(BaseException.unknownError());
  }
  if (e is SessionException) await _sessionException?.call(e);
  return Resource.error(e);
}

/// Safe Call For Usecase
mixin _UsecaseSafeCall<Result> {
  Future<Resource<Result>> _safeCall(
    Future<Resource<Result>> Function() call,
  ) async {
    try {
      return await call();
    } catch (e, stacktrace) {
      _errorLogger?.call(e, stacktrace);
      return await _handleError(e, stacktrace);
    }
  }
}

/// Usecase With Params
abstract class Usecase<Params, Result> with _UsecaseSafeCall<Result> {
  /// Execute The Function
  /// Never Call This Function Directly, Use [call] Instead
  Future<Resource<Result>> execute(Params params);

  Future<Resource<Result>> call(Params params) async =>
      _safeCall(() => execute(params));
}

/// Usecase With No Params
abstract class UsecaseNoParams<Result> with _UsecaseSafeCall<Result> {
  /// Execute The Function
  /// Never Call This Function Directly, Use [call] Instead
  Future<Resource<Result>> execute();

  Future<Resource<Result>> call() => _safeCall(() => execute());
}
