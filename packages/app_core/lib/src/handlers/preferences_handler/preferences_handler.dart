import 'package:app_types/app_types.dart';
import '../../local_storage/secure_storage.dart';
import 'user_preferences.dart';

const String _defaultPreferencesKey = "app_foundation/preferences_handler";

class PreferencesHandleNotInitializeException extends BaseException {
  const PreferencesHandleNotInitializeException()
    : super('YOU MUST INITIALIZE PREFERENCES HANDLER FIRST');
}

class PreferencesHandlerConfig<UserPreferences extends BaseUserPreferences> {
  final BaseUserPreferencesMapper<UserPreferences> mapper;
  final String? preferencesKey;

  const PreferencesHandlerConfig({required this.mapper, this.preferencesKey});
}

abstract class PreferencesHandler<UserPreferences extends BaseUserPreferences> {
  static PreferencesHandler<BaseUserPreferences>? _instance;

  static PreferencesHandler<UserPreferences>
  instance<UserPreferences extends BaseUserPreferences>({
    String? preferencesKey,
  }) {
    final instance = _instance;
    if (instance is PreferencesHandler<UserPreferences>) {
      return instance;
    }
    throw const PreferencesHandleNotInitializeException();
  }

  factory PreferencesHandler.init({
    required BaseUserPreferencesMapper<UserPreferences> mapper,
    String? preferencesKey,
  }) {
    if (_instance != null) {
      return _instance! as PreferencesHandler<UserPreferences>;
    }
    _instance = PreferencesHandlerImpl<UserPreferences>(
      preferencesKey: preferencesKey ?? _defaultPreferencesKey,
      mapper: mapper,
    );
    return _instance! as PreferencesHandler<UserPreferences>;
  }

  Future<void> savePreferences(UserPreferences preferences);

  Future<void> deletePreferences();

  Future<UserPreferences?> getPreferences();
}

class PreferencesHandlerImpl<UserPreferences extends BaseUserPreferences>
    implements PreferencesHandler<UserPreferences> {
  final String preferencesKey;
  final BaseUserPreferencesMapper<UserPreferences> mapper;
  final SecureStorage _secureStorage;

  PreferencesHandlerImpl({
    required this.preferencesKey,
    required this.mapper,
    SecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? SecureStorage();

  @override
  Future<void> deletePreferences() => _secureStorage.remove(preferencesKey);

  @override
  Future<UserPreferences?> getPreferences() => _secureStorage.readData(
    (data) => mapper.fromJSON(data),
    key: preferencesKey,
  );

  @override
  Future<void> savePreferences(UserPreferences preferences) =>
      _secureStorage.writeJSON(
        key: preferencesKey,
        json: mapper.toJSON(preferences) as Map<String, dynamic>,
      );
}

mixin UsecasePreferencesMixin<UserPreferences extends BaseUserPreferences> {
  Future<UserPreferences> requirePreferences() async {
    final preferences =
        await PreferencesHandler.instance<UserPreferences>().getPreferences();
    if (preferences != null) return preferences;
    throw const PreferencesException();
  }
}
