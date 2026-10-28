library;

import 'src/handlers/preferences_handler/preferences_handler.dart';
import 'src/handlers/preferences_handler/user_preferences.dart';
import 'src/handlers/session_handler/session_handler.dart';
import 'src/handlers/session_handler/user_session.dart';

export 'src/architecture/usecase.dart';
export 'src/local_storage/secure_storage.dart' hide SecureStorageImpl;
export 'src/handlers/preferences_handler/user_preferences.dart';
export 'src/handlers/session_handler/user_session.dart';
export 'src/util/mapper.dart';
export 'src/handlers/session_handler/session_handler.dart' hide SessionHandlerImpl;
export 'src/handlers/preferences_handler/preferences_handler.dart'
    hide PreferencesHandlerImpl;
export 'src/api_client/api_client.dart';
export 'src/ext/index.dart';
export 'src/util/time_difference_util.dart';

class AppCore {
  static Future<void> initSession<UserSession extends BaseUserSession>({
    required SessionHandlerConfig<UserSession> config,
  }) async {
    SessionHandler.init(mapper: config.mapper, sessionKey: config.sessionKey);
  }

  static Future<void> initUserPreferences<
    UserPreferences extends BaseUserPreferences
  >({required PreferencesHandlerConfig<UserPreferences> config}) async {
    PreferencesHandler.init(
      mapper: config.mapper,
      preferencesKey: config.preferencesKey,
    );
  }
}
