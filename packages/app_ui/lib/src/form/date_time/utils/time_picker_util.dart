part of '../datetime_picker.dart';

class TimePickerParams {
  final TimeOfDay initialTime;
  final TimePickerEntryMode initialEntryMode;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final String? confirmText;
  final String? cancelText;
  final Color backgroundColor;
  final String? helpText;
  final String? errorInvalidText;
  final String? hourLabelText;
  final String? minuteLabelText;
  final bool alwaysUse24HourFormat;
  void Function(TimePickerEntryMode)? onEntryModeChanged;

  TimePickerParams({
    required this.initialTime,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.primaryColor,
    this.onPrimaryColor = Colors.white,
    this.confirmText,
    this.cancelText,
    this.backgroundColor = Colors.white,
    this.helpText = '',
    this.errorInvalidText = 'Masukan Format Waktu yang Valid!',
    this.hourLabelText = 'Jam',
    this.minuteLabelText = 'Menit',
    this.alwaysUse24HourFormat = false,
    this.onEntryModeChanged,
  });
}

Future<TimeOfDay?> pickTime(BuildContext context, TimePickerParams params) {
  return showTimePicker(
    initialTime: params.initialTime,
    onEntryModeChanged: params.onEntryModeChanged,
    context: context,
    confirmText: params.confirmText,
    cancelText: params.cancelText,
    helpText: params.helpText,
    errorInvalidText: params.errorInvalidText,
    hourLabelText: params.hourLabelText,
    initialEntryMode: params.initialEntryMode,
    minuteLabelText: params.minuteLabelText,

    builder:
        (context, child) => Theme(
          data: ThemeData(
            useMaterial3: false,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: params.backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hourMinuteShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              dayPeriodShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              dayPeriodBorderSide: BorderSide.none,
              dayPeriodColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? (params.primaryColor ??
                            context.colorTheme.brandTeal10Reverse)
                        : Colors.grey.shade300,
              ),
              dayPeriodTextColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? (params.onPrimaryColor ??
                            context.colorTheme.basic1Reverse)
                        : Colors.black,
              ),
              hourMinuteColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? (params.primaryColor ??
                            context.colorTheme.brandTeal10Reverse)
                        : Colors.grey.shade300,
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? (params.primaryColor ??
                            context.colorTheme.brandTeal10Reverse)
                        : Colors.black,
              ),
              dialHandColor: params.primaryColor,
              entryModeIconColor: params.primaryColor,
              dialBackgroundColor: params.onPrimaryColor,
              dialTextColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? (params.primaryColor ??
                            context.colorTheme.basic10Reverse)
                        : Colors.black,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary:
                  (params.primaryColor ??
                      context.colorTheme.brandTeal10Reverse),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) =>
                      (params.primaryColor ??
                          context.colorTheme.brandTeal10Reverse),
                ),
                foregroundColor: WidgetStateColor.resolveWith(
                  (states) =>
                      (params.onPrimaryColor ??
                          context.colorTheme.basic1Reverse),
                ),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(alwaysUse24HourFormat: params.alwaysUse24HourFormat),
            child: child!,
          ),
        ),
  );
}
