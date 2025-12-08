/// File: lib/core/di/injection.dart
/// Purpose: Dependency injection setup using GetIt
/// Belongs To: shared
/// Customization Guide:
///    - Register new dependencies here
///    - Use sl< Type>() to get instances
library;

import 'package:ev_charging_user_app/features/value_packs/data/datasources/value_packs_remote_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/nearby_offers/data/repositories/partner_repository.dart';
import '../../features/nearby_offers/domain/usecases/usecases.dart';
import '../../features/profile/repositories/repositories.dart';
import '../../features/search/data/station_api_service.dart';
import '../../features/search/data/station_repository_impl.dart';
import '../../features/search/domain/station_repository.dart';
import '../../features/search/domain/station_usecases.dart';
import '../../features/search/presentation/bloc/filter_cubit.dart';
import '../../features/search/presentation/bloc/map_bloc.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/settings/data/repositories/repositories.dart';
import '../../features/trip_history/data/datasources/trip_local_datasource.dart';
import '../../features/trip_history/data/datasources/trip_remote_datasource.dart';
import '../../features/trip_history/data/repositories/trip_repository_impl.dart';
import '../../features/trip_history/domain/repositories/trip_repository.dart';
import '../../features/trip_history/domain/usecases/export_trip_report.dart';
import '../../features/trip_history/domain/usecases/get_completed_trips.dart';
import '../../features/trip_history/domain/usecases/get_monthly_analytics.dart';
import '../../features/trip_history/domain/usecases/get_trip_history.dart';
import '../../features/trip_history/presentation/bloc/trip_history_bloc.dart';
import '../../features/value_packs/data/datasources/value_packs_local_datasource.dart';
import '../../features/value_packs/data/datasources/value_packs_remote_datasource_impl.dart';
import '../../features/value_packs/data/repositories/value_packs_repository_impl.dart';
import '../../features/value_packs/domain/repositories/value_packs_repository.dart';
import '../../features/value_packs/domain/usecases/usecases.dart';
import '../../features/value_packs/presentation/cubits/cubits.dart';
import '../../features/vehicle_add/core/services/analytics_service.dart';
import '../../features/vehicle_add/data/datasources/datasources.dart';
import '../../features/vehicle_add/data/repositories/repositories.dart';
import '../../features/vehicle_add/domain/repositories/repositories.dart';
import '../../features/vehicle_add/domain/usecases/usecases.dart';
import '../../features/vehicle_add/presentation/bloc/bloc.dart';
import '../../repositories/repositories.dart';
import '../repositories/pexels_repository.dart';
import '../services/analytics_service.dart';
import '../services/pexels_api_service.dart';
import '../services/recent_stations_service.dart';
import '../services/station_image_service.dart';
import '../theme/theme_manager.dart';

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
    // ============ Settings Repository ============
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(prefs: sl<SharedPreferences>()),
    )
    // ============ Services ============
    ..registerLazySingleton<AnalyticsService>(DummyAnalyticsService.new)
    // ============ Pexels Service & Repository ============
    ..registerLazySingleton<PexelsApiService>(PexelsApiService.new)
    ..registerLazySingleton<PexelsRepository>(
      () => PexelsRepositoryImpl(apiService: sl<PexelsApiService>()),
    )
    // ============ Station Image Service ============
    ..registerLazySingleton<StationImageService>(
      () => StationImageService(pexelsRepository: sl<PexelsRepository>()),
    )
    // ============ Recent Stations Service ============
    ..registerLazySingleton<RecentStationsService>(
      () => RecentStationsService(stationRepository: sl<StationRepository>()),
    )
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
    ..registerLazySingleton(() => GetCompletedTrips(sl()))
    // BLoC
    ..registerFactory(
      () => TripHistoryBloc(
        getTripHistory: sl(),
        getMonthlyAnalytics: sl(),
        exportTripReport: sl(),
        getCompletedTrips: sl(),
      ),
    );

  // ============ Value Packs Feature ============
  final valuePacksBox = await Hive.openBox<String>('value_packs');

  sl
    // Datasources
    ..registerLazySingleton<ValuePacksRemoteDataSource>(
      ValuePacksRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<ValuePacksLocalDataSource>(
      () => ValuePacksLocalDataSourceImpl(valuePacksBox),
    )
    // Repository
    ..registerLazySingleton<ValuePacksRepository>(
      () => ValuePacksRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    // Use Cases
    ..registerLazySingleton(() => GetValuePacks(sl()))
    ..registerLazySingleton(() => GetValuePackDetail(sl()))
    ..registerLazySingleton(() => PurchaseValuePack(sl()))
    ..registerLazySingleton(() => GetReviews(sl()))
    ..registerLazySingleton(() => SubmitReview(sl()))
    // Cubits
    ..registerFactory(() => ValuePacksListCubit(sl<GetValuePacks>()))
    ..registerFactory(() => ValuePackDetailCubit(
          sl<GetValuePackDetail>(),
          sl<GetValuePacks>(),
        ))
    ..registerFactory(() => PurchaseCubit(sl<PurchaseValuePack>()))
    ..registerFactory(() => ReviewsCubit(
          sl<GetReviews>(),
          sl<SubmitReview>(),
        ));

  // ============ Search Feature ============
  sl
    // API Service
    ..registerLazySingleton<StationApiService>(
      () => StationApiService(
        stationRepository: sl<StationRepository>(),
      ),
    )
    // Repository
    ..registerLazySingleton<SearchStationRepository>(
      () => SearchStationRepositoryImpl(
        apiService: sl<StationApiService>(),
      ),
    )
    // Use Cases
    ..registerLazySingleton(() => FetchStationsByBounds(sl()))
    ..registerLazySingleton(() => SearchStations(sl()))
    ..registerLazySingleton(() => GetStation(sl()))
    ..registerLazySingleton(() => FetchStationsByLocation(sl()))
    // BLoCs
    ..registerFactory(
      () => SearchBloc(
        searchStations: sl(),
        fetchStationsByBounds: sl(),
      ),
    )
    ..registerFactory(
      () => MapBloc(
        fetchStationsByBounds: sl(),
      ),
    )
    ..registerFactory(
      () => FilterCubit(prefs: sl<SharedPreferences>()),
    );

  // ============ Vehicle Add Feature ============
  sl
    // Data Sources
    ..registerLazySingleton<VehicleRemoteDataSource>(
      VehicleRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<VehicleLocalDataSource>(
      () => VehicleLocalDataSource(sl<SharedPreferences>()),
    )
    // Repository
    ..registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    // Use Cases
    ..registerLazySingleton(() => AddVehicle(sl()))
    ..registerLazySingleton(() => GetUserVehicles(sl()))
    ..registerLazySingleton(() => UpdateVehicle(sl()))
    ..registerLazySingleton(() => DeleteVehicle(sl()))
    ..registerLazySingleton(() => SetDefaultVehicle(sl()))
    // BLoC
    ..registerFactory(
      () => VehicleAddBloc(
        addVehicle: sl(),
        getUserVehicles: sl(),
        updateVehicle: sl(),
        deleteVehicle: sl(),
        setDefaultVehicle: sl(),
        analyticsService: sl<AnalyticsService>(),
      ),
    );
}

/// Reset all dependencies (for testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
