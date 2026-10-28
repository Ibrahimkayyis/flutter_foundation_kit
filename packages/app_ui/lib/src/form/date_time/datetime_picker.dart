import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/src/form/textfield/textfield.dart';
import 'package:app_ui/src/style/styles.dart';

part 'date_range_picker.dart';
part 'date_picker.dart';
part 'utils/date_picker_util.dart';
part 'utils/date_range_util.dart';
part 'utils/time_picker_util.dart';

class NTIDateTimePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerMode initialDatePickerMode;
  final TimeOfDay? initialTime;
  final TimePickerEntryMode? initialEntryMode;
  final String? confirmText;
  final String? cancelText;
  final bool? alwaysUse24HourFormat;
  final String title;
  final DateFormat? format;
  final void Function(DateTime?)? onSaved;

  const NTIDateTimePickerField({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.format,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialTime,
    this.initialEntryMode,
    this.confirmText,
    this.cancelText,
    this.alwaysUse24HourFormat,
    required this.title,
    this.onSaved,
  });

  @override
  State<NTIDateTimePickerField> createState() => _NTIDateTimePickerFieldState();
}

class _NTIDateTimePickerFieldState extends State<NTIDateTimePickerField> {
  DateTime? _selectedDateTime;
  static final defaultFormat = DateFormat('dd/MM/yyyy hh:mm');
  late DatePickerParams _datePickerParams;
  late TimePickerParams _timePickerParams;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    final initialDateValue = widget.initialDate;
    final initialTimeValue = widget.initialTime;
    DateTime initialValue;
    if (initialDateValue != null && initialTimeValue != null) {
      initialValue = DateTime(
        initialDateValue.year,
        initialDateValue.month,
        initialDateValue.day,
        initialTimeValue.hour,
        initialTimeValue.minute,
      );
      _textEditingController = TextEditingController(
        text: _dateFormat.format(initialValue),
      );
      _selectedDateTime = initialValue;
    } else {
      _textEditingController = TextEditingController(
        text: 'Select Date and Time',
      );
    }
  }

  DateFormat get _dateFormat => widget.format ?? defaultFormat;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _textEditingController,
      onSaved: (_) => widget.onSaved?.call(_selectedDateTime),
      readOnly: true,
      title: widget.title,
      onTap: () async {
        final color = context.colorTheme;

        _datePickerParams = DatePickerParams(
          initialDate: _selectedDateTime ?? DateTime.now(),
          firstDate: widget.firstDate ?? DateTime(1900),
          lastDate: widget.lastDate ?? DateTime(2100),
          currentDate: widget.initialDate ?? DateTime.now(),
          initialDatePickerMode: widget.initialDatePickerMode,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
        );
        final pickedDate = await pickDate(context, _datePickerParams);
        if (pickedDate == null) {
          return;
        } else {
          _timePickerParams = TimePickerParams(
            primaryColor: color.basic12,
            onPrimaryColor: color.primary10,

            initialTime:
                _selectedDateTime != null
                    ? TimeOfDay(
                      hour: _selectedDateTime!.hour,
                      minute: _selectedDateTime!.minute,
                    )
                    : TimeOfDay.now(),
            alwaysUse24HourFormat: widget.alwaysUse24HourFormat ?? false,
            initialEntryMode:
                widget.initialEntryMode ?? TimePickerEntryMode.dial,
            cancelText: widget.cancelText,
            confirmText: widget.confirmText,
          );
          // ignore: use_build_context_synchronously
          final pickedTime = await pickTime(context, _timePickerParams);
          if (pickedTime == null) {
            return;
          } else {
            final dateTimeResult = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            setState(() {
              _selectedDateTime = dateTimeResult;
            });
            _textEditingController.text = _dateFormat.format(dateTimeResult);
          }
        }
      },
    );
  }
}
