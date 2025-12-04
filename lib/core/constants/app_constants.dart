/// File: lib/core/constants/app_constants.dart
/// Purpose: App-wide constant values for configuration and defaults
/// Belongs To: shared
/// Customization Guide:
///    - Update values as needed for different deployments
///    - Add new constants grouped by functionality
library;

/// App-wide constant values and configuration.
abstract final class AppConstants {
  // ============ App Info ============
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String appStoreId = 'com.evcharging.user';
  static const String playStoreId = 'com.evcharging.user';

  // ============ Timeouts ============
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration sessionTimeout = Duration(days: 7);
  static const Duration otpExpiry = Duration(minutes: 5);

  // ============ Pagination ============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============ Map Configuration ============
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultZoom = 14;
  static const double nearbyRadius = 10; // km
  static const double maxSearchRadius = 50; // km

  // ============ Charging ============
  static const double minChargingDuration = 15; // minutes
  static const double maxChargingDuration = 480; // minutes (8 hours)
  static const double defaultChargingDuration = 60; // minutes

  // ============ Validation ============
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneLength = 10;
  static const int otpLength = 6;

  // ============ Animation Durations ============
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  // ============ Storage Keys ============
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyFcmToken = 'fcm_token';
  static const String keyRecentSearches = 'recent_searches';

  // ============ Database ============
  static const String dbName = 'ev_charging.db';
  static const int dbVersion = 1;

  // ============ Date Formats ============
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  // ============ Regex Patterns ============
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );
}
