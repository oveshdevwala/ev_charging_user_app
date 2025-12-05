/// File: lib/core/di/injection.dart
/// Purpose: Dependency injection setup using GetIt
/// Belongs To: shared
/// Customization Guide:
///    - Register new dependencies here
///    - Use sl< Type>() to get instances
library;

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/trip_history/data/datasources/trip_local_datasource.dart';
import '../../features/trip_history/data/datasources/trip_remote_datasource.dart';
import '../../features/trip_history/data/repositories/trip_repository_impl.dart';
import '../../features/trip_history/domain/repositories/trip_repository.dart';
import '../../features/trip_history/domain/usecases/export_trip_report.dart';
import '../../features/trip_history/domain/usecases/get_monthly_analytics.dart';
import '../../features/trip_history/domain/usecases/get_trip_history.dart';
import '../../features/trip_history/presentation/bloc/trip_history_bloc.dart';
import '../../repositories/repositories.dart';
import '../theme/theme_manager.dart';
import '../services/analytics_service.dart';
import '../../features/nearby_offers/data/repositories/partner_repository.dart';
import '../../features/nearby_offers/domain/usecases/usecases.dart';
import '../../features/profile/repositories/repositories.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this before runApp().
Future<void> initializeDependencies() async {
  // ============ External Services ============
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    // ============ Theme Manager ============
    ..registerLazySingleton<ThemeManager>(
      () => ThemeManager(prefs: sl<SharedPreferences>()),
    )
    // ============ Repositories ============
    ..registerLazySingleton<AuthRepository>(DummyAuthRepository.new)
    ..registerLazySingleton<StationRepository>(DummyStationRepository.new)
    ..registerLazySingleton<BookingRepository>(DummyBookingRepository.new)
    ..registerLazySingleton<UserRepository>(DummyUserRepository.new)
    ..registerLazySingleton<PartnerRepository>(DummyPartnerRepository.new)
    // ============ Profile Repository ============
    ..registerLazySingleton<ProfileRepository>(DummyProfileRepository.new)
    // ============ Services ============
    ..registerLazySingleton<AnalyticsService>(DummyAnalyticsService.new)
    // ============ Nearby Offers Usecases ============
    ..registerLazySingleton(() => GetNearbyOffersUseCase(sl()))
    ..registerLazySingleton(() => GetPartnersUseCase(sl()))
    ..registerLazySingleton(() => CheckInPartnerUseCase(sl()))
    ..registerLazySingleton(() => RedeemOfferUseCase(sl()))
    ..registerLazySingleton(() => GetOfferHistoryUseCase(sl()));

  // ============ Trip History Feature ============
  await Hive.initFlutter();
  final tripBox = await Hive.openBox<String>('trip_history');

  sl
    // Datasources
    ..registerLazySingleton<TripRemoteDataSource>(TripRemoteDataSourceImpl.new)
    ..registerLazySingleton<TripLocalDataSource>(
      () => TripLocalDataSourceImpl(tripBox),
    )
    // Repository
    ..registerLazySingleton<TripRepository>(
      () => TripRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    // Use Cases
    ..registerLazySingleton(() => GetTripHistory(sl()))
    ..registerLazySingleton(() => GetMonthlyAnalytics(sl()))
    ..registerLazySingleton(() => ExportTripReport(sl()))
    // BLoC
    ..registerFactory(
      () => TripHistoryBloc(
        getTripHistory: sl(),
        getMonthlyAnalytics: sl(),
        exportTripReport: sl(),
      ),
    );
}

/// Reset all dependencies (for testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
