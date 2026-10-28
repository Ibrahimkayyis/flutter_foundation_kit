part of '../datetime_picker.dart';

class DateRangeParams {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialValue;
  final String? saveText;
  final Color? selectedDateColor;
  final Color onSelectedDateColor;
  final TextStyle headerTextStyle;
  final String? confirmText;
  final String? cancelText;
  final Color dialogBackgroundColor;
  final Color headerColor;
  final Color onHeaderColor;
  final TextStyle dayTextStyle;
  DateRangeParams({
    required this.firstDate,
    required this.lastDate,
    required this.initialValue,
    this.saveText,
    this.selectedDateColor,
    this.onSelectedDateColor = Colors.white,
    this.headerTextStyle = const TextStyle(color: Color(0xff262626)),
    this.confirmText,
    this.cancelText,
    this.dialogBackgroundColor = Colors.white,
    this.headerColor = Colors.white,
    this.onHeaderColor = Colors.black,
    this.dayTextStyle = const TextStyle(color: Color(0xff262626)),
  });
}

Future<DateTimeRange?> pickDateRange(
  BuildContext context,
  DateRangeParams params,
) {
  return showDateRangePicker(
    context: context,
    firstDate: params.firstDate,
    lastDate: params.lastDate,
    initialDateRange: params.initialValue,
    saveText: params.saveText,
    confirmText: params.confirmText,
    cancelText: params.cancelText,

    builder:
        ((context, child) => Theme(
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
                  context.colorTheme.brandTeal10Reverse,
              onPrimary: params.onSelectedDateColor,
              surface: params.headerColor,
              onSurface: params.onHeaderColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: params.selectedDateColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        )),
  );
}
