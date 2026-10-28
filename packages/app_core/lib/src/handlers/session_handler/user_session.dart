import 'package:equatable/equatable.dart';
import '../../util/mapper.dart';

abstract class BaseUserSession extends Equatable {
  const BaseUserSession();
}

abstract class BaseUserSessionMapper<T extends BaseUserSession>
    implements JSONMapper<T> {}
