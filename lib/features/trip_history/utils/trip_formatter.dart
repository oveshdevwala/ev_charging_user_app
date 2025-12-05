import 'package:intl/intl.dart';

/// Utility class for formatting trip-related data
class TripFormatter {
  /// Format cost to currency string (₹)
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  /// Format energy in kWh
  static String formatEnergy(double kWh) {
    return '${kWh.toStringAsFixed(1)} kWh';
  }

  /// Format efficiency score
  static String formatEfficiency(double score) {
    return '${score.toStringAsFixed(1)} km/kWh';
  }

  /// Format date to readable string (e.g., "Dec 04, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format time to readable string (e.g., "10:30 AM")
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// Format duration to readable string (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Format percentage with sign (e.g., "+12.5%", "-4.3%")
  static String formatPercentage(double percentage) {
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}%';
  }

  /// Format month to readable string (e.g., "December 2025")
  static String formatMonth(String monthString) {
    try {
      final date = DateTime.parse('$monthString-01');
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return monthString;
    }
  }
}
