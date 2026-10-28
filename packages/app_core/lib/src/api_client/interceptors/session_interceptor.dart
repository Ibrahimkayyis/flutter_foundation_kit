part of '../api_client.dart';

class SessionInterceptor extends Interceptor {
  final FutureOr<APISession?> Function()? getUserSession;

  SessionInterceptor({this.getUserSession});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final getUserSession = this.getUserSession;
      if (getUserSession == null) {
        return handler.next(options);
      }
      final session = await getUserSession();
      if (session == null) {
        return handler.next(options);
      }
      return handler.next(
        options.copyWith(
          headers: {
            ...options.headers,
            if (session.headers != null) ...session.headers!,
          },
          queryParameters: {
            ...options.queryParameters,
            if (session.query != null) ...session.query!,
          },
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("Error SessionInterceptor: $e");
      debugPrintStack(stackTrace: stackTrace);
      return handler.next(options);
    }
  }

  dynamic expandData(dynamic data, Map<String, dynamic>? body) {
    if (data == null || body == null) return data;
    if (data is FormData) {
      data.fields.addAll(
        body.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }
    return {...(data ?? {}), ...body};
  }
}
