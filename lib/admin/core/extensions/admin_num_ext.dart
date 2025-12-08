/// File: lib/admin/core/extensions/admin_num_ext.dart
/// Purpose: Number extensions for admin panel
/// Belongs To: admin/core/extensions
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Number utility extensions.
extension AdminNumExt on num {
  /// Format as currency.
  String asCurrency({String symbol = r'$', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Format as percentage.
  String asPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format as compact number (e.g., 1.2K, 3.5M).
  String get compact {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Format with thousands separators.
  String get withSeparators {
    final parts = toStringAsFixed(0).split('');
    final result = <String>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        result.add(',');
      }
      result.add(parts[i]);
    }
    return result.join();
  }

  /// Format as file size (bytes to KB, MB, GB).
  String get asFileSize {
    if (this >= 1073741824) {
      return '${(this / 1073741824).toStringAsFixed(2)} GB';
    } else if (this >= 1048576) {
      return '${(this / 1048576).toStringAsFixed(2)} MB';
    } else if (this >= 1024) {
      return '${(this / 1024).toStringAsFixed(2)} KB';
    }
    return '$this bytes';
  }

  /// Format as duration (seconds to human readable).
  String get asDuration {
    final totalSeconds = toInt();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Format as kWh.
  String asKWh({int decimals = 2}) {
    return '${toStringAsFixed(decimals)} kWh';
  }

  /// Format as kW.
  String asKW({int decimals = 1}) {
    return '${toStringAsFixed(decimals)} kW';
  }

  /// Format as distance (meters to km if needed).
  String get asDistance {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
    return '${toStringAsFixed(0)} m';
  }

  /// Clamp between min and max.
  num clampBetween(num min, num max) =>
      this < min ? min : (this > max ? max : this);

  /// Whether this number is between min and max (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Horizontal SizedBox with this width.
  SizedBox get horizontalSpace => SizedBox(width: toDouble().w);

  /// Vertical SizedBox with this height.
  SizedBox get verticalSpace => SizedBox(height: toDouble().h);

  // /// Responsive width.
  // double get w => toDouble().w;

  // /// Responsive height.
  // double get h => toDouble().h;

  // /// Responsive font size.
  // double get sp => toDouble().sp;

  // /// Responsive radius.
  // double get r => toDouble().r;

  /// EdgeInsets with this value on all sides.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble().r);

  /// EdgeInsets with this value on horizontal sides.
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble().w);

  /// EdgeInsets with this value on vertical sides.
  EdgeInsets get verticalPadding =>
      EdgeInsets.symmetric(vertical: toDouble().h);

  /// BorderRadius with this value.
  BorderRadius get borderRadius => BorderRadius.circular(toDouble().r);

  /// Duration in milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Duration in seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Duration in minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Duration in hours.
  Duration get hours => Duration(hours: toInt());
}

/// Int-specific extensions.
extension AdminIntExt on int {
  /// Ordinal suffix (1st, 2nd, 3rd, etc.).
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

  /// Generate a list from 0 to this-1.
  List<int> get range => List.generate(this, (i) => i);

  /// Repeat a function n times.
  void times(void Function(int index) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }
}

/// Double-specific extensions.
extension AdminDoubleExt on double {
  /// Round to specific decimal places.
  double roundTo(int places) {
    const mod = 1.0;
    var multiplier = 1.0;
    for (var i = 0; i < places; i++) {
      multiplier *= 10;
    }
    return (this * multiplier).round() / multiplier * mod;
  }
}
