part of 'base_exception.dart';

class NetworkException extends BaseException {
  final String url;
  final int statusCode;

  /// REAL EXCEPTION MESSAGE (WHILE [BaseException.message] is a user readable message)
  final String? exceptionMessage;

  const NetworkException(
    super.message, {
    required this.statusCode,
    required this.url,
    this.exceptionMessage,
  });

  @override
  List<Object?> get props => [message, statusCode, url, exceptionMessage];
}

class ConnectionException extends NetworkException {
  const ConnectionException({int? statusCode, required String url})
    : super("CONNECTION_EXCEPTION", statusCode: statusCode ?? -1, url: url);

  @override
  List<Object?> get props => [message, statusCode];
}
