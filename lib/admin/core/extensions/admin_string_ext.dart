/// File: lib/admin/core/extensions/admin_string_ext.dart
/// Purpose: String extensions for admin panel
/// Belongs To: admin/core/extensions
library;

/// String utility extensions.
extension AdminStringExt on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word.
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
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp('[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp('^_'), '').replaceAll(RegExp(r'[\s-]+'), '_').toLowerCase();
  }

  /// Convert to kebab-case.
  String get kebabCase {
    if (isEmpty) return this;
    return snakeCase.replaceAll('_', '-');
  }

  /// Truncate string with ellipsis.
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Check if string is a valid email.
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string is a valid phone number.
  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  }

  /// Check if string is a valid URL.
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  /// Check if string is numeric.
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Check if string is alphanumeric.
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Remove all whitespace.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Convert to nullable int.
  int? get toIntOrNull => int.tryParse(this);

  /// Convert to nullable double.
  double? get toDoubleOrNull => double.tryParse(this);

  /// Mask string (e.g., for sensitive data).
  String mask({int visibleChars = 4, String maskChar = '*'}) {
    if (length <= visibleChars) return this;
    final visible = substring(length - visibleChars);
    final masked = maskChar * (length - visibleChars);
    return '$masked$visible';
  }

  /// Mask email (e.g., "j***@example.com").
  String get maskEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 1) return this;
    return '${local[0]}${'*' * (local.length - 1)}@$domain';
  }

  /// Format as currency.
  String asCurrency({String symbol = r'$', int decimals = 2}) {
    final number = toDoubleOrNull;
    if (number == null) return this;
    return '$symbol${number.toStringAsFixed(decimals)}';
  }

  /// Get initials from name.
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return words
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
  }

  /// Check if string is null or empty or whitespace only.
  bool get isNullOrBlank => trim().isEmpty;

  /// Return null if blank, otherwise return self.
  String? get nullIfBlank => isNullOrBlank ? null : this;
}

/// Nullable string extensions.
extension AdminNullableStringExt on String? {
  /// Check if null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if null or empty or whitespace only.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Return default value if null or empty.
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;

  /// Return default value if null or blank.
  String orDefaultIfBlank(String defaultValue) => isNullOrBlank ? defaultValue : this!;
}

