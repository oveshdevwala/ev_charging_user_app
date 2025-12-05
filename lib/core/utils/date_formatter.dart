/// File: lib/core/utils/date_formatter.dart
/// Purpose: Date formatting utilities for offers
/// Belongs To: shared
library;

import 'package:intl/intl.dart';

class DateFormatter {
  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _timeFormat = DateFormat('hh:mm a');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

  /// Format date (e.g., 12 Dec 2023).
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format time (e.g., 10:30 AM).
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format date and time.
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Format relative time (e.g., "Expires in 2 days").
  static String formatExpiry(DateTime expiryDate) {
    final now = DateTime.now();
    final diff = expiryDate.difference(now);

    if (diff.isNegative) {
      return 'Expired';
    }

    if (diff.inDays > 30) {
      return 'Expires on ${formatDate(expiryDate)}';
    } else if (diff.inDays > 1) {
      return 'Expires in ${diff.inDays} days';
    } else if (diff.inDays == 1) {
      return 'Expires tomorrow';
    } else if (diff.inHours > 1) {
      return 'Expires in ${diff.inHours} hours';
    } else {
      return 'Expires soon';
    }
  }
}
