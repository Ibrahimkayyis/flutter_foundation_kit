part of 'api_client.dart';

enum APIResponseCode {
  success(statusCode: 200, message: 'SUCCESS'),
  noContent(statusCode: 201, message: 'NO_CONTENT'),
  badRequest(statusCode: 400, message: 'BAD_REQUEST'),
  unauthorised(statusCode: 401, message: 'UNAUTHORISED'),
  forbidden(statusCode: 403, message: 'FORBIDDEN'),
  notFound(statusCode: 404, message: 'NOT_FOUND'),
  invalidData(statusCode: 422, message: 'INVALID_DATA'),
  internalServerError(statusCode: 500, message: 'INTERNAL_SERVER_ERROR'),

  // LOCAL STATUS CODE
  connectTimeout(statusCode: -1, message: 'CONNECT_TIMEOUT'),
  cancel(statusCode: -2, message: 'CANCEL'),
  receiveTimeout(statusCode: -3, message: 'RECEIVE_TIMEOUT'),
  sendTimeout(statusCode: -4, message: 'SEND_TIMEOUT'),
  cacheError(statusCode: -5, message: 'CACHE_ERROR'),
  noInternetConnection(statusCode: -6, message: 'NO_INTERNET_CONNECTION'),
  locationDenied(statusCode: -7, message: 'LOCATION_DENIED'),
  defaultError(statusCode: -8, message: 'DEFAULT_ERROR'),
  connectionError(statusCode: -9, message: 'CONNECTION_ERROR'),
  parsingJSONError(statusCode: -10, message: 'PARSING_JSON_ERROR');

  final int statusCode;
  final String message;

  const APIResponseCode({required this.statusCode, required this.message});

  static APIResponseCode fromStatusCode(int statusCode) {
    return APIResponseCode.values.firstWhereOrNull(
          (index, element) => element.statusCode == statusCode,
        ) ??
        APIResponseCode.defaultError;
  }

  NetworkException toNetworkException([
    String? url,
    String? newMessage,
    String? exceptionMessage,
  ]) {
    return NetworkException(
      newMessage ?? message,
      statusCode: statusCode,
      url: url ?? "UNKNOWN_URL",
      exceptionMessage: exceptionMessage,
    );
  }
}
