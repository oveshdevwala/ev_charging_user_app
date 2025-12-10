/// File: lib/admin/core/utils/admin_helpers.dart
/// Purpose: General helper utilities for admin panel
/// Belongs To: admin/core/utils
library;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

/// General helper utilities.
abstract final class AdminHelpers {
  /// Generate a random ID.
  static String generateId({int length = 16}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Generate a UUID-like string.
  static String generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// Load JSON from assets.
  static Future<dynamic> loadJsonAsset(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load JSON from $path: $e');
    }
  }

  /// Deep copy a map.
  static Map<String, dynamic> deepCopyMap(Map<String, dynamic> source) {
    return json.decode(json.encode(source)) as Map<String, dynamic>;
  }

  /// Deep copy a list.
  static List<dynamic> deepCopyList(List<dynamic> source) {
    return json.decode(json.encode(source)) as List<dynamic>;
  }

  /// Debounce function calls.
  static Function debounce(Function function, Duration delay) {
    DateTime? lastCallTime;
    return () {
      final now = DateTime.now();
      if (lastCallTime == null || now.difference(lastCallTime!) > delay) {
        lastCallTime = now;
        function();
      }
    };
  }

  /// Throttle function calls.
  static Function throttle(Function function, Duration delay) {
    var isThrottled = false;
    return () {
      if (!isThrottled) {
        function();
        isThrottled = true;
        Future.delayed(delay, () => isThrottled = false);
      }
    };
  }

  /// Copy text to clipboard.
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Get text from clipboard.
  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Check if value is null or empty.
  static bool isNullOrEmpty(value) {
    if (value == null) return true;
    if (value is String) return value.isEmpty;
    if (value is List) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    return false;
  }

  /// Safely get nested map value.
  static T? getNestedValue<T>(Map<String, dynamic> map, List<String> keys) {
    dynamic current = map;
    for (final key in keys) {
      if (current is! Map) return null;
      current = current[key];
      if (current == null) return null;
    }
    return current is T ? current : null;
  }

  /// Parse date from various formats.
  static DateTime? parseDate(value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  /// Calculate percentage.
  static double calculatePercentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate percentage change.
  static double calculatePercentageChange(num oldValue, num newValue) {
    if (oldValue == 0) return newValue == 0 ? 0 : 100;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Group list by key.
  static Map<K, List<T>> groupBy<T, K>(List<T> list, K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in list) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  /// Chunk list into smaller lists.
  static List<List<T>> chunk<T>(List<T> list, int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(i, min(i + size, list.length)));
    }
    return chunks;
  }

  /// Remove duplicates from list.
  static List<T> removeDuplicates<T>(List<T> list, {bool Function(T, T)? equals}) {
    if (equals == null) {
      return list.toSet().toList();
    }
    final result = <T>[];
    for (final item in list) {
      if (!result.any((existing) => equals(existing, item))) {
        result.add(item);
      }
    }
    return result;
  }

  /// Sort list by multiple criteria.
  static List<T> sortByMultiple<T>(
    List<T> list,
    List<Comparable<dynamic> Function(T)> selectors,
  ) {
    final result = List<T>.from(list);
    result.sort((a, b) {
      for (final selector in selectors) {
        final comparison = selector(a).compareTo(selector(b));
        if (comparison != 0) return comparison;
      }
      return 0;
    });
    return result;
  }

  /// Get random item from list.
  static T randomItem<T>(List<T> list) {
    if (list.isEmpty) throw StateError('List is empty');
    return list[Random().nextInt(list.length)];
  }

  /// Shuffle list.
  static List<T> shuffle<T>(List<T> list) {
    final result = List<T>.from(list);
    result.shuffle();
    return result;
  }
}

/// Debouncer class for use with search inputs.
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 300)});
  
  final Duration delay;
  Function? _action;
  DateTime? _lastRun;

  void run(Function action) {
    _action = action;
    final now = DateTime.now();
    if (_lastRun == null || now.difference(_lastRun!) > delay) {
      _lastRun = now;
      _action?.call();
    } else {
      Future.delayed(delay - now.difference(_lastRun!), () {
        if (_action != null) {
          _lastRun = DateTime.now();
          _action!.call();
        }
      });
    }
  }

  void cancel() {
    _action = null;
  }
}

