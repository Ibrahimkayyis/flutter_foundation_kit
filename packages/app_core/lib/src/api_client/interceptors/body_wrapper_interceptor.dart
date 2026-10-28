part of '../api_client.dart';

class BodyWrapperInterceptor extends Interceptor {
  final RequestBodyBaseWrapper requestBodyBaseWrapper;

  BodyWrapperInterceptor({required this.requestBodyBaseWrapper});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = options.data;
    if (data is FormData) {
      return handler.next(options);
    }
    try {
      final newData = requestBodyBaseWrapper(data);
      final newOptions = options.copyWith(data: newData);
      return super.onRequest(newOptions, handler);
    } catch (e, stackTrace) {
      debugPrint("Error BodyWrapperInterceptor: $e");
      debugPrintStack(stackTrace: stackTrace);
      return handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }
}
