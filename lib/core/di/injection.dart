/// File: lib/core/di/injection.dart
/// Purpose: Dependency injection setup using GetIt
/// Belongs To: shared
/// Customization Guide:
///    - Register new dependencies here
///    - Use sl< Type>() to get instances
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/repositories.dart';
import '../theme/theme_manager.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this before runApp().
Future<void> initializeDependencies() async {
  // ============ External Services ============
  final prefs = await SharedPreferences.getInstance();
  sl..registerSingleton<SharedPreferences>(prefs)

  // ============ Theme Manager ============
  ..registerLazySingleton<ThemeManager>(
    () => ThemeManager(prefs: sl<SharedPreferences>()),
  )

  // ============ Repositories ============
  ..registerLazySingleton<AuthRepository>(DummyAuthRepository.new)
  ..registerLazySingleton<StationRepository>(DummyStationRepository.new)
  ..registerLazySingleton<BookingRepository>(DummyBookingRepository.new)
  ..registerLazySingleton<UserRepository>(DummyUserRepository.new);
}

/// Reset all dependencies (for testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
