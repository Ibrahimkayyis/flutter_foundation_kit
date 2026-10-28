import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';
import 'package:app_core/app_core.dart';

void main() {
  const baseURL = "https://api.example.com";

  group("APISession & APIResponseCode Tests", () {
    test("API Session Equatable", () {
      const session1 = APISession(
        headers: {"Authorization": "Bearer token"},
        query: {"ref": "123"},
      );
      const session2 = APISession(
        headers: {"Authorization": "Bearer token"},
        query: {"ref": "123"},
      );
      expect(session1, session2);
    });

    test("APIResponseCode mapping", () {
      expect(APIResponseCode.fromStatusCode(200), APIResponseCode.success);
      expect(APIResponseCode.fromStatusCode(401), APIResponseCode.unauthorised);
      expect(APIResponseCode.fromStatusCode(404), APIResponseCode.notFound);
      expect(APIResponseCode.fromStatusCode(999), APIResponseCode.defaultError);

      final netEx = APIResponseCode.notFound.toNetworkException("https://api.com/notfound");
      expect(netEx.statusCode, 404);
      expect(netEx.url, "https://api.com/notfound");
    });
  });

  group("APIClient Mocked Result Tests", () {
    final client = APIClientImpl(
      baseURL: baseURL,
      handler: ApiErrorHandler.defaultHandler(),
    );

    test("GET returns mocked response correctly", () async {
      const mock = MockedResult(
        statusCode: 200,
        result: {"id": 1, "name": "John"},
        headers: {"content-type": "application/json"},
      );

      final response = await client.get(
        path: "/users/1",
        mockResult: mock,
      );

      expect(response.statusCode, 200);
      expect(response.data["name"], "John");
    });

    test("POST with map extension returns typed APIResult", () async {
      const mock = MockedResult(
        statusCode: 200,
        result: {"id": 2, "name": "Jane"},
      );

      final result = await client
          .post(path: "/users", mockResult: mock)
          .map((res) => res.data["name"] as String);

      expect(result.data, "Jane");
      expect(result.code, 200);
    });

    test("DELETE with toNothing returns Nothing", () async {
      const mock = MockedResult(statusCode: 204, result: null);

      final result = await client
          .delete(path: "/users/1", mockResult: mock)
          .toNothing();

      expect(result.data, isA<Nothing>());
    });
  });
}
