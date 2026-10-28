part of 'form_cubit.dart';

/// [FormCubitState] is a sealed class that represents the state of a form cubit.
/// [InitialData] is the initial data of the form cubit.
/// [ResultData] is the result data of the form cubit.
sealed class FormCubitState<InitialData, ResultData> extends Equatable {
  @override
  List<Object?> get props => [];

  bool get isLoading =>
      this is FormCubitPreparing || this is FormCubitSubmitting;
}

/// Emitted when [FormCubit.prepare] is called.
class FormCubitPreparing<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {}

/// Emitted when [FormCubit.prepare] fails with an exception.
class FormCubitPrepareError<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {
  final BaseException exception;
  final void Function() onRetry;

  FormCubitPrepareError(this.exception, this.onRetry);

  @override
  List<Object?> get props => [exception, onRetry];
}

/// Emitted when [FormCubit.prepare] succeeds and the form is ready for input.
class FormCubitReady<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {
  final InitialData? initialData;

  FormCubitReady({required this.initialData});

  @override
  List<Object?> get props => [initialData];
}

/// Emitted when [FormCubit.submit] succeeds.
class FormCubitSubmitSuccess<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  final ResultData resultData;
  final String message;

  FormCubitSubmitSuccess({
    required super.initialData,
    required this.resultData,
    required this.message,
  });

  @override
  List<Object?> get props => [resultData, initialData];
}

/// Emitted when [FormCubit.submit] fails with an error or validation errors.
class FormCubitSubmitError<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  final BaseException exception;
  final Map<String, String> errors;

  FormCubitSubmitError(
    this.exception,
    this.errors, {
    required super.initialData,
  });

  @override
  List<Object?> get props => [exception];
}

/// Emitted when [FormCubit.submit] is in progress.
class FormCubitSubmitting<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  FormCubitSubmitting({required super.initialData});
}
