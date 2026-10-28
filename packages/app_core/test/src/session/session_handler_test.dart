import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';
import 'package:app_core/app_core.dart';

class UserSession extends BaseUserSession {
  final String name;
  final String accessToken;

  const UserSession({required this.name, required this.accessToken});

  @override
  List<Object?> get props => [name, accessToken];
}

class UserSessionMapper extends BaseUserSessionMapper<UserSession> {
  @override
  UserSession fromJSON(json) =>
      UserSession(name: json['name'], accessToken: json['accessToken']);

  @override
  Map<String, dynamic> toJSON(UserSession data) {
    return {'name': data.name, 'accessToken': data.accessToken};
  }
}

class GetCurrentUserUsecase extends UsecaseNoParams<UserSession>
    with UsecaseSessionMixin<UserSession> {
  @override
  Future<Resource<UserSession>> execute() async {
    final user = await requireSession();
    return Resource.success(user, "SUCCESS");
  }
}

void main() {
  FlutterSecureStorage.setMockInitialValues({});
  const name = "John Doe";
  final token = DateTime.now().toIso8601String();
  final userSession = UserSession(name: name, accessToken: token);
  SessionHandler<UserSession>.init(mapper: UserSessionMapper());
  late final SessionHandler<UserSession> sessionHandler;

  setUpAll(() {
    sessionHandler = SessionHandler.instance<UserSession>();
  });

  setUp(() {
    sessionHandler.saveSession(userSession);
  });

  test('Singleton test', () {
    final otherSessionHandler = SessionHandler.instance<UserSession>();
    expect(sessionHandler, otherSessionHandler);
  });

  test('Save Session', () async {
    final toBeSaveSession = UserSession(
      name: "Jane Doe",
      accessToken: DateTime.now().toString(),
    );
    await sessionHandler.saveSession(toBeSaveSession);
    final savedSession = await sessionHandler.getSession();
    expect(savedSession, isA<UserSession>());
    expect(savedSession, toBeSaveSession);
    expect(savedSession?.name, toBeSaveSession.name);
    expect(savedSession?.accessToken, toBeSaveSession.accessToken);
  });

  test('Get Current Session', () async {
    final session = await sessionHandler.getSession();
    expect(session, isA<UserSession>());
    expect(session, userSession);
    expect(session?.name, name);
    expect(session?.accessToken, token);
  });

  test('Delete Session', () async {
    final session = await sessionHandler.getSession();
    expect(session, isA<UserSession>());
    await sessionHandler.deleteSession();
    final deletedSession = await sessionHandler.getSession();
    expect(deletedSession, isNull);
  });

  test('Test UsecaseSessionMixin Success', () async {
    await sessionHandler.saveSession(userSession);
    final usecase = GetCurrentUserUsecase();
    final result = await usecase();
    expect(result.isSuccess, true);
    expect(result.data, userSession);
    expect((result as Success<UserSession>).message, "SUCCESS");
  });

  test('Test UsecaseSessionMixin Error', () async {
    await sessionHandler.deleteSession();
    final usecase = GetCurrentUserUsecase();
    final result = await usecase();
    expect(result.isError, true);
    expect((result as Error<UserSession>).exception, isA<SessionException>());
  });
}
