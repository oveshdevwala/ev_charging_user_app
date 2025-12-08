/// File: lib/features/vehicle_add/utils/vehicle_validator.dart
/// Purpose: Vehicle form validation utilities
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Adjust validation rules as needed
///    - Add region-specific license plate validation
library;

/// Validation result for a field.
class FieldValidation {
  const FieldValidation({
    this.isValid = true,
    this.errorKey,
  });

  final bool isValid;
  final String? errorKey; // i18n key for error message
}

/// Vehicle form validator.
class VehicleValidator {
  VehicleValidator();

  static const int minYear = 1990;
  static const int maxBatteryCapacity = 300;
  static const int maxNickNameLength = 40;
  static const int maxLicensePlateLength = 12;
  static const int minLicensePlateLength = 2;

  /// Get current year for validation.
  static int get currentYear => DateTime.now().year;

  /// Validate nickname.
  static FieldValidation validateNickName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const FieldValidation(); // Optional field
    }

    if (value.length > maxNickNameLength) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.nickNameTooLong',
      );
    }

    return const FieldValidation();
  }

  /// Validate make.
  static FieldValidation validateMake(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.required',
      );
    }

    return const FieldValidation();
  }

  /// Validate model.
  static FieldValidation validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.required',
      );
    }

    return const FieldValidation();
  }

  /// Validate year.
  static FieldValidation validateYear(int? value) {
    if (value == null) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.required',
      );
    }

    if (value < minYear || value > currentYear + 1) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.invalidYear',
      );
    }

    return const FieldValidation();
  }

  /// Validate battery capacity.
  static FieldValidation validateBatteryCapacity(double? value) {
    if (value == null) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.required',
      );
    }

    if (value <= 0) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.batteryCapacityInvalid',
      );
    }

    if (value > maxBatteryCapacity) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.batteryCapacityTooLarge',
      );
    }

    return const FieldValidation();
  }

  /// Validate license plate.
  static FieldValidation validateLicensePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const FieldValidation(); // Optional field
    }

    final trimmed = value.trim().toUpperCase();
    if (trimmed.length < minLicensePlateLength ||
        trimmed.length > maxLicensePlateLength) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.invalidLicensePlate',
      );
    }

    // Generic regex: alphanumeric, hyphens, spaces
    final regex = RegExp(r'^[A-Z0-9\- ]{2,12}$');
    if (!regex.hasMatch(trimmed)) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.invalidLicensePlate',
      );
    }

    return const FieldValidation();
  }

  /// Validate image file size (max 10MB).
  static FieldValidation validateImageSize(int? fileSizeBytes) {
    if (fileSizeBytes == null) {
      return const FieldValidation(); // Optional
    }

    const maxSizeBytes = 10 * 1024 * 1024; // 10MB
    if (fileSizeBytes > maxSizeBytes) {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.imageTooLarge',
      );
    }

    return const FieldValidation();
  }

  /// Validate image file type.
  static FieldValidation validateImageType(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return const FieldValidation(); // Optional
    }

    final extension = filePath.toLowerCase().split('.').last;
    if (extension != 'jpg' &&
        extension != 'jpeg' &&
        extension != 'png' &&
        extension != 'webp') {
      return const FieldValidation(
        isValid: false,
        errorKey: 'validation.invalidImageType',
      );
    }

    return const FieldValidation();
  }

  /// Validate all fields and return error map.
  static Map<String, String?> validateForm({
    String? nickName,
    String? make,
    String? model,
    int? year,
    double? batteryCapacity,
    String? licensePlate,
    int? imageSizeBytes,
    String? imagePath,
  }) {
    final errors = <String, String?>{};

    final nickNameValidation = validateNickName(nickName);
    if (!nickNameValidation.isValid) {
      errors['nickName'] = nickNameValidation.errorKey;
    }

    final makeValidation = validateMake(make);
    if (!makeValidation.isValid) {
      errors['make'] = makeValidation.errorKey;
    }

    final modelValidation = validateModel(model);
    if (!modelValidation.isValid) {
      errors['model'] = modelValidation.errorKey;
    }

    final yearValidation = validateYear(year);
    if (!yearValidation.isValid) {
      errors['year'] = yearValidation.errorKey;
    }

    final batteryValidation = validateBatteryCapacity(batteryCapacity);
    if (!batteryValidation.isValid) {
      errors['batteryCapacity'] = batteryValidation.errorKey;
    }

    final licenseValidation = validateLicensePlate(licensePlate);
    if (!licenseValidation.isValid) {
      errors['licensePlate'] = licenseValidation.errorKey;
    }

    final imageSizeValidation = validateImageSize(imageSizeBytes);
    if (!imageSizeValidation.isValid) {
      errors['image'] = imageSizeValidation.errorKey;
    }

    final imageTypeValidation = validateImageType(imagePath);
    if (!imageTypeValidation.isValid) {
      errors['image'] = imageTypeValidation.errorKey;
    }

    return errors;
  }
}

