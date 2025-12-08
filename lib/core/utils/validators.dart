/// File: lib/core/utils/validators.dart
/// Purpose: Validation utilities for forms and data
/// Belongs To: shared
/// Customization Guide:
///    - Add new validators as needed
library;

/// Validator class with static methods for form validation.
class Validators {
  Validators._();

  /// Required field validator.
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Email validator.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Password validator.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}

/// Validator functions for common use cases (legacy support).

/// Validate email address.
String? validateEmail(String? value) {
  return Validators.email(value);
  }

/// Validate password.
String? validatePassword(String? value) {
  return Validators.password(value);
  }

/// Validate latitude.
bool isValidLatitude(double lat) {
  return lat >= -90 && lat <= 90;
    }

/// Validate longitude.
bool isValidLongitude(double lng) {
  return lng >= -180 && lng <= 180;
  }

/// Validate coordinate pair.
bool isValidCoordinate(double lat, double lng) {
  return isValidLatitude(lat) && isValidLongitude(lng);
}
