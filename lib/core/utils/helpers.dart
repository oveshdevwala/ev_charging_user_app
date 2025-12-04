/// File: lib/core/utils/helpers.dart
/// Purpose: General utility helper functions
/// Belongs To: shared
/// Customization Guide:
///    - Add new helper methods as needed
library;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Global logger instance.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    dateTimeFormat: DateTimeFormat.onlyTime,
  ),
);

/// Log debug message.
void logDebug(String message) => logger.d(message);

/// Log info message.
void logInfo(String message) => logger.i(message);

/// Log warning message.
void logWarning(String message) => logger.w(message);

/// Log error message.
void logError(String message, [Object? error, StackTrace? stackTrace]) {
  logger.e(message, error: error, stackTrace: stackTrace);
}

/// General helper utilities.
abstract final class Helpers {
  /// Hide keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Check if value is null or empty.
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// Format price.
  static String formatPrice(double price, {String symbol = r'$'}) {
    return '$symbol${price.toStringAsFixed(2)}';
  }

  /// Format distance.
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toInt()} m';
  }

  /// Format duration in minutes.
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '$hours h $mins min' : '$hours h';
  }

  /// Get greeting based on time of day.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  /// Delay execution.
  static Future<void> delay([
    Duration duration = const Duration(milliseconds: 300),
  ]) {
    return Future.delayed(duration);
  }
}
