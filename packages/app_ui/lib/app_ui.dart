library;

import 'package:app_ui/src/core/disctionaries/translations.g.dart';

export 'src/style/styles.dart';
export 'src/layout/index.dart';
export 'src/icon/index.dart';
export 'src/buttons/button.dart';
export 'src/form/index.dart';
export 'src/ext/index.dart';
export 'src/util/index.dart';
export 'src/rich_text/rich_text_field.dart';
export 'src/images/index.dart';
export 'src/messenger/app_messenger.dart';

typedef AppUITranslationProvider = TranslationProvider;
typedef NTIUITranslationProvider = AppUITranslationProvider;

void changeLanguage(String rawLocale, {bool? listenToDeviceLocale = false}) {
  LocaleSettings.setLocaleRaw(
    rawLocale,
    listenToDeviceLocale: listenToDeviceLocale,
  );
}
