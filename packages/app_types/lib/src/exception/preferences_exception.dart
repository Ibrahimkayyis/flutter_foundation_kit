part of 'base_exception.dart';

class PreferencesException extends BaseException {
  static const preferencesExceptionKey = "PREFERENCES_EXCEPTION";

  const PreferencesException({String? message})
    : super(message ?? preferencesExceptionKey);
}
