import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_types/app_types.dart';
import 'package:app_core/app_core.dart';

abstract class RepoExample {
  Future<Result<String>> getString();
}

class MockRepoExample extends Mock implements RepoExample {}

class UsecaseExample extends Usecase<int, String> {
  final RepoExample repo;

  UsecaseExample(this.repo);

  @override
  Future<Resource<String>> execute(int params) async {
    return repo.getString().asFutureResource;
  }
}

class UsecaseExampleNoParams extends UsecaseNoParams<String> {
  final RepoExample repo;

  UsecaseExampleNoParams(this.repo);

  @override
  Future<Resource<String>> execute() async {
    return repo.getString().asFutureResource;
  }
}

void main() {
  const result = "test";
  const message = "message";
  const errorMessage = "ERROR_MESSAGE";
  const successResult = Result(data: result, message: message);

  late MockRepoExample repo;
  late UsecaseExample usecase;
  late UsecaseExampleNoParams usecaseNoParams;

  setUp(() {
    repo = MockRepoExample();
    usecase = UsecaseExample(repo);
    usecaseNoParams = UsecaseExampleNoParams(repo);
  });

  test('Test Success Usecase', () async {
    when(() => repo.getString()).thenAnswer((_) async => successResult);
    final actual = await usecase(1);
    expect(actual.isSuccess, isTrue);
    expect(actual.data, equals(result));
    expect(actual, isA<Success<String>>());
    expect((actual as Success).message, equals(message));
  });

  test('Test Success Usecase No Params', () async {
    when(() => repo.getString()).thenAnswer((_) async => successResult);
    final actual = await usecaseNoParams();
    expect(actual.isSuccess, isTrue);
    expect(actual.data, equals(result));
    expect(actual, isA<Success<String>>());
    expect((actual as Success).message, equals(message));
  });

  test('Test Error Usecase', () async {
    const error = BaseException(errorMessage);
    when(() => repo.getString()).thenAnswer((_) async => throw error);
    final actual = await usecase(1);
    expect(actual.isError, isTrue);
    expect(actual is Error<String>, isTrue);
    expect((actual as Error).exception, equals(error));
  });

  test('Test Socket Exception Error', () async {
    const error = SocketException(errorMessage);
    when(() => repo.getString()).thenAnswer((_) => throw error);
    final actual = await usecase(1);
    expect(actual.isError, isTrue);
    expect(actual is Error<String>, isTrue);
    expect((actual as Error).exception, isA<ConnectionException>());
  });

  test('Test Unknown Error', () async {
    when(() => repo.getString()).thenAnswer((_) => throw "Unknown Error");
    final actual = await usecase(1);
    expect(actual.isError, isTrue);
    expect(actual is Error<String>, isTrue);
    expect((actual as Error).exception, isA<UnknownException>());
  });

  test('Test Error Logger', () async {
    String? errorLog;
    StackTrace? stackTrace;
    UsecaseUtil.setErrorLogger((e, stack) {
      errorLog = e.toString();
      stackTrace = stack;
    });

    when(() => repo.getString()).thenAnswer((_) => throw errorMessage);
    final actual = await usecaseNoParams();
    expect(actual.isError, isTrue);
    expect(actual is Error<String>, isTrue);
    expect((actual as Error).exception, isA<UnknownException>());
    expect(errorLog, errorMessage);
    expect(stackTrace, isNotNull);
  });

  test('Test Session Exception', () async {
    bool isSessionException = false;
    UsecaseUtil.setSessionException((e) async {
      isSessionException = true;
    });

    when(() => repo.getString()).thenAnswer((_) => throw const SessionException());
    final actual = await usecaseNoParams();
    expect(actual.isError, isTrue);
    expect(actual is Error<String>, isTrue);
    expect((actual as Error).exception, isA<SessionException>());
    expect(isSessionException, isTrue);
  });
}
