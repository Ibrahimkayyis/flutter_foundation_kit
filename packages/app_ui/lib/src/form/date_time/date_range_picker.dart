part of 'datetime_picker.dart';

class NTIDateRangePicker extends StatefulWidget {
  final DateTimeRange? initialDateTimeRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? confirmText;
  final String? cancelText;
  final String? saveText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? title;
  final FormFieldSetter<DateTimeRange>? onSaved;
  final FormFieldValidator<DateTimeRange>? validator;
  final bool isFilled;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool enabled;
  final DateFormat? dateFormat;
  final NTIDateRangePickerController? controller;
  final ValueChanged<DateTimeRange?>? onChange;

  const NTIDateRangePicker({
    super.key,
    this.initialDateTimeRange,
    this.firstDate,
    this.lastDate,
    this.confirmText,
    this.cancelText,
    this.saveText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.title,
    this.controller,
    this.onSaved,
    this.validator,
    this.isFilled = true,
    this.labelStyle,
    this.style,
    this.hintStyle,
    this.enabled = true,
    this.onChange,
    this.dateFormat,
  });

  @override
  State<NTIDateRangePicker> createState() => _NTIDateRangePickerState();
}

class NTIDateRangePickerController extends ValueNotifier<DateTimeRange?> {
  NTIDateRangePickerController({DateTimeRange? initial}) : super(initial);
}

class _NTIDateRangePickerState extends State<NTIDateRangePicker> {
  late final ValueNotifier<DateTimeRange?> _selectedDateRange;
  var _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _textEditingController = TextEditingController();
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
    _dateFormat = widget.dateFormat ?? DateFormat('dd/MM/yyyy');
    _focusNode.addListener(() {
      setState(() {
        _isFocus = _focusNode.hasFocus;
      });
    });
    _selectedDateRange =
        widget.controller ?? ValueNotifier(widget.initialDateTimeRange);
    final initialValue = _selectedDateRange.value;
    if (initialValue != null) {
      _textEditingController.value = TextEditingValue(
        text:
            '${_dateFormat.format(initialValue.start)} - ${_dateFormat.format(initialValue.end)}',
      );
    }
    _selectedDateRange.addListener(_onValueChange);
  }

  void _onValueChange() {
    final pickedDate = _selectedDateRange.value;
    widget.onChange?.call(pickedDate);
    if (pickedDate == null) {
      _textEditingController.text = "";
      return;
    }
    _textEditingController.text =
        '${_dateFormat.format(pickedDate.start)} - ${_dateFormat.format(pickedDate.end)}';
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _selectedDateRange.removeListener(_onValueChange);
      _selectedDateRange.dispose();
    }
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          focusNode: _focusNode,
          enabled: widget.enabled,
          controller: _textEditingController,
          readOnly: true,
          validator: (value) {
            final error = widget.validator?.call(_selectedDateRange.value);
            setState(() {
              _isError = error != null;
            });
            return error;
          },
          style:
              widget.style ??
              TextStyle(fontSize: 16, color: context.colorTheme.basic10Reverse),
          textAlignVertical: TextAlignVertical.bottom,
          decoration: AppInputDecoration.inputDecoration(
            context,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintText,
            fillColor: getFillColor(context),
            hintStyle: widget.hintStyle,
            errorMaxLines: 2,
            showBorder: true,

            enabled: widget.enabled,
            isFilled: true,
          ),
          onSaved: (newValue) {
            widget.onSaved?.call(_selectedDateRange.value);
          },
          onTap: () async {
            final dateRangeParams = DateRangeParams(
              firstDate: widget.firstDate ?? DateTime(1900),
              lastDate: widget.lastDate ?? DateTime(2100),
              initialValue: _selectedDateRange.value,
              cancelText: widget.cancelText,
              confirmText: widget.confirmText,
              saveText: widget.saveText,
            );
            final pickedDate = await pickDateRange(context, dateRangeParams);
            if (pickedDate == null) return;
            _selectedDateRange.value = pickedDate;
          },
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
