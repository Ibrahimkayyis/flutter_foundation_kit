part of 'base_exception.dart';

class SessionException extends BaseException {
  static const sessionExceptionKey = "SESSION_EXCEPTION";

  const SessionException({String? message})
    : super(message ?? sessionExceptionKey);
}
