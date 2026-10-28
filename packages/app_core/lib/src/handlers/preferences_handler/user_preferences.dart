import 'package:equatable/equatable.dart';
import '../../util/mapper.dart';

abstract class BaseUserPreferences extends Equatable {
  const BaseUserPreferences();
}

abstract class BaseUserPreferencesMapper<T extends BaseUserPreferences>
    implements JSONMapper<T> {}
