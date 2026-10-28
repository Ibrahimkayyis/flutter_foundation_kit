import 'package:flutter/material.dart';

part 'form_list.dart';

class NTIFormController<Result, SubmitResult extends Object?> {
  _NTIFormBuilderState<Result, SubmitResult>? _state;

  _init(_NTIFormBuilderState<Result, SubmitResult>? state) {
    _state = state;
  }

  void submit() {
    _state?._submit();
  }

  void save() {
    _state?._save();
  }

  void validate() {
    _state?._validate();
  }

  void setError(Map<String, String> errors) {
    _state?._setError(errors);
  }

  Result? value() => _state?._value;

  dipose() {
    _state = null;
  }
}

class NTIForm<Result, SubmitResult extends Object?> extends StatelessWidget {
  final Result intialData;
  final Widget child;
  final AutovalidateMode? autovalidateMode;
  final void Function(NTIFormSubmit<Result, SubmitResult> submitResult)?
  onChange;
  final NTIFormController<Result, SubmitResult>? controller;
  final void Function(NTIFormSubmit<Result, SubmitResult> submitResult)?
  onSubmit;
  const NTIForm({
    super.key,
    required this.intialData,
    this.autovalidateMode,
    this.controller,
    this.onChange,
    required this.child,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return NTIFormBuilder._(
      intialData: intialData,
      onSubmit: onSubmit,
      controller: controller,
      autovalidateMode: autovalidateMode,
      onChange: onChange,
      child: child,
    );
  }
}

class NTIFormSubmit<Result, SubmitResult extends Object?> {
  final Result value;
  final bool Function() validate;
  final void Function(Map<String, String> errors) setError;
  final SubmitResult? submitResult;

  NTIFormSubmit({
    required this.value,
    required this.validate,
    required this.setError,
    this.submitResult,
  });
}

class NTIFormBuilder<Result, SubmitResult extends Object?>
    extends StatefulWidget {
  final Result intialData;
  final Widget child;
  final NTIFormController<Result, SubmitResult>? controller;
  final void Function(NTIFormSubmit<Result, SubmitResult> submitResult)?
  onSubmit;
  final AutovalidateMode? autovalidateMode;
  final void Function(NTIFormSubmit<Result, SubmitResult> submitResult)?
  onChange;

  const NTIFormBuilder._({
    super.key,
    this.controller,
    this.autovalidateMode,
    this.onChange,
    required this.child,
    required this.intialData,
    this.onSubmit,
  });

  static Widget _builder<Result>(
    Widget Function(
      Result initialValue,
      Result value,
      VoidCallback submit,
      bool Function() validate,
      void Function(Map<String, String> errors) setError,
      String? Function(String key) errors,
    )
    build,
  ) {
    return Builder(
      builder: (context) {
        final form = context.form<Result>();
        return build(
          form.initialValue,
          form.value,
          form.submit,
          form.validate,
          form.setError,
          form.errors,
        );
      },
    );
  }

  NTIFormBuilder({
    super.key,
    required this.intialData,
    required this.onSubmit,
    this.controller,
    this.onChange,
    this.autovalidateMode,
    required Widget Function(
      Result initialValue,
      Result value,
      VoidCallback submit,
      bool Function() validate,
      void Function(Map<String, String> errors) setError,
      String? Function(String key) errors,
    )
    build,
  }) : child = _builder<Result>(build);

  @override
  State<NTIFormBuilder<Result, SubmitResult>> createState() =>
      _NTIFormBuilderState<Result, SubmitResult>();
}

class _NTIFormBuilderState<Result, T extends Object?>
    extends State<NTIFormBuilder<Result, T>> {
  final _formKey = GlobalKey<FormState>();

  Map<String, String> _errors = {};
  late Result _value;

  @override
  void initState() {
    super.initState();
    _value = widget.intialData;
    widget.controller?._init(this);
  }

  void _save() {
    _formKey.currentState?.save();
  }

  void _submit([T? result]) {
    _save();
    widget.onSubmit?.call(
      NTIFormSubmit(
        value: _value,
        validate: _validate,
        setError: _setError,
        submitResult: result,
      ),
    );
  }

  _setValue(Result value) {
    _value = value;
  }

  bool _validate() {
    final currentState = _formKey.currentState;
    if (currentState == null) return false;
    final result = currentState.validate();
    return result;
  }

  void _setError(Map<String, String> errors) {
    _errors = errors;
  }

  String? _lazyErrors(String key) => _errors[key];

  @override
  Widget build(BuildContext context) {
    return NTIFormScope<Result, T>(
      allErrors: () => _errors,
      initialValue: widget.intialData,
      errors: _lazyErrors,
      value: () => _value,
      setValue: _setValue,
      save: _save,
      setError: _setError,
      submit: _submit,
      validate: _validate,
      child: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        onChanged: () {
          widget.onChange?.call(
            NTIFormSubmit(
              value: _value,
              validate: _validate,
              setError: _setError,
              submitResult: null,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class NTIFormScope<Result, T extends Object?> extends InheritedWidget {
  final Result initialValue;
  final Result Function() _value;
  final void Function([T? result]) submit;
  final bool Function() validate;
  final VoidCallback save;
  final void Function(Map<String, String> errors) setError;
  final String? Function(String key) errors;
  final Map<String, String> Function() allErrors;
  final void Function(Result value) setValue;
  const NTIFormScope({
    super.key,
    required super.child,
    required this.initialValue,
    required Result Function() value,
    required this.save,
    required this.submit,
    required this.setValue,
    required this.allErrors,
    required this.validate,
    required this.errors,
    required this.setError,
  }) : _value = value;

  Result get value => _value();

  static NTIFormScope<Result, T> of<Result, T extends Object?>(
    BuildContext context,
  ) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<NTIFormScope<Result, T>>();
    if (widget == null) {
      throw Exception("Cant Found Form Scope in the widget tree");
    }
    return widget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

extension NTIFormContextExt on BuildContext {
  NTIFormScope<Result, dynamic> form<Result>() => NTIFormScope.of(this);
  NTIFormScope<Result, T> formWithSubmit<Result, T extends Object>() =>
      NTIFormScope.of<Result, T>(this);
}
