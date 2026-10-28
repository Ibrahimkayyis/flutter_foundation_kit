import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String localStringForm({required String pattern, String locale = 'id'}) =>
      DateFormat(pattern, locale).format(toLocal());

  String localHourStringForm({
    String pattern = "HH:mm",
    String locale = 'id',
  }) => DateFormat(pattern, locale).format(toLocal());

  String localDateStringForm({
    String pattern = "dd/MM/yyyy",
    String locale = 'id',
  }) {
    final dateFormater = DateFormat(pattern, locale);
    return dateFormater.format(toLocal());
  }

  String localDateTimeStringForm({
    String pattern = "dd MMM yyyy HH:mm",
    String locale = 'id',
  }) {
    final dateFormater = DateFormat(pattern, locale);
    return dateFormater.format(toLocal());
  }

  String utcDateTimeStringForm({
    String pattern = "yyyy-MM-dd HH:mm:ss",
    String locale = 'id',
  }) {
    final dateFormater = DateFormat(pattern, locale);
    return dateFormater.format(toUtc());
  }
}
