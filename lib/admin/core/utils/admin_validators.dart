/// File: lib/admin/core/utils/admin_validators.dart
/// Purpose: Form validation utilities for admin panel
/// Belongs To: admin/core/utils
library;

import '../constants/admin_strings.dart';

/// Form validation utilities.
abstract final class AdminValidators {
  /// Validate required field.
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName ${AdminStrings.validationRequired.toLowerCase()}'
          : AdminStrings.validationRequired;
    }
    return null;
  }

  /// Validate email format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return AdminStrings.validationEmail;
    }
    return null;
  }

  /// Validate phone number format.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return AdminStrings.validationPhone;
    }
    return null;
  }

  /// Validate minimum length.
  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return AdminStrings.validationMinLength.replaceAll('{min}', '$min');
    }
    return null;
  }

  /// Validate maximum length.
  static String? maxLength(String? value, int max) {
    if (value != null && value.length > max) {
      return AdminStrings.validationMaxLength.replaceAll('{max}', '$max');
    }
    return null;
  }

  /// Validate numeric value.
  static String? numeric(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    if (double.tryParse(value) == null) {
      return AdminStrings.validationNumber;
    }
    return null;
  }

  /// Validate positive number.
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    final number = double.tryParse(value);
    if (number == null) {
      return AdminStrings.validationNumber;
    }
    if (number <= 0) {
      return AdminStrings.validationPositive;
    }
    return null;
  }

  /// Validate URL format.
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validate password strength.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!RegExp('[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp('[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp('[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validate password confirmation.
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return AdminStrings.validationRequired;
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Combine multiple validators.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Optional field validator (validates only if not empty).
  static String? Function(String?) optional(String? Function(String?) validator) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }
      return validator(value);
    };
  }
}

