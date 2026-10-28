import '../ext/date_ext.dart';

const int _maximumNowRangeInSeconds = 59;
const int _maximumMinuteRangeInSeconds = 59 * 60 + _maximumNowRangeInSeconds;
const int _maximumHourRangeInSeconds = 23 * 60 * 60 + _maximumMinuteRangeInSeconds;
const int _maximumDayRangeInSeconds = 6 * 24 * 60 * 60 + _maximumHourRangeInSeconds;

class TimeDifferenceLabels {
  final String justNow;
  final String minutesAgo;
  final String hoursAgo;
  final String daysAgo;
  final String minutesFromNow;
  final String hoursFromNow;
  final String daysFromNow;
  final String dateFormat;

  const TimeDifferenceLabels({
    this.justNow = 'Just now',
    this.minutesAgo = 'minutes ago',
    this.hoursAgo = 'hours ago',
    this.daysAgo = 'days ago',
    this.minutesFromNow = 'minutes from now',
    this.hoursFromNow = 'hours from now',
    this.daysFromNow = 'days from now',
    this.dateFormat = 'dd/MM/yyyy',
  });

  static const TimeDifferenceLabels id = TimeDifferenceLabels(
    justNow: 'Baru saja',
    minutesAgo: 'menit yang lalu',
    hoursAgo: 'jam yang lalu',
    daysAgo: 'hari yang lalu',
    minutesFromNow: 'menit dari sekarang',
    hoursFromNow: 'jam dari sekarang',
    daysFromNow: 'hari dari sekarang',
    dateFormat: 'dd/MM/yyyy',
  );

  static const TimeDifferenceLabels en = TimeDifferenceLabels();
}

class TimeDifferenceUtils {
  static String getTimeDiff(
    DateTime dateTime, {
    TimeDifferenceLabels labels = TimeDifferenceLabels.en,
    String? pattern,
  }) {
    final currentTime = DateTime.now();
    final timeDiff = currentTime.difference(dateTime);
    final timeDiffInSeconds = timeDiff.inSeconds;

    if (timeDiffInSeconds.abs() < _maximumNowRangeInSeconds) {
      return labels.justNow;
    }

    if (timeDiffInSeconds < 0) {
      final absDiff = timeDiff.abs();
      if (absDiff.inSeconds < _maximumMinuteRangeInSeconds) {
        return "${absDiff.inMinutes} ${labels.minutesFromNow}";
      }
      if (absDiff.inSeconds < _maximumHourRangeInSeconds) {
        return "${absDiff.inHours} ${labels.hoursFromNow}";
      }
      if (absDiff.inSeconds < _maximumDayRangeInSeconds) {
        return "${absDiff.inDays} ${labels.daysFromNow}";
      }
    } else {
      if (timeDiffInSeconds < _maximumMinuteRangeInSeconds) {
        return "${timeDiff.inMinutes} ${labels.minutesAgo}";
      }
      if (timeDiffInSeconds < _maximumHourRangeInSeconds) {
        return "${timeDiff.inHours} ${labels.hoursAgo}";
      }
      if (timeDiffInSeconds < _maximumDayRangeInSeconds) {
        return "${timeDiff.inDays} ${labels.daysAgo}";
      }
    }

    return dateTime.localDateStringForm(pattern: pattern ?? labels.dateFormat);
  }
}
