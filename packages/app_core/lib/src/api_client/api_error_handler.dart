part of 'api_client.dart';

typedef StatusCodeExtractor = int Function(int statusCode, dynamic body);
typedef StatusCodeValidator = bool Function(int? statusCode);

abstract class ApiErrorHandler {
  final String Function(int statusCode, dynamic body)? messageHandler;
  final BaseException? Function(int statusCode, dynamic body)? onError;
  final StatusCodeExtractor? statusCodeExtractor;
  final StatusCodeValidator? statusCodeValidator;

  factory ApiErrorHandler.defaultHandler({
    String Function(int statusCode, dynamic body)? messageHandler,
    BaseException? Function(int statusCode, dynamic body)? onError,
    int Function(int statusCode, dynamic body)? statusCodeExtractor,
    StatusCodeValidator? statusCodeValidator,
  }) {
    return APIErrorHandlerImpl(
      messageHandler: messageHandler,
      onError: onError,
      statusCodeExtractor: statusCodeExtractor,
      statusCodeValidator: statusCodeValidator,
    );
  }

  const ApiErrorHandler({
    this.messageHandler,
    this.onError,
    this.statusCodeExtractor,
    this.statusCodeValidator,
  });

  BaseException handleError(dynamic error, String url);
}

class APIErrorHandlerImpl extends ApiErrorHandler {
  const APIErrorHandlerImpl({
    super.messageHandler,
    super.onError,
    super.statusCodeExtractor,
    super.statusCodeValidator,
  });

  @override
  BaseException handleError(dynamic error, String url) {
    if (error is DioCustomException) return error.baseException;
    if (error is DioException) return _handleDioException(error, url);
    if (error is BaseException) return error;
    return APIResponseCode.defaultError.toNetworkException(url);
  }

  BaseException _handleDioException(DioException error, String url) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return APIResponseCode.connectTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.sendTimeout:
        return APIResponseCode.sendTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.receiveTimeout:
        return APIResponseCode.receiveTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error, url);
      case DioExceptionType.cancel:
        return APIResponseCode.cancel.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.connectionError:
        return APIResponseCode.connectionError.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      default:
        return _handleDefaultError(error);
    }
  }

  BaseException _handleBadResponse(DioException error, String url) {
    try {
      if (error is DioCustomException) {
        return error.baseException;
      }
      final statusCode = _getStatusCode(error);
      final responseCode = APIResponseCode.fromStatusCode(statusCode);
      final message = messageHandler?.call(statusCode, error.response?.data);
      final handledError = onError?.call(statusCode, error.response?.data);
      if (handledError != null) return handledError;
      switch (responseCode) {
        case APIResponseCode.unauthorised:
          return SessionException(message: message);
        default:
          return responseCode.toNetworkException(
            url,
            message,
            error.response?.statusMessage,
          );
      }
    } catch (e, stackTrace) {
      debugPrint("Error _handleBadResponse: $e");
      debugPrintStack(stackTrace: stackTrace);
      return APIResponseCode.defaultError.toNetworkException();
    }
  }

  int _getStatusCode(DioException error) {
    return error.response?.statusCode ?? APIResponseCode.defaultError.statusCode;
  }

  BaseException _handleDefaultError(DioException error) {
    if (error.response?.statusCode ==
        APIResponseCode.noInternetConnection.statusCode) {
      return APIResponseCode.noInternetConnection.toNetworkException();
    } else {
      return APIResponseCode.defaultError.toNetworkException();
    }
  }
}
