part of '../api_client.dart';

class HttpStatusCodeInterceptor extends Interceptor {
  final StatusCodeExtractor? statusCodeExtractor;
  final StatusCodeValidator statusCodeValidator;

  HttpStatusCodeInterceptor({
    this.statusCodeExtractor,
    required this.statusCodeValidator,
  });

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final statusCode =
          statusCodeExtractor?.call(response.statusCode ?? 200, response.data) ??
          response.statusCode;
      final isValid = statusCodeValidator(statusCode);
      if (!isValid) {
        final exception = DioException.badResponse(
          statusCode: statusCode ?? APIResponseCode.defaultError.statusCode,
          requestOptions: response.requestOptions,
          response: Response(
            statusCode: statusCode,
            data: response.data,
            requestOptions: response.requestOptions,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            statusMessage: response.statusMessage,
          ),
        );
        handler.reject(exception);
        return;
      }
      final newResponse = Response(
        data: response.data,
        requestOptions: response.requestOptions,
        statusCode: statusCode,
        extra: response.extra,
        headers: response.headers,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        statusMessage:
            statusCode != null
                ? APIResponseCode.fromStatusCode(statusCode).message
                : null,
      );
      super.onResponse(newResponse, handler);
    } catch (e, stackTrace) {
      debugPrint("Error StatusCodeInterceptor: $e");
      debugPrintStack(stackTrace: stackTrace);
      return handler.next(response);
    }
  }
}
