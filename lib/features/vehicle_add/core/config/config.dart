/// File: lib/features/vehicle_add/core/config/config.dart
/// Purpose: Feature configuration (mock mode toggle)
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Set useMock to false when backend is ready
library;

/// Feature configuration.
class Config {
  /// Toggle between mock (local) and real (remote) data sources.
  /// Set to true for development/demo with dummy data.
  /// Set to false when backend API is ready.
  static const bool useMock = true;

  /// API base URL (when useMock is false).
  static const String apiBaseUrl = 'https://api.example.com';

  /// API timeout duration.
  static const Duration apiTimeout = Duration(seconds: 30);
}

