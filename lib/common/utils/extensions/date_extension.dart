import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormat {
  static const String MMMM = 'MMMM';
  static const String MMMM_YYYY = 'MMMM yyyy';
  static const String MMM_DD_HH_MM_A = 'MMM dd @ hh:mm a';
  static const String MM_DD_YY_HH_MM_A = 'MM-dd-yyyy hh:mm a';
  static const String MMM_YYYY = 'MMM, yyyy';
  static const String YYYY_MM_DD = 'yyyy-MM-dd';
  static const String MMM_DD = 'MMM dd';
  static const String MMM_DD_YYYY = 'MMM dd yyyy';
  static const String MM_YYYY = 'MM-yyyy';
  static const String DD_MM_YY = 'dd-MM-yy';
  static const String DD_MM_YYYY = 'dd-MM-yyyy';
  static const String HH_MM_A = 'hh:mm a';
  static const String MMM_YY_HH_MM_A = 'MMM yy @ hh:mm a';
  static const String MMM_DD_YYYY_HH_MM_A = 'MMM dd, yyyy @ hh:mm a';
  static const String EEE_DD_MMM = 'EEE - dd MMM';
  static const String EEEE_DD_MMMM_YYYY = 'EEEE, dd MMMM yyyy';
  static const String EE_DD_MMMM_YY = 'EE, dd MMMM yy';
  static const String EE_MMM_DD_HH_MM_A = 'EE, MMM dd @ hh:mm a';
  static const String HH_A = 'HHa';
  static const String DD_MMM_YYYY_HH_MM = 'dd MMM yyyy hh:mm a';
}

extension DateTimeX on DateTime {
  String format(String format) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toHHAString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.HH_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  //#region DateTime to String

  String toMMMDDHHMMAString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_DD_HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMDDYYHHMMAString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MM_DD_YY_HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMMString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMMM);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMDDYYHHMMString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_DD_YYYY_HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMYYHHMMString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_YY_HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMMYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMMM_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MM_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toDDMMYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.DD_MM_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMDDString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_DD);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toDDMMYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.DD_MM_YY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toYYYYMMDDString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.YYYY_MM_DD);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toMMMDDYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.MMM_DD_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toHHMMString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toEEEDDMMMString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.EEE_DD_MMM);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toEEEEDDMMMMYYYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.EEEE_DD_MMMM_YYYY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toEEDDMMMMYYString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.EE_DD_MMMM_YY);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  String toEEMMMDDString() {
    final DateFormat formatter = DateFormat(DateTimeFormat.EE_MMM_DD_HH_MM_A);
    final String formatted = formatter.format(toLocal());
    return formatted;
  }

  //#endregion DateTime to String

  bool isSameDate(DateTime? other) {
    if (other == null) {
      return false;
    }
    return year == other.year && month == other.month && day == other.day;
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  int compareDateWithoutTime(DateTime? other) {
    if (other == null) {
      return -1;
    }
    final DateTime firstDate = DateTime(year, month, day);
    final DateTime secondDate = DateTime(other.year, other.month, other.day);
    return firstDate.compareTo(secondDate);
  }

  bool isSameMonth(DateTime? other) {
    if (other == null) {
      return false;
    }
    return year == other.year && month == other.month;
  }

  DateTimeRange getWeekDateRange() {
    final DateTime startDate =
        subtract(Duration(days: weekday - 1)).clone().withTime(hour: 0, minute: 0);
    final DateTime endDate =
        add(Duration(days: DateTime.daysPerWeek - weekday)).clone().withTime(hour: 23, minute: 59);
    return DateTimeRange(start: startDate, end: endDate);
  }

  TimeOfDay toTimeOfDate() {
    return TimeOfDay.fromDateTime(this);
  }

  /// Returns a negative minutes value if this DateTime [isBefore] [other]. It returns 0
  /// if it [isAtSameMomentAs] [other], and returns a positive minutes value otherwise
  /// (when this [isAfter] [other]).
  int compareWithoutDateTo(DateTime other) {
    return (hour - other.hour) * 60 + minute - other.minute;
  }

  DateTime getStartDateOfYear() {
    final DateTime firstMonth = DateTime(year, 1);
    return firstMonth.getStartDateOfMonth();
  }

  DateTime getEndDateOfYear() {
    final DateTime lastMonth = DateTime(year, 12);
    return lastMonth.getEndDateOfMonth();
  }

  DateTime getStartDateOfMonth() {
    return DateTime(year, month);
  }

  DateTime getEndDateOfMonth() {
    return DateTime(year, month + 1, 0, 23, 59);
  }

  DateTime clone() => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: isUtc,
      );

  DateTime withTime({
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year,
      month,
      day,
      hour ?? 0,
      minute ?? 0,
      second ?? 0,
      millisecond ?? 0,
      microsecond ?? 0,
    );
  }

  DateTime withAppMinuteFormat() {
    final List<int> formats = <int>[0, 10, 15, 30, 45];
    int minuteValue = 0;
    int hourValue = hour;
    for (final int element in formats) {
      if (element >= minute) {
        minuteValue = element;
        break;
      } else if (minute > 45) {
        hourValue = hour + 1;
      }
    }
    return DateTime.now().withTime(minute: minuteValue, hour: hourValue);
  }

  DateTime? firstDateOfWeek() {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime? lastDateOfWeek(DateTime dateTime) {
    return add(Duration(days: DateTime.daysPerWeek - weekday));
  }
}

extension DateTimeRangeX on DateTimeRange {
  List<DateTime> getDaysInBetween() {
    final List<DateTime> days = <DateTime>[];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      days.add(start.add(Duration(days: i)));
    }
    return days;
  }

  bool isCurrentWeek() {
    final currentWeek = DateTime.now().getWeekDateRange();
    return (start.isSameDate(currentWeek.start)) && (end.isSameDate(currentWeek.end));
  }

  String toRangeString() {
    if (end.month == start.month) {
      final DateFormat monthFormatter = DateFormat('MMM');
      final String monthString = monthFormatter.format(start);
      return '$monthString ${start.day} - ${end.day}';
    } else {
      final DateFormat formatter = DateFormat('MMM dd');
      final String startString = formatter.format(start);
      final String endString = formatter.format(end);
      return '$startString - $endString';
    }
  }

  String toWalletRangeString() {
    final DateFormat startFormatter = DateFormat('MMM dd');
    final DateFormat endFormatter = DateFormat('MMM dd, yyyy');
    final String startString = startFormatter.format(start);
    final String endString = endFormatter.format(end);
    return '$startString - $endString';
  }

  DateTimeRange add(Duration duration) {
    return DateTimeRange(start: start.add(duration), end: end.add(duration));
  }

  DateTimeRange subtract(Duration duration) {
    return DateTimeRange(start: start.subtract(duration), end: end.subtract(duration));
  }
}
