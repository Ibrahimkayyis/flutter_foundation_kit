part of 'datetime_picker.dart';

class NTIDatePickerController extends ValueNotifier<DateTime?> {
  NTIDatePickerController({DateTime? initialValue}) : super(initialValue);
}

class NTIDatePickerField extends StatefulWidget {
  final bool enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final String? locale;
  final bool includeTime;
  final String? format;
  final NTIDatePickerController? controller;
  final DatePickerMode initialDatePickerMode;
  final String? confirmText;
  final String? cancelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? title;
  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool isFilled;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? alwaysUse24HourFormat;
  final TimePickerEntryMode initialEntryMode;
  const NTIDatePickerField({
    super.key,
    this.includeTime = false,
    this.enabled = true,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.format,
    this.controller,
    this.hintText,
    this.alwaysUse24HourFormat,
    this.initialEntryMode = TimePickerEntryMode.dialOnly,
    this.initialDatePickerMode = DatePickerMode.day,
    this.confirmText,
    this.cancelText,
    this.prefixIcon,
    this.suffixIcon,
    this.title,
    this.onSaved,
    this.validator,
    this.isFilled = false,
    this.labelStyle,
    this.style,
    this.locale,
    this.hintStyle,
  });

  @override
  State<NTIDatePickerField> createState() => _NTIDatePickerFieldState();
}

class _NTIDatePickerFieldState extends State<NTIDatePickerField> {
  late final NTIDatePickerController _controller;
  late DateFormat _dateFormat;
  final TextEditingController _textEditingController = TextEditingController();

  static const _fiveYearInDays = 5 * 365;

  final FocusNode _focusNode = FocusNode();
  bool _isFocus = false;
  bool _isError = false;
  Color getFillColor(BuildContext ctx) {
    if (widget.isFilled || _isFocus || _isError) {
      return context.colorTheme.basic1Reverse;
    }
    return context.colorTheme.basic4Reverse;
  }

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat(
      widget.format ?? (widget.includeTime ? 'dd/MM/yyyy HH:mm' : 'dd/MM/yyyy'),
      widget.locale ?? Intl.defaultLocale,
    );
    _focusNode.addListener(() {
      setState(() {
        _isFocus = _focusNode.hasFocus;
      });
    });
    _controller =
        widget.controller ??
        NTIDatePickerController(initialValue: widget.initialDate);
    _setText();
    _controller.addListener(_setText);
  }

  void _setText() {
    final value = _controller.value;
    _textEditingController.value = TextEditingValue(
      text: value == null ? "" : _dateFormat.format(value.toLocal()),
    );
  }

  void _onFieldTap() async {
    final currentDate = _controller.value;
    final isIncludeTime = widget.includeTime;
    final newData =
        isIncludeTime
            ? await _onPickDateTime(currentDate)
            : await _onPickDate(currentDate);
    if (newData == null) return;
    _controller.value = newData;
  }

  Future<DateTime?> _onPickDate(DateTime? currentDate) async {
    final initialDate = currentDate ?? DateTime.now();
    final datePickerParams = DatePickerParams(
      initialDate: initialDate,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate:
          widget.lastDate ??
          initialDate.add(const Duration(days: _fiveYearInDays)),
      currentDate: widget.initialDate ?? DateTime.now(),
      initialDatePickerMode: widget.initialDatePickerMode,
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    final pickedDate = await pickDate(context, datePickerParams);
    return pickedDate;
  }

  Future<DateTime?> _onPickDateTime(DateTime? currentDate) async {
    final alwaysUse24HourFormat =
        widget.alwaysUse24HourFormat ??
        MediaQuery.of(context).alwaysUse24HourFormat;
    final date = await _onPickDate(currentDate);
    if (date == null) return null;
    final timePickerParams = TimePickerParams(
      initialTime:
          currentDate != null
              ? TimeOfDay(
                hour: currentDate.toLocal().hour,
                minute: currentDate.toLocal().minute,
              )
              : TimeOfDay.now(),
      alwaysUse24HourFormat: alwaysUse24HourFormat,
      initialEntryMode: widget.initialEntryMode,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
    );
    // ignore: use_build_context_synchronously
    final pickedTime = await pickTime(context, timePickerParams);
    return pickedTime != null
        ? date.copyWith(hour: pickedTime.hour, minute: pickedTime.minute)
        : null;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.removeListener(_setText);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppTextField(
          focusNode: _focusNode,
          enabled: widget.enabled,
          controller: _textEditingController,
          onSaved: (newValue) => widget.onSaved?.call(_controller.value),
          onTap: _onFieldTap,
          readOnly: true,
          validator: (value) {
            final error = widget.validator?.call(value);
            setState(() {
              _isError = error != null;
            });
            return error;
          },
          style:
              widget.style ??
              TextStyle(fontSize: 16, color: context.colorTheme.basic10Reverse),
          prefixIcon: widget.prefixIcon,
          suffixWidget: widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          padding:
              (widget.title == null
                  ? const EdgeInsets.fromLTRB(16, 20, 16, 20)
                  : const EdgeInsets.fromLTRB(16, 30, 16, 10)),
        ),
        Positioned(
          top: 10,
          left: widget.prefixIcon == null ? 16 : 48,
          child: Text(
            widget.title ?? '',
            style:
                widget.labelStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.colorTheme.basic7Reverse,
                ),
          ),
        ),
      ],
    );
  }
}
