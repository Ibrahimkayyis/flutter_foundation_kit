part of '../api_client.dart';

class DioCustomException extends DioException {
  final BaseException baseException;

  DioCustomException({
    required super.requestOptions,
    required super.response,
    required this.baseException,
    super.error,
    super.message,
    super.stackTrace,
  }) : super(type: DioExceptionType.badResponse);
}

typedef DioOdooCustomException = DioCustomException;

class OdooErrorInterceptor extends Interceptor {
  OdooErrorInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final bool isError = response.data is Map && response.data["error"] != null;
      if (isError) return _handleError(response, handler);
      return _handleSuccess(response, handler);
    } catch (e, stackTrace) {
      debugPrint("Error OdooErrorInterceptor: $e");
      debugPrintStack(stackTrace: stackTrace);
      return handler.next(response);
    }
  }

  void _handleSuccess(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map && response.data.containsKey("result")) {
      final newResponse = Response(
        data: response.data["result"],
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        extra: response.extra,
        headers: response.headers,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        statusMessage: response.statusMessage,
      );
      return handler.next(newResponse);
    }
    return handler.next(response);
  }

  void _handleError(Response response, ResponseInterceptorHandler handler) {
    final error = response.data["error"];
    final errorMessage = error["message"]?.toString() ?? "Odoo Error";
    final errorCode = error["code"];
    switch (errorCode) {
      case 100:
        handler.reject(
          DioCustomException(
            baseException: SessionException(message: errorMessage),
            requestOptions: response.requestOptions,
            response: Response(
              data: response.data,
              requestOptions: response.requestOptions,
              statusCode: APIResponseCode.unauthorised.statusCode,
              extra: response.extra,
              headers: response.headers,
              statusMessage: response.statusMessage,
              isRedirect: response.isRedirect,
              redirects: response.redirects,
            ),
            message: errorMessage,
          ),
        );
        break;
      default:
        handler.reject(
          DioCustomException(
            baseException: APIResponseCode.defaultError.toNetworkException(
              response.requestOptions.path,
              errorMessage,
            ),
            requestOptions: response.requestOptions,
            response: response,
            message: errorMessage,
          ),
        );
    }
  }
}
