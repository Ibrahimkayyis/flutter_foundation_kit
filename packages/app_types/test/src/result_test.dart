import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';

void main() {
  test('TEST RESULT', () {
    const result = Result(data: "DATA", message: "MESSAGE");
    expect(result.data, "DATA");
    expect(result.message, "MESSAGE");
  });

  test('TEST API RESULT', () {
    const apiResult = APIResult(data: "DATA", message: "MESSAGE", code: 200);
    expect(apiResult.data, "DATA");
    expect(apiResult.message, "MESSAGE");
    expect(apiResult.code, 200);
    final result = apiResult.asRepoResult;
    expect(result, isA<Result>());
    expect(result.data, "DATA");
    expect(result.message, "MESSAGE");
  });
}
