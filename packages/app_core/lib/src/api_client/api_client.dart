import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:app_types/app_types.dart';
import '../ext/list_ext.dart';

part 'mocked_result.dart';
part 'api_client_impl.dart';
part 'api_session.dart';
part 'response_code.dart';
part 'api_error_handler.dart';
part 'interceptors/body_wrapper_interceptor.dart';
part 'interceptors/status_code_interceptor.dart';
part 'interceptors/session_interceptor.dart';
part 'interceptors/odoo_interceptor.dart';

typedef MapFromNetwork<T> = T Function(APIResponse response);
typedef RequestBodyBaseWrapper = Map<String, dynamic> Function(dynamic body);
typedef SessionCallback = Future<APISession?> Function();

abstract class APIClient {
  final String baseURL;
  final String Function(int statusCode, dynamic body)? successMessageHandler;
  final ApiErrorHandler handler;
  final SessionCallback? sessionHandler;
  final RequestBodyBaseWrapper? requestBodyBaseWrapper;

  const APIClient({
    required this.handler,
    required this.baseURL,
    this.successMessageHandler,
    this.requestBodyBaseWrapper,
    this.sessionHandler,
  });

  Future<APIResponse> post<T>({
    required String path,
    Map<String, String>? headers,
    JSON? body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  Future<APIResponse> get<T>({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    JSON? body,
    MockedResult? mockResult,
  });

  Future<APIResponse> delete<T>({
    required String path,
    Map<String, String>? headers,
    JSON? body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  Future<APIResponse> put<T>({
    required String path,
    Map<String, String>? headers,
    JSON? body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });
}

class APIResponse {
  final String url;
  final JSON data;
  final int statusCode;
  final String message;
  final Map<String, dynamic> headers;
  final APISession? session;

  APIResponse({
    required this.data,
    this.url = "UNKNOWN_URL",
    required this.statusCode,
    required this.message,
    required this.headers,
    this.session,
  });
}

extension APIClientExtension on Future<APIResponse> {
  Future<APIResult<Result>> map<Result>(
    MapFromNetwork<Result> mapper, {
    bool shouldPrint = false,
  }) async {
    final result = await this;
    return APIResult(
      data: _tryMapResult(result, result.url, mapper, shouldPrint: shouldPrint),
      message: result.message,
      code: result.statusCode,
    );
  }

  Future<APIResult<Nothing>> toNothing({bool shouldPrint = false}) =>
      map((_) => const Nothing(), shouldPrint: shouldPrint);

  Result _tryMapResult<Result>(
    APIResponse response,
    String url,
    MapFromNetwork<Result> mapper, {
    bool shouldPrint = false,
  }) {
    try {
      return mapper(response);
    } catch (e, stackTrace) {
      if (shouldPrint) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
      throw APIResponseCode.parsingJSONError.toNetworkException(
        url,
        APIResponseCode.parsingJSONError.message,
        e.toString(),
      );
    }
  }
}
