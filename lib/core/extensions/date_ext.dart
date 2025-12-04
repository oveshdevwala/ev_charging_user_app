/// File: lib/core/extensions/date_ext.dart
/// Purpose: DateTime utility extensions
/// Belongs To: shared
/// Customization Guide:
///    - Add new date manipulation methods as needed

import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Extension methods for DateTime.
extension DateTimeExt on DateTime {
  /// Format using standard date format (MMM dd, yyyy).
  String get formatted => DateFormat(AppConstants.dateFormat).format(this);
  
  /// Format using time format (hh:mm a).
  String get formattedTime => DateFormat(AppConstants.timeFormat).format(this);
  
  /// Format using date and time format.
  String get formattedDateTime => DateFormat(AppConstants.dateTimeFormat).format(this);
  
  /// Format for API (yyyy-MM-dd).
  String get apiFormat => DateFormat(AppConstants.apiDateFormat).format(this);
  
  /// Format for API with time.
  String get apiDateTimeFormat => DateFormat(AppConstants.apiDateTimeFormat).format(this);
  
  /// Custom format.
  String format(String pattern) => DateFormat(pattern).format(this);
  
  /// Check if same day as another date.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
  
  /// Check if today.
  bool get isToday => isSameDay(DateTime.now());
  
  /// Check if yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }
  
  /// Check if tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }
  
  /// Check if this week.
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }
  
  /// Check if this month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
  
  /// Check if this year.
  bool get isThisYear => year == DateTime.now().year;
  
  /// Check if in past.
  bool get isPast => isBefore(DateTime.now());
  
  /// Check if in future.
  bool get isFuture => isAfter(DateTime.now());
  
  /// Start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);
  
  /// End of day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  
  /// Start of week (Monday).
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;
  
  /// End of week (Sunday).
  DateTime get endOfWeek => add(Duration(days: 7 - weekday)).endOfDay;
  
  /// Start of month.
  DateTime get startOfMonth => DateTime(year, month, 1);
  
  /// End of month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
  
  /// Add days.
  DateTime addDays(int days) => add(Duration(days: days));
  
  /// Add months.
  DateTime addMonths(int months) => DateTime(year, month + months, day);
  
  /// Add years.
  DateTime addYears(int years) => DateTime(year + years, month, day);
  
  /// Difference in days from another date.
  int daysDifference(DateTime other) => difference(other).inDays.abs();
  
  /// Get relative time string (e.g., "2 hours ago", "in 3 days").
  String get relative {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.isNegative) {
      // Future
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return 'in ${absDiff.inDays} ${absDiff.inDays == 1 ? 'day' : 'days'}';
      } else if (absDiff.inHours > 0) {
        return 'in ${absDiff.inHours} ${absDiff.inHours == 1 ? 'hour' : 'hours'}';
      } else if (absDiff.inMinutes > 0) {
        return 'in ${absDiff.inMinutes} ${absDiff.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'in a moment';
      }
    } else {
      // Past
      if (difference.inDays > 0) {
        if (difference.inDays == 1) return 'yesterday';
        if (difference.inDays < 7) return '${difference.inDays} days ago';
        return formatted;
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'just now';
      }
    }
  }
  
  /// Get day name (Monday, Tuesday, etc.).
  String get dayName => DateFormat('EEEE').format(this);
  
  /// Get short day name (Mon, Tue, etc.).
  String get shortDayName => DateFormat('EEE').format(this);
  
  /// Get month name (January, February, etc.).
  String get monthName => DateFormat('MMMM').format(this);
  
  /// Get short month name (Jan, Feb, etc.).
  String get shortMonthName => DateFormat('MMM').format(this);
}

