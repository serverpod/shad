const _daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

/// Calendar helpers on [DateTime].
///
/// The returned dates are in local time.
extension ShadDateTime on DateTime {
  /// Whether the year [value] is a leap year. It does not read this date.
  bool isLeapYear(int value) =>
      value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);

  /// The number of days in the month of this date.
  int get daysInMonth {
    var result = _daysInMonth[month - 1];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  /// Whether [other] has the same year, month and day as this date.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Whether [other] is on the same day as this date, or this date is after
  /// [other].
  bool isSameDayOrGreater(DateTime other) => isSameDay(other) || isAfter(other);

  /// Whether [other] is on the same day as this date, or this date is before
  /// [other].
  bool isSameDayOrLower(DateTime other) => isSameDay(other) || isBefore(other);

  /// This date at midnight.
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// The last millisecond of this date, at 23:59:59.999.
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// The Monday of this date's ISO week, at midnight.
  DateTime get startOfWeek {
    return DateTime(year, month, day - (weekday - DateTime.monday));
  }

  /// The Sunday of this date's ISO week, at midnight.
  DateTime get endOfWeek {
    return DateTime(year, month, day - (weekday - DateTime.monday) + 6);
  }

  /// The first day of the month of this date, at midnight.
  DateTime get startOfMonth {
    return DateTime(year, month);
  }

  /// The last day of the month of this date, at midnight.
  DateTime get endOfMonth {
    return DateTime(year, month, daysInMonth);
  }

  /// The day before this date, at the same time of day.
  DateTime get previousDay {
    if (day == 1) {
      final previousMonth = DateTime(
        year,
        month - 1,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
      return DateTime(
        previousMonth.year,
        previousMonth.month,
        previousMonth.daysInMonth,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DateTime(
      year,
      month,
      day - 1,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// The day after this date, at the same time of day.
  DateTime get nextDay {
    if (day == daysInMonth) {
      final nextMonth = DateTime(year, month + 1);
      return DateTime(
        nextMonth.year,
        nextMonth.month,
        1,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DateTime(
      year,
      month,
      day + 1,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Add days to the current date without taking into account the different
  /// daylight
  DateTime addDays(int days) {
    // Create a new DateTime by directly adding days and let Dart handle month/year overflow
    final newDate = DateTime(year, month, day + days);

    // Ensure the result has a time of 00:00:00 (midnight)
    return DateTime(newDate.year, newDate.month, newDate.day);
  }

  /// Remove days from the current date without taking into account the
  /// different daylight
  DateTime removeDays(int days) {
    // Create a new DateTime by directly subtracting days and let Dart handle month/year underflow
    final newDate = DateTime(year, month, day - days);

    // Ensure the result has a time of 00:00:00 (midnight)
    return DateTime(newDate.year, newDate.month, newDate.day);
  }

  /// The same day and time in the previous month.
  ///
  /// The day is not clamped: March 31 gives March 3 (or 2 in a leap year),
  /// because February has no day 31.
  DateTime get previousMonth => _addMonths(-1);

  /// The same day and time in the next month.
  ///
  /// The day is not clamped: January 31 gives March 3 (or 2 in a leap year),
  /// because February has no day 31.
  DateTime get nextMonth => _addMonths(1);

  /// This date [months] months away, with the day clamped to the target
  /// month's length: Jan 31 + 1 month is Feb 28 (29), not Mar 3.
  DateTime _addMonths(int months) {
    final first = DateTime(year, month + months);
    final lastDay = first.daysInMonth;
    return DateTime(
      first.year,
      first.month,
      day > lastDay ? lastDay : day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// The ISO 8601 week number [1..53].
  ///
  /// Algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Algorithms
  int get weekNumber {
    // Add 10 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = (ordinalDate - weekday + 10) ~/ 7;

    // If the week number equals zero, it means that the given date belongs to
    // the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekNumber;
    }

    // If the week number equals 53, one must check that the date is not
    // actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// The ordinal date, the number of days since December 31st the previous
  /// year.
  ///
  /// January 1st has the ordinal date 1
  ///
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear(year) && month > 2 ? 1 : 0);
  }

  /// Returns the day of the month with its English ordinal suffix, for example
  /// `1st`, `2nd` or `11th`.
  String getOrdinalDay() {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
}
