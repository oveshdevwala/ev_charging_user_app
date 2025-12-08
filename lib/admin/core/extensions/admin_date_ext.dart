/// File: lib/admin/core/extensions/admin_date_ext.dart
/// Purpose: Date/DateTime extensions for admin panel
/// Belongs To: admin/core/extensions
library;

import 'package:intl/intl.dart';

/// Date/time formatting extensions.
extension AdminDateExt on DateTime {
  /// Format as "Jan 15, 2024".
  String get formatDate => DateFormat('MMM d, yyyy').format(this);

  /// Format as "Jan 15".
  String get formatShortDate => DateFormat('MMM d').format(this);

  /// Format as "01/15/2024".
  String get formatSlashDate => DateFormat('MM/dd/yyyy').format(this);

  /// Format as "2024-01-15".
  String get formatIsoDate => DateFormat('yyyy-MM-dd').format(this);

  /// Format as "3:30 PM".
  String get formatTime => DateFormat('h:mm a').format(this);

  /// Format as "15:30".
  String get format24Time => DateFormat('HH:mm').format(this);

  /// Format as "Jan 15, 2024 at 3:30 PM".
  String get formatDateTime => DateFormat('MMM d, yyyy \'at\' h:mm a').format(this);

  /// Format as "Jan 15, 3:30 PM".
  String get formatShortDateTime => DateFormat('MMM d, h:mm a').format(this);

  /// Format as "01/15/24 15:30".
  String get formatCompactDateTime => DateFormat('MM/dd/yy HH:mm').format(this);

  /// Format as "Monday, January 15, 2024".
  String get formatFullDate => DateFormat('EEEE, MMMM d, yyyy').format(this);

  /// Format as "Mon, Jan 15".
  String get formatWeekdayShort => DateFormat('EEE, MMM d').format(this);

  /// Format as "January 2024".
  String get formatMonthYear => DateFormat('MMMM yyyy').format(this);

  /// Format as "Jan 2024".
  String get formatShortMonthYear => DateFormat('MMM yyyy').format(this);

  /// Get relative time string (e.g., "2 hours ago", "yesterday").
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else {
      return 'Just now';
    }
  }

  /// Whether the date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether the date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Whether the date is this week.
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Whether the date is this month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Whether the date is this year.
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Start of the week (Monday).
  DateTime get startOfWeek {
    final diff = weekday - DateTime.monday;
    return subtract(Duration(days: diff)).startOfDay;
  }

  /// End of the week (Sunday).
  DateTime get endOfWeek {
    final diff = DateTime.sunday - weekday;
    return add(Duration(days: diff)).endOfDay;
  }

  /// Start of the month.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// End of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Smart format - shows relative time for recent, date for older.
  String get smartFormat {
    if (isToday) {
      return formatTime;
    } else if (isYesterday) {
      return 'Yesterday, $formatTime';
    } else if (isThisWeek) {
      return formatWeekdayShort;
    } else if (isThisYear) {
      return formatShortDate;
    } else {
      return formatDate;
    }
  }
}

