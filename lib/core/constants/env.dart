/// File: lib/core/constants/env.dart
/// Purpose: Environment variable configuration using flutter_dotenv
/// Belongs To: shared
/// Customization Guide:
///    - Add PEXELS_API_KEY to your .env file
///    - Never commit .env file to version control
///    - .env file is loaded in bootstrap.dart
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment variable configuration.
///
/// Uses flutter_dotenv to load variables from .env file.
/// Make sure to call dotenv.load() in bootstrap.dart before using these values.
abstract final class Env {
  /// Pexels API Key
  /// Get your key from: https://www.pexels.com/api/
  /// Add to .env file: PEXELS_API_KEY=your_key_here
  static String get pexelsKey => dotenv.env['PEXELS_API_KEY'] ?? '';

  /// Check if Pexels API key is configured
  static bool get hasPexelsKey => pexelsKey.isNotEmpty;
}
