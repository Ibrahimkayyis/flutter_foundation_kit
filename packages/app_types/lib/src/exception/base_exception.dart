import 'package:equatable/equatable.dart';

part 'form_exception.dart';
part 'network_exception.dart';
part 'session_exception.dart';
part 'preferences_exception.dart';

class BaseException extends Equatable implements Exception {
  final String message;

  const BaseException(this.message);

  factory BaseException.unknownError() => const UnknownException();

  bool get isUnknownError => this is UnknownException;

  @override
  List<Object?> get props => [message];
}

class UnknownException extends BaseException {
  static const unknownExceptionKey = "UNKNOWN_EXCEPTION";

  const UnknownException() : super(unknownExceptionKey);
}
