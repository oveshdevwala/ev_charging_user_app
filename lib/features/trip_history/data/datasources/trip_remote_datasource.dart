import '../../../trip_planner/trip_planner.dart';
import '../models/completed_trip_model.dart';
import '../models/monthly_analytics_model.dart';
import '../models/trip_record_model.dart';

abstract class TripRemoteDataSource {
  Future<List<TripRecordModel>> getTripHistory();
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month);
  Future<List<int>> exportTripReport(String month); // Returns bytes for PDF

  /// Get all completed trips.
  Future<List<CompletedTripModel>> getAllTrips();

  /// Get a single completed trip by ID.
  Future<CompletedTripModel?> getTripById(String tripId);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  // In a real app, inject Dio or Http client here
  // final Dio client;

  TripRemoteDataSourceImpl();

  @override
  Future<List<TripRecordModel>> getTripHistory() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock Response
    return List.generate(10, (index) {
      return TripRecordModel(
        id: 'trip_$index',
        stationName: 'Station $index',
        startTime: DateTime.now().subtract(Duration(days: index, hours: 2)),
        endTime: DateTime.now().subtract(Duration(days: index)),
        energyConsumedKWh: 15.5 + index,
        cost: 250.0 + (index * 10),
        vehicle: 'Tesla Model 3',
        efficiencyScore: 4.5,
      );
    });
  }

  @override
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month) async {
    await Future.delayed(const Duration(seconds: 1));

    return MonthlyAnalyticsModel(
      month: month,
      totalCost: 1500,
      totalEnergy: 300.5,
      avgEfficiency: 4.2,
      comparisonPercentage: 12.5,
      trendData: List.generate(30, (index) {
        return DailyBreakdownModel(
          date: DateTime.now().subtract(Duration(days: index)),
          cost: 50.0 + (index % 5) * 10,
          energy: 10.0 + (index % 5),
        );
      }),
    );
  }

  @override
  Future<List<int>> exportTripReport(String month) async {
    await Future.delayed(const Duration(seconds: 2));
    // Return dummy bytes
    return [0, 1, 2, 3];
  }

  @override
  Future<List<CompletedTripModel>> getAllTrips() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock completed trips matching screenshots
    return _generateMockTrips();
  }

  @override
  Future<CompletedTripModel?> getTripById(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final trips = await getAllTrips();
    try {
      return trips.firstWhere((trip) => trip.id == tripId);
    } catch (e) {
      return null;
    }
  }

  /// Generate mock completed trips based on screenshots.
  List<CompletedTripModel> _generateMockTrips() {
    final now = DateTime.now();

    // Trip 1: Weekend Trip to LA (from screenshot)
    final trip1 = CompletedTripModel(
      id: 'trip_la_weekend',
      title: 'Weekend Trip to LA',
      from: const LocationPointModel(
        name: 'San Francisco, CA',
        location: LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
        ),
        address: 'San Francisco, CA',
      ),
      to: const LocationPointModel(
        name: 'Los Angeles, CA',
        location: LocationModel(
          latitude: 34.0522,
          longitude: -118.2437,
          name: 'Los Angeles',
          city: 'Los Angeles',
          state: 'CA',
        ),
        address: 'Los Angeles, CA',
      ),
      distanceKm: 615,
      totalTimeMinutes: 415, // 6h 55m
      stopCount: 2,
      estimatedCost: 17,
      drivingTimeMinutes: 370, // 6h 10m
      chargingTimeMinutes: 45,
      batteryTimeline: _generateBatteryTimeline(615, [
        {'distance': 123.0, 'soc': 55.0, 'charging': true},
        {'distance': 300.0, 'soc': 40.0, 'charging': true},
      ]),
      chargingStops: const [],
      createdAt: now.subtract(const Duration(days: 7)),
      isFavorite: true,
      vehicleName: 'Tesla Model 3',
    );

    // Trip 2: Wine Country Day Trip
    final trip2 = CompletedTripModel(
      id: 'trip_wine_country',
      title: 'Wine Country Day Trip',
      from: const LocationPointModel(
        name: 'San Francisco, CA',
        location: LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
        ),
      ),
      to: const LocationPointModel(
        name: 'Napa, CA',
        location: LocationModel(
          latitude: 38.2975,
          longitude: -122.2869,
          name: 'Napa',
          city: 'Napa',
          state: 'CA',
        ),
      ),
      distanceKm: 95,
      totalTimeMinutes: 70, // 1h 10m
      stopCount: 0,
      estimatedCost: 0,
      drivingTimeMinutes: 70,
      chargingTimeMinutes: 0,
      batteryTimeline: _generateBatteryTimeline(95, []),
      chargingStops: const [],
      createdAt: now.subtract(const Duration(days: 5)),
      vehicleName: 'Tesla Model 3',
    );

    // Trip 3: Sacramento Day Trip
    final trip3 = CompletedTripModel(
      id: 'trip_sacramento',
      title: 'Sacramento Day Trip',
      from: const LocationPointModel(
        name: 'San Francisco, CA',
        location: LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          name: 'San Francisco',
          city: 'San Francisco',
          state: 'CA',
        ),
      ),
      to: const LocationPointModel(
        name: 'Sacramento, CA',
        location: LocationModel(
          latitude: 38.5816,
          longitude: -121.4944,
          name: 'Sacramento',
          city: 'Sacramento',
          state: 'CA',
        ),
      ),
      distanceKm: 180,
      totalTimeMinutes: 110, // 1h 50m
      stopCount: 0,
      estimatedCost: 0,
      drivingTimeMinutes: 110,
      chargingTimeMinutes: 0,
      batteryTimeline: _generateBatteryTimeline(180, []),
      chargingStops: const [],
      createdAt: now.subtract(const Duration(days: 3)),
      vehicleName: 'Tesla Model 3',
    );

    return [trip1, trip2, trip3];
  }

  /// Generate battery timeline with charging stops.
  List<BatteryPointModel> _generateBatteryTimeline(
    double totalDistance,
    List<Map<String, dynamic>> chargingStops,
  ) {
    final points = <BatteryPointModel>[];
    var currentSoc = 80;
    var currentDistance = 0;

    for (final stop in chargingStops) {
      final stopDistance = stop['distance'] as double;
      final arrivalSoc = stop['soc'] as double;

      // Add points before charging stop
      while (currentDistance < stopDistance) {
        final progress = currentDistance / stopDistance;
        final soc = currentSoc - (currentSoc - arrivalSoc) * progress;
        points.add(
          BatteryPointModel(distanceKm: currentDistance.toDouble(), socPercent: soc),
        );
        currentDistance += 50; // Every 50km
      }

      // Add charging stop
      points.add(
        BatteryPointModel(
          distanceKm: stopDistance,
          socPercent: arrivalSoc,
          isChargingStop: true,
          label: 'Charging',
        ),
      );

      // Charging increases SOC to 80%
      currentSoc = 80;
      points.add(
        BatteryPointModel(
          distanceKm: stopDistance,
          socPercent: 80,
          isChargingStop: true,
          label: 'Charged',
        ),
      );
    }

    // Add remaining points
    while (currentDistance < totalDistance) {
      final remaining = totalDistance - currentDistance;
      final soc = currentSoc - (remaining / 100.0) * 2.0; // ~2% per 100km
      points.add(
        BatteryPointModel(
          distanceKm: currentDistance.toDouble(),
          socPercent: soc.clamp(0.0, 100.0),
        ),
      );
      currentDistance += 50;
    }

    // Add final point
    points.add(
      BatteryPointModel(
        distanceKm: totalDistance,
        socPercent: (currentSoc - (totalDistance / 100.0) * 2.0).clamp(
          0.0,
          100.0,
        ),
      ),
    );

    return points;
  }
}
