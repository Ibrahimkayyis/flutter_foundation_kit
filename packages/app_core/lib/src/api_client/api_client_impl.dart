part of 'api_client.dart';

class APIClientImpl extends APIClient {
  final Dio _dio;
  final bool isOdoo;
  final List<Interceptor>? customInterceptors;

  APIClientImpl({
    this.isOdoo = false,
    this.customInterceptors,
    required super.baseURL,
    super.handler = const APIErrorHandlerImpl(),
    super.successMessageHandler,
    super.requestBodyBaseWrapper,
    super.sessionHandler,
    Dio? dio,
  }) : _dio = _DioFactory._createDio(
         baseURL,
         inputDio: dio,
         isOdoo: isOdoo,
         customInterceptors: customInterceptors,
         sessionHandler: sessionHandler,
         requestBodyBaseWrapper: requestBodyBaseWrapper,
         statusCodeExtractor: handler.statusCodeExtractor,
       );

  Options _getOptions(
    Map<String, String>? headers, {
    bool shouldPrint = false,
  }) {
    return Options(headers: headers, extra: {"shouldPrint": shouldPrint});
  }

  @override
  Future<APIResponse> delete<T>({
    required String path,
    Map<String, String>? headers,
    body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request:
        () => _dio.delete(
          path,
          options: _getOptions(headers, shouldPrint: shouldPrint),
          data: body,
          queryParameters: query,
        ),
  );

  @override
  Future<APIResponse> get<T>({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    body,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request:
        () => _dio.get(
          path,
          options: _getOptions(headers, shouldPrint: shouldPrint),
          data: body ?? {},
          queryParameters: query,
        ),
  );

  @override
  Future<APIResponse> post<T>({
    required String path,
    Map<String, String>? headers,
    body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request:
        () => _dio.post(
          path,
          options: _getOptions(headers, shouldPrint: shouldPrint),
          data: body,
          queryParameters: query,
        ),
  );

  @override
  Future<APIResponse> put<T>({
    required String path,
    Map<String, String>? headers,
    body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request:
        () => _dio.put(
          path,
          options: _getOptions(headers, shouldPrint: shouldPrint),
          data: body,
          queryParameters: query,
        ),
  );

  Response _mockRequest(MockedResult mockedResult, String path) {
    return Response(
      requestOptions: RequestOptions(path: path),
      data: mockedResult.result,
      headers: Headers.fromMap({
        for (var entry in mockedResult.headers.entries)
          entry.key: [entry.value],
      }),
      statusCode: mockedResult.statusCode,
    );
  }

  Future<APIResponse> _handleRequest<T>({
    required String path,
    required Map<String, String>? headers,
    required body,
    required Future<Response> Function() request,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    try {
      final response =
          mockResult != null ? _mockRequest(mockResult, path) : await request();
      final statusCode = response.statusCode ?? 0;
      return APIResponse(
        url: response.realUri.toString(),
        data: response.data,
        message: successMessageHandler?.call(statusCode, response.data) ?? "",
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } catch (e, stackTrace) {
      if (shouldPrint) {
        debugPrint("Error APIClientImpl: $e");
        debugPrintStack(stackTrace: stackTrace);
      }
      throw handler.handleError(e, path);
    }
  }
}

class _DioFactory {
  static const int apiTimeOut = 60000;

  static bool _defaultStatusCodeValidator(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  static Dio _createDio(
    String baseUrl, {
    Dio? inputDio,
    StatusCodeValidator? statusCodeValidator,
    StatusCodeExtractor? statusCodeExtractor,
    RequestBodyBaseWrapper? requestBodyBaseWrapper,
    SessionCallback? sessionHandler,
    bool isOdoo = false,
    List<Interceptor>? customInterceptors,
  }) {
    final dio = inputDio ?? Dio(BaseOptions());
    final effectiveStatusCodeValidator =
        statusCodeValidator ?? _defaultStatusCodeValidator;

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      headers: {},
      validateStatus: effectiveStatusCodeValidator,
      receiveTimeout: const Duration(milliseconds: apiTimeOut),
      sendTimeout: const Duration(milliseconds: apiTimeOut),
      connectTimeout: const Duration(milliseconds: apiTimeOut),
    );

    if (sessionHandler != null) {
      dio.interceptors.add(SessionInterceptor(getUserSession: sessionHandler));
    }
    if (requestBodyBaseWrapper != null) {
      dio.interceptors.add(
        BodyWrapperInterceptor(requestBodyBaseWrapper: requestBodyBaseWrapper),
      );
    }
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          filter: (options, args) => options.extra["shouldPrint"] == true,
        ),
      );
    }

    if (customInterceptors != null && customInterceptors.isNotEmpty) {
      dio.interceptors.addAll(customInterceptors);
    }

    if (isOdoo) {
      dio.interceptors.add(OdooErrorInterceptor());
    }

    dio.interceptors.add(
      HttpStatusCodeInterceptor(
        statusCodeExtractor: statusCodeExtractor,
        statusCodeValidator: effectiveStatusCodeValidator,
      ),
    );

    return dio;
  }
}
