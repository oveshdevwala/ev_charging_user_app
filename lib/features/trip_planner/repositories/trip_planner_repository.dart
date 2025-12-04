/// File: lib/features/trip_planner/repositories/trip_planner_repository.dart
/// Purpose: Trip planner repository interface and dummy implementation
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Replace DummyTripPlannerRepository with real API implementation
///    - Implement caching layer for offline support
// ignore_for_file: parameter_assignments

library;

import '../models/models.dart';
import '../utils/trip_calculations.dart';

// ============================================================
// TRIP PLANNER REPOSITORY INTERFACE
// ============================================================

/// Abstract trip planner repository interface.
/// All methods return Future for async compatibility.
abstract class TripPlannerRepository {
  /// Fetch saved trips.
  Future<List<TripModel>> fetchSavedTrips();

  /// Fetch a trip by ID.
  Future<TripModel?> fetchTripById(String tripId);

  /// Save a new trip.
  Future<TripModel> saveTrip(TripModel trip);

  /// Update an existing trip.
  Future<TripModel> updateTrip(TripModel trip);

  /// Delete a trip.
  Future<void> deleteTrip(String tripId);

  /// Toggle trip favorite status.
  Future<void> toggleTripFavorite(String tripId);

  /// Fetch user's vehicle profiles.
  Future<List<VehicleProfileModel>> fetchVehicleProfiles();

  /// Fetch default vehicle profile.
  Future<VehicleProfileModel?> fetchDefaultVehicle();

  /// Save vehicle profile.
  Future<VehicleProfileModel> saveVehicleProfile(VehicleProfileModel vehicle);

  /// Update vehicle profile.
  Future<VehicleProfileModel> updateVehicleProfile(VehicleProfileModel vehicle);

  /// Delete vehicle profile.
  Future<void> deleteVehicleProfile(String vehicleId);

  /// Search for locations (places autocomplete).
  Future<List<LocationModel>> searchLocations(String query);

  /// Get route between locations.
  Future<RouteResult> getRoute({
    required LocationModel origin,
    required LocationModel destination,
    List<LocationModel> waypoints = const [],
    bool avoidTolls = false,
    bool avoidHighways = false,
  });

  /// Find charging stations along a route.
  Future<List<ChargingStationInfo>> findChargingStationsAlongRoute({
    required String routePolyline,
    double maxDistanceFromRouteKm = 5.0,
    double minChargerPowerKw = 50.0,
  });

  /// Calculate trip with charging stops.
  Future<TripModel> calculateTrip({
    required LocationModel origin,
    required LocationModel destination,
    required VehicleProfileModel vehicle,
    List<LocationModel> waypoints = const [],
    TripPreferences preferences = const TripPreferences(),
    DateTime? departureTime,
  });

  /// Get recent trips.
  Future<List<TripModel>> fetchRecentTrips({int limit = 5});

  /// Get favorite trips.
  Future<List<TripModel>> fetchFavoriteTrips();

  /// Cache trip for offline access.
  Future<void> cacheTripOffline(TripModel trip);

  /// Get cached trips for offline.
  Future<List<TripModel>> getCachedTrips();

  /// Clear trip cache.
  Future<void> clearTripCache();
}

/// Route result from route provider.
class RouteResult {
  const RouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.polyline,
    this.tollsCost,
    this.summary,
  });

  final double distanceMeters;
  final int durationSeconds;
  final String polyline;
  final double? tollsCost;
  final String? summary;
}

// ============================================================
// DUMMY TRIP PLANNER REPOSITORY IMPLEMENTATION
// ============================================================

/// Dummy implementation of TripPlannerRepository for development.
class DummyTripPlannerRepository implements TripPlannerRepository {
  // In-memory storage for dummy data
  final List<TripModel> _savedTrips = [];
  final List<VehicleProfileModel> _vehicles = [];
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    // Initialize with sample vehicles
    _vehicles.addAll([
      const VehicleProfileModel(
        id: 'v1',
        name: 'My Tesla Model 3',
        batteryCapacityKwh: 75,
        maxChargePowerKw: 250,
        manufacturer: 'Tesla',
        model: 'Model 3 Long Range',
        year: 2023,
        isDefault: true,
      ),
      const VehicleProfileModel(
        id: 'v2',
        name: 'Rivian R1T',
        batteryCapacityKwh: 135,
        currentSocPercent: 75,
        consumptionWhPerKm: 210,
        maxChargePowerKw: 200,
        manufacturer: 'Rivian',
        model: 'R1T',
        year: 2024,
      ),
      const VehicleProfileModel(
        id: 'v3',
        name: 'Hyundai Ioniq 6',
        batteryCapacityKwh: 77,
        currentSocPercent: 85,
        consumptionWhPerKm: 140,
        maxChargePowerKw: 220,
        manufacturer: 'Hyundai',
        model: 'Ioniq 6 Long Range',
        year: 2024,
      ),
    ]);

    // Initialize with comprehensive saved trips
    _savedTrips.addAll(_generatePreCalculatedTrips());
  }

  /// Generate pre-calculated trips with accurate real-world data.
  List<TripModel> _generatePreCalculatedTrips() {
    final now = DateTime.now();
    final vehicle = _vehicles.first;

    return [
      // Trip 1: San Francisco to Los Angeles (615 km, 2 stops)
      _createTrip(
        id: 'trip_sf_la',
        name: 'Weekend Trip to LA',
        origin: const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
          address: 'San Francisco, CA 94102',
        ),
        destination: const LocationModel(
          latitude: 34.0522,
          longitude: -118.2437,
          name: 'Los Angeles',
          city: 'Los Angeles',
          state: 'CA',
          address: 'Los Angeles, CA 90001',
        ),
        vehicle: vehicle,
        totalDistanceKm: 615,
        drivingTimeMin: 370, // ~6 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_gilroy',
            stationName: 'Gilroy Supercharger',
            location: const LocationModel(
              latitude: 37.0058,
              longitude: -121.5683,
              name: 'Gilroy',
              city: 'Gilroy',
              state: 'CA',
            ),
            distanceFromStartKm: 125,
            distanceFromPreviousKm: 125,
            arrivalSocPercent: 55,
            departureSocPercent: 80,
            energyToChargeKwh: 18.75,
            chargeTimeMin: 20,
            cost: 6.56,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food', 'WiFi'],
            arrivalTime: now.add(const Duration(hours: 1, minutes: 30)),
          ),
          _createStop(
            id: 'stop_2',
            stopNumber: 2,
            stationId: 'cs_kettleman',
            stationName: 'Kettleman City Station',
            location: const LocationModel(
              latitude: 35.9894,
              longitude: -119.9616,
              name: 'Kettleman City',
              city: 'Kettleman City',
              state: 'CA',
            ),
            distanceFromStartKm: 310,
            distanceFromPreviousKm: 185,
            arrivalSocPercent: 43,
            departureSocPercent: 85,
            energyToChargeKwh: 31.5,
            chargeTimeMin: 25,
            cost: 10.08,
            chargerPowerKw: 350,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food', 'Shopping'],
            arrivalTime: now.add(const Duration(hours: 3, minutes: 30)),
          ),
        ],
        departureTime: now,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 7)),
      ),

      // Trip 2: San Francisco to San Diego (790 km, 3 stops)
      _createTrip(
        id: 'trip_sf_sd',
        name: 'San Diego Beach Trip',
        origin: const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
          address: 'San Francisco, CA 94102',
        ),
        destination: const LocationModel(
          latitude: 32.7157,
          longitude: -117.1611,
          name: 'San Diego',
          city: 'San Diego',
          state: 'CA',
          address: 'San Diego, CA 92101',
        ),
        vehicle: vehicle,
        totalDistanceKm: 790,
        drivingTimeMin: 470, // ~7.8 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_gilroy',
            stationName: 'Gilroy Supercharger',
            location: const LocationModel(
              latitude: 37.0058,
              longitude: -121.5683,
              name: 'Gilroy',
              city: 'Gilroy',
              state: 'CA',
            ),
            distanceFromStartKm: 125,
            distanceFromPreviousKm: 125,
            arrivalSocPercent: 55,
            departureSocPercent: 85,
            energyToChargeKwh: 22.5,
            chargeTimeMin: 22,
            cost: 7.88,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food', 'WiFi'],
            arrivalTime: now.add(const Duration(hours: 1, minutes: 30)),
          ),
          _createStop(
            id: 'stop_2',
            stopNumber: 2,
            stationId: 'cs_kettleman',
            stationName: 'Kettleman City Station',
            location: const LocationModel(
              latitude: 35.9894,
              longitude: -119.9616,
              name: 'Kettleman City',
              city: 'Kettleman City',
              state: 'CA',
            ),
            distanceFromStartKm: 310,
            distanceFromPreviousKm: 185,
            arrivalSocPercent: 48,
            departureSocPercent: 90,
            energyToChargeKwh: 31.5,
            chargeTimeMin: 28,
            cost: 10.08,
            chargerPowerKw: 350,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food', 'Shopping'],
            arrivalTime: now.add(const Duration(hours: 3, minutes: 45)),
          ),
          _createStop(
            id: 'stop_3',
            stopNumber: 3,
            stationId: 'cs_tejon',
            stationName: 'Tejon Ranch Supercharger',
            location: const LocationModel(
              latitude: 34.9872,
              longitude: -118.9486,
              name: 'Lebec',
              city: 'Lebec',
              state: 'CA',
            ),
            distanceFromStartKm: 520,
            distanceFromPreviousKm: 210,
            arrivalSocPercent: 48,
            departureSocPercent: 80,
            energyToChargeKwh: 24,
            chargeTimeMin: 24,
            cost: 9.12,
            chargerPowerKw: 250,
            pricePerKwh: 0.38,
            network: 'Tesla',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 5, minutes: 45)),
          ),
        ],
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 14)),
      ),

      // Trip 3: San Francisco to Lake Tahoe (320 km, 1 stop)
      _createTrip(
        id: 'trip_sf_tahoe',
        name: 'Ski Trip to Tahoe',
        origin: const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
          address: 'San Francisco, CA 94102',
        ),
        destination: const LocationModel(
          latitude: 39.0968,
          longitude: -120.0324,
          name: 'South Lake Tahoe',
          city: 'South Lake Tahoe',
          state: 'CA',
          address: 'South Lake Tahoe, CA 96150',
        ),
        vehicle: vehicle,
        totalDistanceKm: 320,
        drivingTimeMin: 200, // ~3.3 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_sacramento',
            stationName: 'Sacramento Supercharger',
            location: const LocationModel(
              latitude: 38.5816,
              longitude: -121.4944,
              name: 'Sacramento',
              city: 'Sacramento',
              state: 'CA',
            ),
            distanceFromStartKm: 140,
            distanceFromPreviousKm: 140,
            arrivalSocPercent: 52,
            departureSocPercent: 80,
            energyToChargeKwh: 21,
            chargeTimeMin: 18,
            cost: 7.35,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food', 'Shopping'],
            arrivalTime: now.add(const Duration(hours: 1, minutes: 45)),
          ),
        ],
        departureTime: now,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 21)),
      ),

      // Trip 4: San Francisco to Napa (95 km, 0 stops - short trip)
      _createTrip(
        id: 'trip_sf_napa',
        name: 'Wine Country Day Trip',
        origin: const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
          address: 'San Francisco, CA 94102',
        ),
        destination: const LocationModel(
          latitude: 38.2975,
          longitude: -122.2869,
          name: 'Napa',
          city: 'Napa',
          state: 'CA',
          address: 'Napa, CA 94559',
        ),
        vehicle: vehicle,
        totalDistanceKm: 95,
        drivingTimeMin: 70, // ~1.2 hours
        chargingStops: [], // No charging needed
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 3)),
      ),

      // Trip 5: Los Angeles to Las Vegas (435 km, 2 stops)
      _createTrip(
        id: 'trip_la_vegas',
        name: 'Vegas Weekend',
        origin: const LocationModel(
          latitude: 34.0522,
          longitude: -118.2437,
          name: 'Los Angeles',
          city: 'Los Angeles',
          state: 'CA',
          address: 'Los Angeles, CA 90001',
        ),
        destination: const LocationModel(
          latitude: 36.1699,
          longitude: -115.1398,
          name: 'Las Vegas',
          city: 'Las Vegas',
          state: 'NV',
          address: 'Las Vegas, NV 89101',
        ),
        vehicle: vehicle,
        totalDistanceKm: 435,
        drivingTimeMin: 260, // ~4.3 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_barstow',
            stationName: 'Barstow Supercharger',
            location: const LocationModel(
              latitude: 34.8983,
              longitude: -117.0225,
              name: 'Barstow',
              city: 'Barstow',
              state: 'CA',
            ),
            distanceFromStartKm: 180,
            distanceFromPreviousKm: 180,
            arrivalSocPercent: 44,
            departureSocPercent: 80,
            energyToChargeKwh: 27,
            chargeTimeMin: 22,
            cost: 9.45,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 2, minutes: 15)),
          ),
          _createStop(
            id: 'stop_2',
            stopNumber: 2,
            stationId: 'cs_primm',
            stationName: 'Primm Outlet Mall Charger',
            location: const LocationModel(
              latitude: 35.6106,
              longitude: -115.3889,
              name: 'Primm',
              city: 'Primm',
              state: 'NV',
            ),
            distanceFromStartKm: 360,
            distanceFromPreviousKm: 180,
            arrivalSocPercent: 44,
            departureSocPercent: 75,
            energyToChargeKwh: 23.25,
            chargeTimeMin: 20,
            cost: 8.14,
            chargerPowerKw: 150,
            pricePerKwh: 0.35,
            network: 'ChargePoint',
            amenities: ['Restroom', 'Shopping', 'Food'],
            arrivalTime: now.add(const Duration(hours: 4)),
          ),
        ],
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 28)),
      ),

      // Trip 6: San Francisco to Portland (1000 km, 4 stops - long trip)
      _createTrip(
        id: 'trip_sf_portland',
        name: 'Pacific Coast Adventure',
        origin: const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
          address: 'San Francisco, CA 94102',
        ),
        destination: const LocationModel(
          latitude: 45.5152,
          longitude: -122.6784,
          name: 'Portland',
          city: 'Portland',
          state: 'OR',
          address: 'Portland, OR 97201',
        ),
        vehicle: _vehicles[1], // Rivian R1T with larger battery
        totalDistanceKm: 1000,
        drivingTimeMin: 600, // ~10 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_santa_rosa',
            stationName: 'Santa Rosa Supercharger',
            location: const LocationModel(
              latitude: 38.4405,
              longitude: -122.7141,
              name: 'Santa Rosa',
              city: 'Santa Rosa',
              state: 'CA',
            ),
            distanceFromStartKm: 95,
            distanceFromPreviousKm: 95,
            arrivalSocPercent: 60,
            departureSocPercent: 85,
            energyToChargeKwh: 33.75,
            chargeTimeMin: 25,
            cost: 11.81,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 1, minutes: 15)),
          ),
          _createStop(
            id: 'stop_2',
            stopNumber: 2,
            stationId: 'cs_ukiah',
            stationName: 'Ukiah Supercharger',
            location: const LocationModel(
              latitude: 39.1502,
              longitude: -123.2078,
              name: 'Ukiah',
              city: 'Ukiah',
              state: 'CA',
            ),
            distanceFromStartKm: 210,
            distanceFromPreviousKm: 115,
            arrivalSocPercent: 67,
            departureSocPercent: 90,
            energyToChargeKwh: 31.05,
            chargeTimeMin: 28,
            cost: 9.94,
            chargerPowerKw: 150,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 2, minutes: 50)),
          ),
          _createStop(
            id: 'stop_3',
            stopNumber: 3,
            stationId: 'cs_grants_pass',
            stationName: 'Grants Pass Charger',
            location: const LocationModel(
              latitude: 42.4390,
              longitude: -123.3284,
              name: 'Grants Pass',
              city: 'Grants Pass',
              state: 'OR',
            ),
            distanceFromStartKm: 510,
            distanceFromPreviousKm: 300,
            arrivalSocPercent: 43,
            departureSocPercent: 85,
            energyToChargeKwh: 56.7,
            chargeTimeMin: 35,
            cost: 18.14,
            chargerPowerKw: 150,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food', 'Shopping'],
            arrivalTime: now.add(const Duration(hours: 5, minutes: 45)),
          ),
          _createStop(
            id: 'stop_4',
            stopNumber: 4,
            stationId: 'cs_eugene',
            stationName: 'Eugene Supercharger',
            location: const LocationModel(
              latitude: 44.0521,
              longitude: -123.0868,
              name: 'Eugene',
              city: 'Eugene',
              state: 'OR',
            ),
            distanceFromStartKm: 750,
            distanceFromPreviousKm: 240,
            arrivalSocPercent: 48,
            departureSocPercent: 80,
            energyToChargeKwh: 43.2,
            chargeTimeMin: 30,
            cost: 15.12,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food', 'WiFi'],
            arrivalTime: now.add(const Duration(hours: 8, minutes: 15)),
          ),
        ],
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 45)),
      ),

      // Trip 7: Seattle to Yellowstone (1200 km, 5 stops - adventure trip)
      _createTrip(
        id: 'trip_seattle_yellowstone',
        name: 'Yellowstone Adventure',
        origin: const LocationModel(
          latitude: 47.6062,
          longitude: -122.3321,
          name: 'Seattle',
          city: 'Seattle',
          state: 'WA',
          address: 'Seattle, WA 98101',
        ),
        destination: const LocationModel(
          latitude: 44.4280,
          longitude: -110.5885,
          name: 'Yellowstone',
          city: 'Yellowstone NP',
          state: 'WY',
          address: 'Yellowstone National Park, WY',
        ),
        vehicle: _vehicles[1], // Rivian R1T
        totalDistanceKm: 1200,
        drivingTimeMin: 720, // 12 hours
        chargingStops: [
          _createStop(
            id: 'stop_1',
            stopNumber: 1,
            stationId: 'cs_ellensburg',
            stationName: 'Ellensburg Supercharger',
            location: const LocationModel(
              latitude: 47.0018,
              longitude: -120.5292,
              name: 'Ellensburg',
              city: 'Ellensburg',
              state: 'WA',
            ),
            distanceFromStartKm: 170,
            distanceFromPreviousKm: 170,
            arrivalSocPercent: 49,
            departureSocPercent: 85,
            energyToChargeKwh: 48.6,
            chargeTimeMin: 32,
            cost: 17.01,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 2)),
          ),
          _createStop(
            id: 'stop_2',
            stopNumber: 2,
            stationId: 'cs_moses_lake',
            stationName: 'Moses Lake Charger',
            location: const LocationModel(
              latitude: 47.1301,
              longitude: -119.2780,
              name: 'Moses Lake',
              city: 'Moses Lake',
              state: 'WA',
            ),
            distanceFromStartKm: 310,
            distanceFromPreviousKm: 140,
            arrivalSocPercent: 63,
            departureSocPercent: 90,
            energyToChargeKwh: 36.45,
            chargeTimeMin: 28,
            cost: 11.66,
            chargerPowerKw: 150,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 3, minutes: 45)),
          ),
          _createStop(
            id: 'stop_3',
            stopNumber: 3,
            stationId: 'cs_spokane',
            stationName: 'Spokane Supercharger',
            location: const LocationModel(
              latitude: 47.6588,
              longitude: -117.4260,
              name: 'Spokane',
              city: 'Spokane',
              state: 'WA',
            ),
            distanceFromStartKm: 450,
            distanceFromPreviousKm: 140,
            arrivalSocPercent: 68,
            departureSocPercent: 85,
            energyToChargeKwh: 22.95,
            chargeTimeMin: 18,
            cost: 8.03,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food', 'Shopping'],
            arrivalTime: now.add(const Duration(hours: 5, minutes: 30)),
          ),
          _createStop(
            id: 'stop_4',
            stopNumber: 4,
            stationId: 'cs_missoula',
            stationName: 'Missoula Supercharger',
            location: const LocationModel(
              latitude: 46.8721,
              longitude: -114,
              name: 'Missoula',
              city: 'Missoula',
              state: 'MT',
            ),
            distanceFromStartKm: 680,
            distanceFromPreviousKm: 230,
            arrivalSocPercent: 49,
            departureSocPercent: 90,
            energyToChargeKwh: 55.35,
            chargeTimeMin: 38,
            cost: 19.37,
            chargerPowerKw: 250,
            pricePerKwh: 0.35,
            network: 'Tesla',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 8)),
          ),
          _createStop(
            id: 'stop_5',
            stopNumber: 5,
            stationId: 'cs_butte',
            stationName: 'Butte Charger',
            location: const LocationModel(
              latitude: 46.0038,
              longitude: -112.5347,
              name: 'Butte',
              city: 'Butte',
              state: 'MT',
            ),
            distanceFromStartKm: 900,
            distanceFromPreviousKm: 220,
            arrivalSocPercent: 56,
            departureSocPercent: 80,
            energyToChargeKwh: 32.4,
            chargeTimeMin: 25,
            cost: 10.37,
            chargerPowerKw: 150,
            pricePerKwh: 0.32,
            network: 'Electrify America',
            amenities: ['Restroom', 'Food'],
            arrivalTime: now.add(const Duration(hours: 10, minutes: 30)),
          ),
        ],
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 60)),
      ),

      // Trip 8: San Jose to Sacramento (180 km, 0-1 stop - medium trip)
      _createTrip(
        id: 'trip_sj_sac',
        name: 'Sacramento Day Trip',
        origin: const LocationModel(
          latitude: 37.3382,
          longitude: -121.8863,
          name: 'San Jose',
          city: 'San Jose',
          state: 'CA',
          address: 'San Jose, CA 95101',
        ),
        destination: const LocationModel(
          latitude: 38.5816,
          longitude: -121.4944,
          name: 'Sacramento',
          city: 'Sacramento',
          state: 'CA',
          address: 'Sacramento, CA 95814',
        ),
        vehicle: vehicle,
        totalDistanceKm: 180,
        drivingTimeMin: 110, // ~1.8 hours
        chargingStops: [], // No charging needed with 80% SOC
        departureTime: now,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  /// Helper to create a trip with proper battery graph data.
  TripModel _createTrip({
    required String id,
    required String name,
    required LocationModel origin,
    required LocationModel destination,
    required VehicleProfileModel vehicle,
    required double totalDistanceKm,
    required int drivingTimeMin,
    required List<ChargingStopModel> chargingStops,
    required DateTime departureTime,
    bool isFavorite = false,
    DateTime? createdAt,
  }) {
    // Calculate estimates
    final totalChargingTimeMin = chargingStops.fold<int>(
      0,
      (sum, stop) => sum + stop.estimatedChargeTimeMin,
    );
    final totalChargingCost = chargingStops.fold<double>(
      0,
      (sum, stop) => sum + stop.estimatedCost,
    );

    // Calculate arrival SOC
    var arrivalSoc = vehicle.currentSocPercent;
    if (chargingStops.isNotEmpty) {
      final lastStop = chargingStops.last;
      final lastLegDistance = totalDistanceKm - lastStop.distanceFromStartKm;
      final energyUsed = (vehicle.consumptionWhPerKm * lastLegDistance) / 1000;
      final socUsed = (energyUsed / vehicle.batteryCapacityKwh) * 100;
      arrivalSoc = lastStop.departureSocPercent - socUsed;
    } else {
      final energyUsed = (vehicle.consumptionWhPerKm * totalDistanceKm) / 1000;
      final socUsed = (energyUsed / vehicle.batteryCapacityKwh) * 100;
      arrivalSoc = vehicle.currentSocPercent - socUsed;
    }

    final eta = departureTime.add(
      Duration(minutes: drivingTimeMin + totalChargingTimeMin),
    );

    final estimates = TripEstimates(
      totalDistanceKm: totalDistanceKm,
      totalDriveTimeMin: drivingTimeMin,
      totalChargingTimeMin: totalChargingTimeMin,
      estimatedEnergyKwh: (vehicle.consumptionWhPerKm * totalDistanceKm) / 1000,
      estimatedCost: totalChargingCost,
      arrivalSocPercent: arrivalSoc.clamp(0, 100),
      requiredStops: chargingStops.length,
      eta: eta,
      tollsCost: totalDistanceKm > 500 ? 15.0 : 0,
      socAtEachStopArrival: chargingStops
          .map((s) => s.arrivalSocPercent)
          .toList(),
      socAtEachStopDeparture: chargingStops
          .map((s) => s.departureSocPercent)
          .toList(),
      distancePerLeg: _calculateDistancePerLeg(chargingStops, totalDistanceKm),
    );

    // Generate proper battery graph data
    final batteryGraphData = _generateBatteryGraphData(
      vehicle: vehicle,
      totalDistanceKm: totalDistanceKm,
      chargingStops: chargingStops,
    );

    // Generate cost breakdown
    final costBreakdown = <CostBreakdownItem>[];
    final networkCosts = <String, double>{};
    for (final stop in chargingStops) {
      final network = stop.network ?? 'Other';
      networkCosts[network] = (networkCosts[network] ?? 0) + stop.estimatedCost;
    }
    final colors = ['#00C853', '#2196F3', '#7C4DFF', '#FF9800'];
    var colorIndex = 0;
    for (final entry in networkCosts.entries) {
      costBreakdown.add(
        CostBreakdownItem(
          label: entry.key,
          amount: entry.value,
          colorHex: colors[colorIndex % colors.length],
        ),
      );
      colorIndex++;
    }

    return TripModel(
      id: id,
      name: name,
      origin: origin,
      destination: destination,
      vehicle: vehicle,
      chargingStops: chargingStops,
      estimates: estimates,
      departureTime: departureTime,
      routePolyline: 'polyline_$id',
      batteryGraphData: batteryGraphData,
      costBreakdown: costBreakdown,
      isFavorite: isFavorite,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  /// Helper to create a charging stop.
  ChargingStopModel _createStop({
    required String id,
    required int stopNumber,
    required String stationId,
    required String stationName,
    required LocationModel location,
    required double distanceFromStartKm,
    required double distanceFromPreviousKm,
    required double arrivalSocPercent,
    required double departureSocPercent,
    required double energyToChargeKwh,
    required int chargeTimeMin,
    required double cost,
    required double chargerPowerKw,
    required double pricePerKwh,
    required String network,
    required List<String> amenities,
    required DateTime arrivalTime,
  }) {
    return ChargingStopModel(
      id: id,
      stationId: stationId,
      stationName: stationName,
      location: location,
      distanceFromStartKm: distanceFromStartKm,
      distanceFromPreviousKm: distanceFromPreviousKm,
      arrivalSocPercent: arrivalSocPercent,
      departureSocPercent: departureSocPercent,
      energyToChargeKwh: energyToChargeKwh,
      estimatedChargeTimeMin: chargeTimeMin,
      estimatedCost: cost,
      chargerPowerKw: chargerPowerKw,
      pricePerKwh: pricePerKwh,
      network: network,
      amenities: amenities,
      arrivalTime: arrivalTime,
      departureTime: arrivalTime.add(Duration(minutes: chargeTimeMin)),
      stopNumber: stopNumber,
    );
  }

  List<double> _calculateDistancePerLeg(
    List<ChargingStopModel> stops,
    double totalDistance,
  ) {
    if (stops.isEmpty) {
      return [totalDistance];
    }

    final distances = <double>[];
    var prevDistance = 0.0;
    for (final stop in stops) {
      distances.add(stop.distanceFromStartKm - prevDistance);
      prevDistance = stop.distanceFromStartKm;
    }
    distances.add(totalDistance - prevDistance);
    return distances;
  }

  /// Generate accurate battery graph data.
  List<BatteryDataPoint> _generateBatteryGraphData({
    required VehicleProfileModel vehicle,
    required double totalDistanceKm,
    required List<ChargingStopModel> chargingStops,
  }) {
    final dataPoints = <BatteryDataPoint>[];
    var currentSoc = vehicle.currentSocPercent;
    var currentDistance = 0.0;
    var stopIndex = 0;

    // Add starting point
    dataPoints.add(
      BatteryDataPoint(distanceKm: 0, socPercent: currentSoc, label: 'Start'),
    );

    // Sample every 25km or at charging stops
    const sampleInterval = 25.0;

    while (currentDistance < totalDistanceKm) {
      // Check for charging stop
      if (stopIndex < chargingStops.length) {
        final stop = chargingStops[stopIndex];

        if (stop.distanceFromStartKm <= currentDistance + sampleInterval) {
          // Add point just before stop
          final distToStop = stop.distanceFromStartKm - currentDistance;
          if (distToStop > 0) {
            final energyUsed = (vehicle.consumptionWhPerKm * distToStop) / 1000;
            final socUsed = (energyUsed / vehicle.batteryCapacityKwh) * 100;
            currentSoc = (currentSoc - socUsed).clamp(0.0, 100.0);
          }
          currentDistance = stop.distanceFromStartKm;

          // Add arrival point
          dataPoints..add(
            BatteryDataPoint(
              distanceKm: currentDistance,
              socPercent: stop.arrivalSocPercent,
              isChargingStop: true,
              label: 'Stop ${stopIndex + 1} Arrive',
            ),
          )

          // Add departure point
          ..add(
            BatteryDataPoint(
              distanceKm: currentDistance,
              socPercent: stop.departureSocPercent,
              isChargingStop: true,
              label: 'Stop ${stopIndex + 1} Depart',
            ),
          );

          currentSoc = stop.departureSocPercent;
          stopIndex++;
          continue;
        }
      }

      // Regular sample point
      final nextDistance = (currentDistance + sampleInterval).clamp(
        0.0,
        totalDistanceKm,
      );
      final segmentDistance = nextDistance - currentDistance;

      if (segmentDistance > 0) {
        final energyUsed =
            (vehicle.consumptionWhPerKm * segmentDistance) / 1000;
        final socUsed = (energyUsed / vehicle.batteryCapacityKwh) * 100;
        currentSoc = (currentSoc - socUsed).clamp(0.0, 100.0);
        currentDistance = nextDistance;

        if (currentDistance >= totalDistanceKm) {
          dataPoints.add(
            BatteryDataPoint(
              distanceKm: currentDistance,
              socPercent: currentSoc,
              label: 'Destination',
            ),
          );
        } else {
          dataPoints.add(
            BatteryDataPoint(
              distanceKm: currentDistance,
              socPercent: currentSoc,
            ),
          );
        }
      } else {
        break;
      }
    }

    return dataPoints;
  }

  @override
  Future<List<TripModel>> fetchSavedTrips() async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.from(_savedTrips);
  }

  @override
  Future<TripModel?> fetchTripById(String tripId) async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return _savedTrips.firstWhere((t) => t.id == tripId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<TripModel> saveTrip(TripModel trip) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final newTrip = trip.copyWith(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    _savedTrips.add(newTrip);
    return newTrip;
  }

  @override
  Future<TripModel> updateTrip(TripModel trip) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _savedTrips.indexWhere((t) => t.id == trip.id);
    if (index >= 0) {
      final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
      _savedTrips[index] = updatedTrip;
      return updatedTrip;
    }
    return trip;
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _savedTrips.removeWhere((t) => t.id == tripId);
  }

  @override
  Future<void> toggleTripFavorite(String tripId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _savedTrips.indexWhere((t) => t.id == tripId);
    if (index >= 0) {
      _savedTrips[index] = _savedTrips[index].copyWith(
        isFavorite: !_savedTrips[index].isFavorite,
      );
    }
  }

  @override
  Future<List<VehicleProfileModel>> fetchVehicleProfiles() async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.from(_vehicles);
  }

  @override
  Future<VehicleProfileModel?> fetchDefaultVehicle() async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _vehicles.firstWhere((v) => v.isDefault);
    } catch (_) {
      return _vehicles.isNotEmpty ? _vehicles.first : null;
    }
  }

  @override
  Future<VehicleProfileModel> saveVehicleProfile(
    VehicleProfileModel vehicle,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final newVehicle = vehicle.copyWith(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
    );
    _vehicles.add(newVehicle);
    return newVehicle;
  }

  @override
  Future<VehicleProfileModel> updateVehicleProfile(
    VehicleProfileModel vehicle,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
    }
    return vehicle;
  }

  @override
  Future<void> deleteVehicleProfile(String vehicleId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _vehicles.removeWhere((v) => v.id == vehicleId);
  }

  @override
  Future<List<LocationModel>> searchLocations(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Return dummy search results
    final lowerQuery = query.toLowerCase();

    final allLocations = [
      const LocationModel(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'San Francisco',
        city: 'San Francisco',
        state: 'CA',
        address: 'San Francisco, CA 94102',
      ),
      const LocationModel(
        latitude: 34.0522,
        longitude: -118.2437,
        name: 'Los Angeles',
        city: 'Los Angeles',
        state: 'CA',
        address: 'Los Angeles, CA 90001',
      ),
      const LocationModel(
        latitude: 32.7157,
        longitude: -117.1611,
        name: 'San Diego',
        city: 'San Diego',
        state: 'CA',
        address: 'San Diego, CA 92101',
      ),
      const LocationModel(
        latitude: 37.3382,
        longitude: -121.8863,
        name: 'San Jose',
        city: 'San Jose',
        state: 'CA',
        address: 'San Jose, CA 95101',
      ),
      const LocationModel(
        latitude: 38.5816,
        longitude: -121.4944,
        name: 'Sacramento',
        city: 'Sacramento',
        state: 'CA',
        address: 'Sacramento, CA 95814',
      ),
      const LocationModel(
        latitude: 39.0968,
        longitude: -120.0324,
        name: 'South Lake Tahoe',
        city: 'South Lake Tahoe',
        state: 'CA',
        address: 'South Lake Tahoe, CA 96150',
      ),
      const LocationModel(
        latitude: 38.2975,
        longitude: -122.2869,
        name: 'Napa',
        city: 'Napa',
        state: 'CA',
        address: 'Napa, CA 94559',
      ),
      const LocationModel(
        latitude: 36.7783,
        longitude: -119.4179,
        name: 'Fresno',
        city: 'Fresno',
        state: 'CA',
        address: 'Fresno, CA 93721',
      ),
    ];

    return allLocations
        .where(
          (loc) =>
              (loc.name?.toLowerCase().contains(lowerQuery) ?? false) ||
              (loc.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              (loc.address?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .take(5)
        .toList();
  }

  @override
  Future<RouteResult> getRoute({
    required LocationModel origin,
    required LocationModel destination,
    List<LocationModel> waypoints = const [],
    bool avoidTolls = false,
    bool avoidHighways = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // Calculate approximate distance using Haversine formula
    final distanceKm = _calculateHaversineDistance(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );

    // Add waypoint distances
    var totalDistanceKm = distanceKm;
    if (waypoints.isNotEmpty) {
      var prevLat = origin.latitude;
      var prevLon = origin.longitude;
      for (final wp in waypoints) {
        totalDistanceKm += _calculateHaversineDistance(
          prevLat,
          prevLon,
          wp.latitude,
          wp.longitude,
        );
        prevLat = wp.latitude;
        prevLon = wp.longitude;
      }
      totalDistanceKm += _calculateHaversineDistance(
        prevLat,
        prevLon,
        destination.latitude,
        destination.longitude,
      );
    }

    // Estimate duration (assuming ~70 km/h average with highways)
    final durationHours = totalDistanceKm / 70.0;
    final durationSeconds = (durationHours * 3600).round();

    return RouteResult(
      distanceMeters: totalDistanceKm * 1000,
      durationSeconds: durationSeconds,
      polyline: 'dummy_polyline_${origin.latitude}_${destination.latitude}',
      tollsCost: avoidTolls ? 0 : (totalDistanceKm > 200 ? 15.0 : 0),
      summary: '${origin.shortDisplay} → ${destination.shortDisplay}',
    );
  }

  double _calculateHaversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) *
            _cos(_toRadians(lat2)) *
            _sin(dLon / 2) *
            _sin(dLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double deg) => deg * 3.14159265359 / 180;
  double _sin(double x) {
    // Simple sin approximation
    x = x % (2 * 3.14159265359);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }

  double _cos(double x) => _sin(x + 3.14159265359 / 2);
  double _sqrt(double x) {
    if (x <= 0) {
      return 0;
    }
    var guess = x / 2;
    for (var i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _atan2(double y, double x) {
    if (x > 0) {
      return _atan(y / x);
    }
    if (x < 0 && y >= 0) {
      return _atan(y / x) + 3.14159265359;
    }
    if (x < 0 && y < 0) {
      return _atan(y / x) - 3.14159265359;
    }
    if (y > 0) {
      return 3.14159265359 / 2;
    }
    if (y < 0) {
      return -3.14159265359 / 2;
    }
    return 0;
  }

  double _atan(double x) {
    // Simple atan approximation
    if (x.abs() > 1) {
      return (3.14159265359 / 2 - _atan(1 / x)) * (x > 0 ? 1 : -1);
    }
    return x - (x * x * x) / 3 + (x * x * x * x * x) / 5;
  }

  @override
  Future<List<ChargingStationInfo>> findChargingStationsAlongRoute({
    required String routePolyline,
    double maxDistanceFromRouteKm = 5.0,
    double minChargerPowerKw = 50.0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Return dummy charging stations along the route
    return [
      const ChargingStationInfo(
        stationId: 'cs_001',
        stationName: 'Gilroy Supercharger',
        location: LocationModel(
          latitude: 37.0058,
          longitude: -121.5683,
          name: 'Gilroy Supercharger',
          city: 'Gilroy',
          state: 'CA',
        ),
        distanceFromStartKm: 125,
        chargerPowerKw: 250,
        pricePerKwh: 0.35,
        network: 'Tesla Supercharger',
        amenities: ['Restroom', 'Food', 'WiFi'],
      ),
      const ChargingStationInfo(
        stationId: 'cs_002',
        stationName: 'Kettleman City Station',
        location: LocationModel(
          latitude: 35.9894,
          longitude: -119.9616,
          name: 'Kettleman City Station',
          city: 'Kettleman City',
          state: 'CA',
        ),
        distanceFromStartKm: 280,
        chargerPowerKw: 350,
        pricePerKwh: 0.32,
        network: 'Electrify America',
        amenities: ['Restroom', 'Food', 'Shopping'],
      ),
      const ChargingStationInfo(
        stationId: 'cs_003',
        stationName: 'Tejon Ranch Supercharger',
        location: LocationModel(
          latitude: 34.9872,
          longitude: -118.9486,
          name: 'Tejon Ranch Supercharger',
          city: 'Lebec',
          state: 'CA',
        ),
        distanceFromStartKm: 420,
        chargerPowerKw: 250,
        pricePerKwh: 0.38,
        network: 'Tesla Supercharger',
        amenities: ['Restroom', 'Food'],
      ),
      const ChargingStationInfo(
        stationId: 'cs_004',
        stationName: 'Santa Clarita Charger',
        location: LocationModel(
          latitude: 34.3917,
          longitude: -118.5426,
          name: 'Santa Clarita Charger',
          city: 'Santa Clarita',
          state: 'CA',
        ),
        distanceFromStartKm: 510,
        chargerPowerKw: 150,
        pricePerKwh: 0.40,
        network: 'ChargePoint',
        amenities: ['Restroom', 'Shopping'],
      ),
    ];
  }

  @override
  Future<TripModel> calculateTrip({
    required LocationModel origin,
    required LocationModel destination,
    required VehicleProfileModel vehicle,
    List<LocationModel> waypoints = const [],
    TripPreferences preferences = const TripPreferences(),
    DateTime? departureTime,
  }) async {
    // Get route
    final route = await getRoute(
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      avoidTolls: preferences.avoidTolls,
      avoidHighways: preferences.avoidHighways,
    );

    final distanceKm = TripCalculations.calculateDistanceKm(
      route.distanceMeters,
    );

    // Find charging stations
    final stations = await findChargingStationsAlongRoute(
      routePolyline: route.polyline,
      minChargerPowerKw: preferences.preferFastChargers ? 100 : 50,
    );

    // Filter stations to only those within the route distance
    final relevantStations = stations
        .where((s) => s.distanceFromStartKm < distanceKm)
        .toList();

    // Plan charging stops
    final chargingStops = TripCalculations.planChargingStops(
      totalDistanceKm: distanceKm,
      vehicle: vehicle,
      availableStations: relevantStations,
      preferences: preferences,
      departureTime: departureTime,
    );

    // Calculate estimates
    final estimates = TripCalculations.calculateTripEstimates(
      totalDistanceKm: distanceKm,
      routeDurationSeconds: route.durationSeconds,
      vehicle: vehicle,
      chargingStops: chargingStops,
      departureTime: departureTime,
      tollsCost: route.tollsCost ?? 0,
    );

    // Generate graph data
    final batteryGraphData = TripCalculations.generateBatteryGraphData(
      vehicle: vehicle,
      totalDistanceKm: distanceKm,
      chargingStops: chargingStops,
    );

    final costBreakdown = TripCalculations.generateCostBreakdown(
      chargingStops: chargingStops,
      tollsCost: route.tollsCost ?? 0,
    );

    return TripModel(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      origin: origin,
      destination: destination,
      vehicle: vehicle,
      waypoints: waypoints,
      chargingStops: chargingStops,
      preferences: preferences,
      estimates: estimates,
      departureTime: departureTime ?? DateTime.now(),
      routePolyline: route.polyline,
      batteryGraphData: batteryGraphData,
      costBreakdown: costBreakdown,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<TripModel>> fetchRecentTrips({int limit = 5}) async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final sorted = List<TripModel>.from(_savedTrips)
      ..sort(
        (a, b) => (b.createdAt ?? DateTime(2000)).compareTo(
          a.createdAt ?? DateTime(2000),
        ),
      );
    return sorted.take(limit).toList();
  }

  @override
  Future<List<TripModel>> fetchFavoriteTrips() async {
    await _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _savedTrips.where((t) => t.isFavorite).toList();
  }

  @override
  Future<void> cacheTripOffline(TripModel trip) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // In real implementation, save to local storage
  }

  @override
  Future<List<TripModel>> getCachedTrips() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // In real implementation, read from local storage
    return [];
  }

  @override
  Future<void> clearTripCache() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // In real implementation, clear local storage
  }
}
