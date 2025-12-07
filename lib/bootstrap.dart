/// File: lib/bootstrap.dart
/// Purpose: App initialization and bootstrap logic
/// Belongs To: shared
/// Customization Guide:
///    - Add additional initialization steps here
///    - Configure error handling and logging
library;

import 'dart:async';

import 'package:ev_charging_user_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection.dart';
import 'core/utils/helpers.dart';

/// Bootstrap the application.
/// This function handles all initialization before runApp().
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file not found or error loading - app can still run
    // but Pexels API will not work until .env is configured
    debugPrint('Warning: Could not load .env file: $e');
    debugPrint('Pexels API will not work until PEXELS_API_KEY is configured.');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surfaceDark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await initializeDependencies();

  // Setup error handling
  FlutterError.onError = (details) {
    logError('Flutter Error', details.exception, details.stack);
  };

  // Run the app
  runApp(await builder());
}
