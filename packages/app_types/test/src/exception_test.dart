import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';

void main() {
  test('TEST BASE EXCEPTION', () {
    const exception = BaseException("BASE_EXCEPTION");
    expect(exception.message, 'BASE_EXCEPTION');
  });

  test('UNKNOWN EXCEPTION', () {
    final exception = BaseException.unknownError();
    expect(exception.message, UnknownException.unknownExceptionKey);
  });

  test('SESSION EXCEPTION', () {
    const exception = SessionException();
    expect(exception.message, SessionException.sessionExceptionKey);
  });

  test('NETWORK EXCEPTION', () {
    const exception = NetworkException(
      "PAGE_NOT_FOUND",
      statusCode: 404,
      url: "https://www.google.com",
    );
    expect(exception.message, "PAGE_NOT_FOUND");
    expect(exception.statusCode, 404);
  });

  test('FORM EXCEPTION', () {
    const exception = FormException("API_EXCEPTION", {
      "email": ["Email is required"],
      "password": ["Password is required"],
    });
    expect(exception.message, "API_EXCEPTION");
    expect(exception.errors, {
      "email": ["Email is required"],
      "password": ["Password is required"],
    });
    expect(exception.flattenError, {
      "email": "Email is required",
      "password": "Password is required",
    });
  });
}
