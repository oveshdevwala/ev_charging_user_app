/// File: lib/admin/core/utils/admin_formatters.dart
/// Purpose: Data formatting utilities for admin panel
/// Belongs To: admin/core/utils
library;

import 'package:intl/intl.dart';

/// Data formatting utilities.
abstract final class AdminFormatters {
  // ============ Currency ============
  
  /// Format as currency (USD).
  static String currency(num value, {String symbol = r'$', int decimals = 2}) {
    return '$symbol${value.toStringAsFixed(decimals)}';
  }

  /// Format with currency code.
  static String currencyCode(num value, {String code = 'USD', int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)} $code';
  }

  // ============ Numbers ============

  /// Format number with thousands separators.
  static String number(num value, {int? decimals}) {
    final formatter = NumberFormat('#,###');
    if (decimals != null) {
      return NumberFormat('#,###.${'0' * decimals}').format(value);
    }
    return formatter.format(value);
  }

  /// Format as compact number (1.2K, 3.5M).
  static String compact(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Format as percentage.
  static String percentage(num value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format as ordinal (1st, 2nd, 3rd).
  static String ordinal(int value) {
    if (value >= 11 && value <= 13) {
      return '${value}th';
    }
    switch (value % 10) {
      case 1:
        return '${value}st';
      case 2:
        return '${value}nd';
      case 3:
        return '${value}rd';
      default:
        return '${value}th';
    }
  }

  // ============ Date/Time ============

  /// Format date as "Jan 15, 2024".
  static String date(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date as "01/15/2024".
  static String dateSlash(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  /// Format date as "2024-01-15".
  static String dateIso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format time as "3:30 PM".
  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format time as "15:30".
  static String time24(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format date and time as "Jan 15, 2024 at 3:30 PM".
  static String dateTime(DateTime date) {
    return DateFormat("MMM d, yyyy 'at' h:mm a").format(date);
  }

  /// Format as relative time (2 hours ago).
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  // ============ Duration ============

  /// Format duration in seconds to "1h 30m".
  static String duration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else if (minutes > 0) {
      return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    }
    return '${secs}s';
  }

  /// Format duration in minutes to "1h 30m".
  static String durationMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  // ============ EV Specific ============

  /// Format as kWh.
  static String kWh(num value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)} kWh';
  }

  /// Format as kW.
  static String kW(num value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)} kW';
  }

  /// Format as distance in km.
  static String distance(num meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  // ============ File Size ============

  /// Format bytes to human readable (KB, MB, GB).
  static String fileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes bytes';
  }

  // ============ Masking ============

  /// Mask string showing only last N characters.
  static String mask(String value, {int visibleChars = 4, String maskChar = '*'}) {
    if (value.length <= visibleChars) return value;
    final visible = value.substring(value.length - visibleChars);
    final masked = maskChar * (value.length - visibleChars);
    return '$masked$visible';
  }

  /// Mask email (j***@example.com).
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 1) return email;
    return '${local[0]}${'*' * (local.length - 1)}@$domain';
  }

  /// Mask phone number.
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '****${phone.substring(phone.length - 4)}';
  }

  // ============ Text ============

  /// Truncate text with ellipsis.
  static String truncate(String value, int maxLength, {String suffix = '...'}) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Get initials from name.
  static String initials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return words.take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  /// Capitalize first letter.
  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  /// Title case.
  static String titleCase(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map(capitalize).join(' ');
  }
}

