part of '../datetime_picker.dart';

class DatePickerParams {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;
  final DatePickerMode initialDatePickerMode;
  final Color? selectedDateColor;
  final Color? onSelectedDateColor;
  final TextStyle headerTextStyle;
  final String? confirmText;
  final String? cancelText;
  final Color dialogBackgroundColor;
  final Color? headerColor;
  final Color? onHeaderColor;
  final TextStyle dayTextStyle;
  final DatePickerEntryMode initialEntryMode;

  DatePickerParams({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.input,
    required this.initialDatePickerMode,
    this.selectedDateColor,
    this.onSelectedDateColor,
    this.headerTextStyle = const TextStyle(color: Color(0xff262626)),
    this.confirmText,
    this.cancelText,
    this.dialogBackgroundColor = Colors.white,
    this.headerColor,
    this.onHeaderColor,
    this.dayTextStyle = const TextStyle(color: Color(0xff262626)),
  });
}

Future<DateTime?> pickDate(BuildContext context, DatePickerParams params) {
  return showDatePicker(
    currentDate: params.currentDate,
    context: context,
    initialEntryMode: params.initialEntryMode,
    initialDate: params.initialDate,
    firstDate: params.firstDate,
    lastDate: params.lastDate,
    confirmText: params.confirmText,
    cancelText: params.cancelText,
    initialDatePickerMode: params.initialDatePickerMode,
    fieldLabelText: 'Tanggal',
    fieldHintText: 'Pilih Tanggal',
    helpText: '',
    builder:
        (context, child) => Theme(
          data: ThemeData(
            useMaterial3: false,
            textTheme: TextTheme(
              titleMedium: params.headerTextStyle,
              titleSmall: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              bodySmall: params.dayTextStyle,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary:
                  params.selectedDateColor ??
                  context.colorTheme.primary12Reverse,
              onPrimary:
                  params.onSelectedDateColor ??
                  context.colorTheme.basic1Reverse,
              surface: params.headerColor ?? context.colorTheme.basic1Reverse,
              onSurface:
                  params.onHeaderColor ?? context.colorTheme.basic10Reverse,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(backgroundColor: Colors.white),
            ),
          ),
          child: child!,
        ),
  );
}
