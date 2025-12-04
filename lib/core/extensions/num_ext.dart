/// File: lib/core/extensions/num_ext.dart
/// Purpose: Number utility extensions
/// Belongs To: shared
/// Customization Guide:
///    - Add new number manipulation methods as needed

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension methods for num (int and double).
extension NumExt on num {
  /// Creates SizedBox with this height.
  SizedBox get verticalSpace => SizedBox(height: toDouble().h);
  
  /// Creates SizedBox with this width.
  SizedBox get horizontalSpace => SizedBox(width: toDouble().w);
  
  /// Duration in milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());
  
  /// Duration in seconds.
  Duration get seconds => Duration(seconds: toInt());
  
  /// Duration in minutes.
  Duration get minutes => Duration(minutes: toInt());
  
  /// Duration in hours.
  Duration get hours => Duration(hours: toInt());
  
  /// Duration in days.
  Duration get days => Duration(days: toInt());
  
  /// Format as currency.
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }
  
  /// Format as percentage.
  String toPercent({int decimals = 1}) {
    return '${(toDouble() * 100).toStringAsFixed(decimals)}%';
  }
  
  /// Format as compact number (e.g., 1.2K, 3.4M).
  String toCompact() {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
  
  /// Format as distance (meters/km).
  String toDistance() {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
    return '${toInt()} m';
  }
  
  /// Format as duration (HH:MM:SS).
  String toDurationString() {
    final duration = Duration(seconds: toInt());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Clamp value between min and max.
  num clampBetween(num min, num max) => this < min ? min : (this > max ? max : this);
  
  /// Check if value is between min and max (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;
  
  /// Linear interpolation.
  double lerp(num end, double t) => this + (end - this) * t;
}

/// Extension for int specific operations.
extension IntExt on int {
  /// Check if even.
  bool get isEven => this % 2 == 0;
  
  /// Check if odd.
  bool get isOdd => this % 2 != 0;
  
  /// Get ordinal (1st, 2nd, 3rd, etc.).
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
  
  /// Repeat a function n times.
  void times(void Function(int index) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }
}

/// Extension for double specific operations.
extension DoubleExt on double {
  /// Round to specific decimal places.
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }
  
  /// Format with specific decimal places.
  String toStringWithDecimals(int decimals) => toStringAsFixed(decimals);
}

