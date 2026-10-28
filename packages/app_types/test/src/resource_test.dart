import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';

void main() {
  test('TEST SUCCESS RESOURCE', () {
    const data = "DATA";
    const message = "MESSAGE";
    final resource = Resource.success(data, message);
    expect(resource.data, data);
    expect(resource.isSuccess, true);
    expect(resource.isError, false);
    expect((resource as Success).message, message);
  });

  test('TEST ERROR RESOURCE', () {
    const message = "MESSAGE";
    const exception = BaseException(message);
    final resource = Resource.error<String>(exception);
    expect(resource.data, null);
    expect(resource.isError, true);
    expect(resource.isSuccess, false);
    expect(resource is Error, true);
    expect((resource as Error).exception, exception);
    expect(resource.exception?.message, message);
  });
}
