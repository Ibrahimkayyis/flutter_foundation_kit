import 'package:app_types/app_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_cubit_state.dart';

/// [FormCubit] is a cubit that is used to manage a form.
/// [InitialData] is the initial data of the form.
/// [FormData] is the data of the form.
/// [Result] is the result of the form.
abstract class FormCubit<InitialData, FormData, Result>
    extends Cubit<FormCubitState<InitialData, Result>> {
  FormCubit({FormCubitState<InitialData, Result>? initialState})
    : super(initialState ?? FormCubitPreparing());

  /// [submitUsecase] is the usecase that is used to submit the form.
  Future<Resource<Result>> submitUsecase(FormData data);

  /// [prepareUsecase] is the usecase that is used to prepare the form.
  /// If null, the form cubit will transition to ready with null initialData.
  Future<Resource<InitialData>>? prepareUsecase() {
    return null;
  }

  /// Called when the form is submitted successfully.
  void onSuccessSubmit(Success<Result> result) {}

  /// Called when the form is submitted with an error.
  void onErrorSubmit(BaseException exception) {}

  /// Prepare the initial data of the form.
  Future<void> prepare() async {
    emit(FormCubitPreparing());
    final result = await prepareUsecase();
    if (result == null) {
      emit(FormCubitReady(initialData: null));
      return;
    }
    switch (result) {
      case Success():
        emit(FormCubitReady(initialData: result.data));
      case Error<InitialData>():
        emit(FormCubitPrepareError(result.exception, prepare));
    }
  }

  /// Submit the form data.
  Future<void> submit(FormData data) async {
    final state = this.state;
    if (state is! FormCubitReady<InitialData, Result> ||
        state is FormCubitSubmitting) {
      return;
    }
    emit(FormCubitSubmitting(initialData: state.initialData));
    final result = await submitUsecase(data);
    switch (result) {
      case Success():
        onSuccessSubmit(result);
        emit(
          FormCubitSubmitSuccess(
            message: result.message,
            initialData: state.initialData,
            resultData: result.data,
          ),
        );
      case Error<Result>():
        final exception = result.exception;
        final errors =
            exception is FormException
                ? exception.flattenError
                : <String, String>{};
        onErrorSubmit(result.exception);
        emit(
          FormCubitSubmitError(
            result.exception,
            errors,
            initialData: state.initialData,
          ),
        );
    }
  }
}
