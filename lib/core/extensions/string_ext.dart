/// File: lib/core/extensions/string_ext.dart
/// Purpose: String utility extensions
/// Belongs To: shared
/// Customization Guide:
///    - Add new string manipulation methods as needed

/// Extension methods for String manipulation.
extension StringExt on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Capitalize each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Convert to camelCase.
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }
  
  /// Convert to snake_case.
  String get snakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }
  
  /// Check if string is valid email.
  bool get isEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }
  
  /// Check if string is valid phone number (10 digits).
  bool get isPhone {
    return RegExp(r'^[0-9]{10}$').hasMatch(this);
  }
  
  /// Check if string is valid URL.
  bool get isUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }
  
  /// Check if string is numeric.
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  /// Check if string contains only letters.
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }
  
  /// Check if string contains only alphanumeric characters.
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }
  
  /// Truncate string to max length with ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  /// Remove all whitespace.
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
  
  /// Check if string is null or empty.
  bool get isNullOrEmpty => isEmpty;
  
  /// Check if string is not null and not empty.
  bool get isNotNullOrEmpty => isNotEmpty;
  
  /// Convert to int or return null.
  int? get toIntOrNull => int.tryParse(this);
  
  /// Convert to double or return null.
  double? get toDoubleOrNull => double.tryParse(this);
  
  /// Mask string (for phone, email, etc.).
  String mask({int visibleStart = 3, int visibleEnd = 3, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;
    final masked = maskChar * (length - visibleStart - visibleEnd);
    return substring(0, visibleStart) + masked + substring(length - visibleEnd);
  }
  
  /// Get initials from name (e.g., "John Doe" -> "JD").
  String get initials {
    final words = trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    return (words.first.isNotEmpty ? words.first[0] : '') + 
           (words.last.isNotEmpty ? words.last[0] : '').toUpperCase();
  }
}

/// Extension for nullable strings.
extension NullableStringExt on String? {
  /// Returns true if string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  
  /// Returns true if string is not null and not empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
  
  /// Returns the string or a default value.
  String orDefault([String defaultValue = '']) => this ?? defaultValue;
}

