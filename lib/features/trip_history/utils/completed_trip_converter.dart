/// File: lib/features/trip_history/utils/completed_trip_converter.dart
/// Purpose: Converter to transform CompletedTrip to TripModel for reuse of existing screens
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Extend conversion for additional fields
library;

import '../../trip_planner/models/models.dart';
import '../domain/entities/completed_trip.dart';

/// Converter utility for transforming CompletedTrip to TripModel.
class CompletedTripConverter {
  /// Convert CompletedTrip to TripModel format for displaying in existing screens.
  static TripModel toTripModel(CompletedTrip completedTrip) {
    // Convert battery timeline to BatteryDataPoint list
    final batteryGraphData = completedTrip.batteryTimeline
        .map<BatteryDataPoint>((BatteryPoint point) => BatteryDataPoint(
              distanceKm: point.distanceKm,
              socPercent: point.socPercent,
              isChargingStop: point.isChargingStop,
              label: point.label,
            ))
        .toList();

    // Convert charging stops
    final chargingStops = completedTrip.chargingStops;

    // Calculate estimates from completed trip data
    final totalDistanceKm = completedTrip.distanceKm;
    final totalDriveTimeMin =
        completedTrip.drivingTime?.inMinutes ?? completedTrip.totalTime.inMinutes;
    final totalChargingTimeMin = completedTrip.chargingTime?.inMinutes ?? 0;

    final estimates = TripEstimates(
      totalDistanceKm: totalDistanceKm,
      totalDriveTimeMin: totalDriveTimeMin,
      totalChargingTimeMin: totalChargingTimeMin,
      estimatedEnergyKwh: completedTrip.energyConsumedKwh ?? 0,
      estimatedCost: completedTrip.estimatedCost,
      arrivalSocPercent: batteryGraphData.isNotEmpty
          ? batteryGraphData.last.socPercent
          : 20.0,
      requiredStops: completedTrip.stopCount,
      eta: completedTrip.createdAt.add(completedTrip.totalTime),
      socAtEachStopArrival: chargingStops
          .map<double>((ChargingStopModel stop) => stop.arrivalSocPercent)
          .toList(),
      socAtEachStopDeparture: chargingStops
          .map<double>((ChargingStopModel stop) => stop.departureSocPercent)
          .toList(),
      distancePerLeg: chargingStops
          .map<double>((ChargingStopModel stop) => stop.distanceFromStartKm)
          .toList(),
    );

    // Create default vehicle profile (we don't have this in CompletedTrip)
    final vehicle = VehicleProfileModel(
      id: 'default',
      name: completedTrip.vehicleName ?? 'Default Vehicle',
      batteryCapacityKwh: 75, // Default value
      consumptionWhPerKm: 180, // Default value
      currentSocPercent: batteryGraphData.isNotEmpty
          ? batteryGraphData.first.socPercent
          : 80.0,
    );

    return TripModel(
      id: completedTrip.id,
      origin: completedTrip.from.location,
      destination: completedTrip.to.location,
      vehicle: vehicle,
      chargingStops: chargingStops,
      estimates: estimates,
      name: completedTrip.title,
      isFavorite: completedTrip.isFavorite,
      createdAt: completedTrip.createdAt,
      batteryGraphData: batteryGraphData,
    );
  }
}
