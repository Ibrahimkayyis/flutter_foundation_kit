import 'package:app_types/app_types.dart';
import '../../local_storage/secure_storage.dart';
import 'user_session.dart';

const String _defaultSessionKey = "app_foundation/session_handler";

class SessionHandleNotInitializeException extends BaseException {
  const SessionHandleNotInitializeException()
    : super('YOU MUST INITIALIZE SESSION HANDLER FIRST');
}

class SessionHandlerConfig<UserSession extends BaseUserSession> {
  final BaseUserSessionMapper<UserSession> mapper;
  final String? sessionKey;

  const SessionHandlerConfig({required this.mapper, this.sessionKey});
}

abstract class SessionHandler<UserSession extends BaseUserSession> {
  static SessionHandler<BaseUserSession>? _instance;

  static SessionHandler<UserSession>
  instance<UserSession extends BaseUserSession>({String? sessionKey}) {
    final instance = _instance;
    if (instance is SessionHandler<UserSession>) {
      return instance;
    }
    throw const SessionHandleNotInitializeException();
  }

  factory SessionHandler.init({
    required BaseUserSessionMapper<UserSession> mapper,
    String? sessionKey,
  }) {
    if (_instance != null) return _instance! as SessionHandler<UserSession>;
    _instance = SessionHandlerImpl<UserSession>(
      sessionKey: sessionKey ?? _defaultSessionKey,
      mapper: mapper,
    );
    return _instance! as SessionHandler<UserSession>;
  }

  Future<void> saveSession(UserSession session);

  Future<void> deleteSession();

  Future<UserSession?> getSession();
}

class SessionHandlerImpl<UserSession extends BaseUserSession>
    implements SessionHandler<UserSession> {
  final String sessionKey;
  final BaseUserSessionMapper<UserSession> mapper;
  final SecureStorage _secureStorage;

  SessionHandlerImpl({
    required this.sessionKey,
    required this.mapper,
    SecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? SecureStorage();

  @override
  Future<void> deleteSession() => _secureStorage.remove(sessionKey);

  @override
  Future<UserSession?> getSession() =>
      _secureStorage.readData((data) => mapper.fromJSON(data), key: sessionKey);

  @override
  Future<void> saveSession(UserSession session) => _secureStorage.writeJSON(
    key: sessionKey,
    json: mapper.toJSON(session) as Map<String, dynamic>,
  );
}

mixin UsecaseSessionMixin<UserSession extends BaseUserSession> {
  Future<UserSession> requireSession() async {
    final session = await SessionHandler.instance<UserSession>().getSession();
    if (session != null) return session;
    throw const SessionException();
  }
}
