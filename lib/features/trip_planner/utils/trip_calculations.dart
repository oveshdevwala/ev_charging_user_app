/// File: lib/features/trip_planner/utils/trip_calculations.dart
/// Purpose: Pure calculation functions for EV trip planning with explicit formulas
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Adjust constants for different vehicle types
///    - Modify charging curve model for accuracy
///
/// All calculations are pure functions for testability.
/// Each function documents its formula and assumptions.
library;

import '../models/models.dart';

/// Constants for trip calculations.
abstract final class TripCalculationConstants {
  /// Safety buffer in km to add when planning stops.
  static const double safetyBufferKm = 20;

  /// Minimum SOC (%) to maintain at all times.
  static const double minimumSocPercent = 5;

  /// Charging curve taper factor (accounts for slower charging at high SOC).
  /// Charging slows down above ~80% SOC. This factor approximates that.
  static const double chargingTaperFactor = 1.15;

  /// Average speed for ETA calculations (km/h).
  static const double averageSpeedKmh = 80;

  /// Default traffic buffer in minutes.
  static const int trafficBufferMinutes = 15;

  /// Energy efficiency loss in cold weather (%).
  static const double coldWeatherEfficiencyLoss = 0.20;

  /// Energy efficiency loss with AC/heating (%).
  static const double hvacEfficiencyLoss = 0.10;
}

/// Result of energy consumption calculation.
class EnergyConsumptionResult {
  const EnergyConsumptionResult({
    required this.distanceKm,
    required this.energyKwh,
    required this.socUsedPercent,
  });

  final double distanceKm;
  final double energyKwh;
  final double socUsedPercent;
}

/// Result of SOC calculation.
class SocCalculationResult {
  const SocCalculationResult({
    required this.startingSocPercent,
    required this.endingSocPercent,
    required this.energyUsedKwh,
    required this.needsCharging,
    required this.socDeficitPercent,
  });

  final double startingSocPercent;
  final double endingSocPercent;
  final double energyUsedKwh;
  final bool needsCharging;
  final double socDeficitPercent;
}

/// Result of charging time calculation.
class ChargingTimeResult {
  const ChargingTimeResult({
    required this.energyToChargeKwh,
    required this.chargingTimeMinutes,
    required this.effectiveChargePowerKw,
    required this.estimatedCost,
  });

  final double energyToChargeKwh;
  final int chargingTimeMinutes;
  final double effectiveChargePowerKw;
  final double estimatedCost;
}

/// Trip planning calculation utilities.
/// All methods are pure functions for testability.
abstract final class TripCalculations {
  // ============================================================
  // DISTANCE & TRAVEL TIME CALCULATIONS
  // ============================================================

  /// Calculate distance from route data.
  ///
  /// Formula: distanceKm = distanceMeters / 1000
  ///
  /// [distanceMeters] - Raw distance from route provider in meters.
  /// Returns distance in kilometers.
  static double calculateDistanceKm(double distanceMeters) {
    return distanceMeters / 1000.0;
  }

  /// Calculate travel time from route duration.
  ///
  /// Formula: driveTimeMinutes = durationSeconds / 60
  ///
  /// [durationSeconds] - Raw duration from route provider in seconds.
  /// Returns duration in minutes.
  static int calculateDriveTimeMinutes(int durationSeconds) {
    return (durationSeconds / 60).ceil();
  }

  // ============================================================
  // ENERGY CONSUMPTION CALCULATIONS
  // ============================================================

  /// Calculate energy consumption for a given distance.
  ///
  /// Formula:
  ///   energyWh = consumptionWhPerKm × distanceKm
  ///   energyKwh = energyWh / 1000
  ///
  /// [distanceKm] - Distance in kilometers.
  /// [consumptionWhPerKm] - Vehicle's energy consumption in Wh/km.
  /// Returns energy consumption result.
  static EnergyConsumptionResult calculateEnergyConsumption({
    required double distanceKm,
    required double consumptionWhPerKm,
    required double batteryCapacityKwh,
  }) {
    // Step 1: Calculate energy needed in Wh
    // Formula: energyWh = consumptionWhPerKm × distanceKm
    final energyWh = consumptionWhPerKm * distanceKm;

    // Step 2: Convert to kWh
    // Formula: energyKwh = energyWh / 1000
    final energyKwh = energyWh / 1000.0;

    // Step 3: Calculate SOC percentage used
    // Formula: socUsedPercent = (energyKwh / batteryCapacityKwh) × 100
    final socUsedPercent =
        batteryCapacityKwh > 0 ? (energyKwh / batteryCapacityKwh) * 100.0 : 0.0;

    return EnergyConsumptionResult(
      distanceKm: distanceKm,
      energyKwh: energyKwh,
      socUsedPercent: socUsedPercent,
    );
  }

  // ============================================================
  // SOC (STATE OF CHARGE) CALCULATIONS
  // ============================================================

  /// Calculate SOC at arrival given starting SOC and energy used.
  ///
  /// Formula:
  ///   socNeededPercent = (energyKwh / batteryCapacityKwh) × 100
  ///   socAtArrival = startingSocPercent - socNeededPercent
  ///   needsCharging = socAtArrival < reserveSocPercent
  ///
  /// [startingSocPercent] - Starting SOC (0-100).
  /// [energyKwh] - Energy needed for the leg.
  /// [batteryCapacityKwh] - Usable battery capacity.
  /// [reserveSocPercent] - Minimum SOC to maintain.
  /// Returns SOC calculation result.
  static SocCalculationResult calculateSocAtArrival({
    required double startingSocPercent,
    required double energyKwh,
    required double batteryCapacityKwh,
    required double reserveSocPercent,
  }) {
    // Step 1: Calculate SOC percentage used
    // Formula: socUsedPercent = (energyKwh / batteryCapacityKwh) × 100
    final socUsedPercent =
        batteryCapacityKwh > 0 ? (energyKwh / batteryCapacityKwh) * 100.0 : 0.0;

    // Step 2: Calculate SOC at arrival
    // Formula: socAtArrival = startingSoc - socUsed
    final rawSocAtArrival = startingSocPercent - socUsedPercent;

    // Step 3: Clamp to valid range [0, 100]
    final socAtArrival = rawSocAtArrival.clamp(0.0, 100.0);

    // Step 4: Check if charging is needed
    // Formula: needsCharging = socAtArrival < reserveSocPercent
    final needsCharging = socAtArrival < reserveSocPercent;

    // Step 5: Calculate SOC deficit (how much below reserve)
    // Formula: deficit = max(0, reserveSoc - socAtArrival)
    final socDeficit = (reserveSocPercent - socAtArrival).clamp(0.0, 100.0);

    return SocCalculationResult(
      startingSocPercent: startingSocPercent,
      endingSocPercent: socAtArrival,
      energyUsedKwh: energyKwh,
      needsCharging: needsCharging,
      socDeficitPercent: socDeficit,
    );
  }

  /// Calculate maximum range with current SOC.
  ///
  /// Formula:
  ///   currentEnergyKwh = batteryCapacityKwh × (currentSocPercent / 100)
  ///   rangeKm = (currentEnergyKwh × 1000) / consumptionWhPerKm
  ///
  /// [currentSocPercent] - Current SOC (0-100).
  /// [batteryCapacityKwh] - Usable battery capacity.
  /// [consumptionWhPerKm] - Energy consumption in Wh/km.
  /// Returns maximum range in kilometers.
  static double calculateRangeKm({
    required double currentSocPercent,
    required double batteryCapacityKwh,
    required double consumptionWhPerKm,
  }) {
    if (consumptionWhPerKm <= 0) {
      return 0;
    }

    // Step 1: Calculate current energy available
    // Formula: currentEnergyKwh = batteryCapacity × (currentSoc / 100)
    final currentEnergyKwh = batteryCapacityKwh * (currentSocPercent / 100.0);

    // Step 2: Calculate range
    // Formula: rangeKm = (energyKwh × 1000) / consumptionWhPerKm
    return (currentEnergyKwh * 1000.0) / consumptionWhPerKm;
  }

  /// Calculate usable range (above reserve SOC).
  ///
  /// Same as calculateRangeKm but uses (currentSoc - reserveSoc).
  static double calculateUsableRangeKm({
    required double currentSocPercent,
    required double reserveSocPercent,
    required double batteryCapacityKwh,
    required double consumptionWhPerKm,
  }) {
    final usableSocPercent =
        (currentSocPercent - reserveSocPercent).clamp(0.0, 100.0);

    return calculateRangeKm(
      currentSocPercent: usableSocPercent,
      batteryCapacityKwh: batteryCapacityKwh,
      consumptionWhPerKm: consumptionWhPerKm,
    );
  }

  // ============================================================
  // CHARGING TIME CALCULATIONS
  // ============================================================

  /// Calculate charging time and cost.
  ///
  /// Formula:
  ///   energyToCharge = batteryCapacity × ((targetSoc - currentSoc) / 100)
  ///   rawChargingTimeHours = energyToCharge / chargerPowerKw
  ///   adjustedTime = rawTime × taperFactor (if charging above 80%)
  ///   chargingTimeMinutes = adjustedTime × 60
  ///   cost = energyToCharge × pricePerKwh
  ///
  /// The taper factor accounts for slower charging above ~80% SOC due to
  /// battery protection (charging curve). EV batteries slow down charging
  /// as they approach full to prevent degradation.
  ///
  /// [currentSocPercent] - Current SOC (0-100).
  /// [targetSocPercent] - Target SOC (0-100).
  /// [batteryCapacityKwh] - Usable battery capacity.
  /// [maxVehicleChargePowerKw] - Vehicle's max charge acceptance.
  /// [chargerPowerKw] - Charger's max output power.
  /// [pricePerKwh] - Price per kWh at this charger.
  /// Returns charging time result.
  static ChargingTimeResult calculateChargingTime({
    required double currentSocPercent,
    required double targetSocPercent,
    required double batteryCapacityKwh,
    required double maxVehicleChargePowerKw,
    required double chargerPowerKw,
    double pricePerKwh = 0.30,
  }) {
    // Step 1: Calculate energy to charge
    // Formula: energyKwh = capacity × ((targetSoc - currentSoc) / 100)
    final socToCharge = (targetSocPercent - currentSocPercent).clamp(0.0, 100.0);
    final energyToChargeKwh = batteryCapacityKwh * (socToCharge / 100.0);

    // Step 2: Determine effective charge power
    // Formula: effectivePower = min(vehicleMax, chargerMax)
    final effectiveChargePowerKw =
        maxVehicleChargePowerKw < chargerPowerKw
            ? maxVehicleChargePowerKw
            : chargerPowerKw;

    if (effectiveChargePowerKw <= 0 || energyToChargeKwh <= 0) {
      return const ChargingTimeResult(
        energyToChargeKwh: 0,
        chargingTimeMinutes: 0,
        effectiveChargePowerKw: 0,
        estimatedCost: 0,
      );
    }

    // Step 3: Calculate raw charging time
    // Formula: timeHours = energyKwh / powerKw
    final rawChargingTimeHours = energyToChargeKwh / effectiveChargePowerKw;

    // Step 4: Apply taper factor if charging above 80%
    // The charging curve slows down significantly above 80% SOC.
    // We apply a 15% penalty (1.15x time) when target is above 80%.
    final taperFactor = targetSocPercent > 80
        ? TripCalculationConstants.chargingTaperFactor
        : 1.0;
    final adjustedTimeHours = rawChargingTimeHours * taperFactor;

    // Step 5: Convert to minutes
    // Formula: timeMinutes = timeHours × 60
    final chargingTimeMinutes = (adjustedTimeHours * 60).ceil();

    // Step 6: Calculate cost
    // Formula: cost = energyKwh × pricePerKwh
    final estimatedCost = energyToChargeKwh * pricePerKwh;

    return ChargingTimeResult(
      energyToChargeKwh: energyToChargeKwh,
      chargingTimeMinutes: chargingTimeMinutes,
      effectiveChargePowerKw: effectiveChargePowerKw,
      estimatedCost: estimatedCost,
    );
  }

  // ============================================================
  // CHARGING STOP PLANNING
  // ============================================================

  /// Plan charging stops for a trip.
  ///
  /// Algorithm (Greedy with safety buffer):
  /// 1. Start with current SOC
  /// 2. For each segment, calculate energy needed
  /// 3. If SOC would drop below reserve + buffer, find a charging stop
  /// 4. Charge to target SOC (considering max per stop preference)
  /// 5. Continue until destination is reached
  ///
  /// [totalDistanceKm] - Total trip distance.
  /// [vehicle] - Vehicle profile with battery and consumption info.
  /// [availableStations] - List of charging stations along route with distances.
  /// [preferences] - Trip preferences.
  /// [departureTime] - Planned departure time.
  /// Returns list of planned charging stops.
  static List<ChargingStopModel> planChargingStops({
    required double totalDistanceKm,
    required VehicleProfileModel vehicle,
    required List<ChargingStationInfo> availableStations,
    required TripPreferences preferences,
    DateTime? departureTime,
  }) {
    final stops = <ChargingStopModel>[];

    // Current state tracking
    var currentSocPercent = vehicle.currentSocPercent;
    var currentDistanceKm = 0.0;
    var currentTime = departureTime ?? DateTime.now();

    // Sort stations by distance
    final sortedStations = List<ChargingStationInfo>.from(availableStations)
      ..sort((a, b) => a.distanceFromStartKm.compareTo(b.distanceFromStartKm));

    var stopNumber = 0;

    while (currentDistanceKm < totalDistanceKm) {
      // Calculate how far we can go with current SOC
      final usableRangeKm = calculateUsableRangeKm(
        currentSocPercent: currentSocPercent,
        reserveSocPercent: vehicle.reserveSocPercent,
        batteryCapacityKwh: vehicle.batteryCapacityKwh,
        consumptionWhPerKm: vehicle.consumptionWhPerKm,
      );

      final maxReachableDistanceKm =
          currentDistanceKm + usableRangeKm - TripCalculationConstants.safetyBufferKm;

      // Check if we can reach destination
      if (maxReachableDistanceKm >= totalDistanceKm) {
        break; // No more stops needed
      }

      // Find the best charging station within reach
      ChargingStationInfo? selectedStation;
      for (final station in sortedStations) {
        if (station.distanceFromStartKm > currentDistanceKm &&
            station.distanceFromStartKm <= maxReachableDistanceKm &&
            station.distanceFromStartKm < totalDistanceKm) {
          // Prefer stations further along the route but still reachable
          if (selectedStation == null ||
              station.distanceFromStartKm > selectedStation.distanceFromStartKm) {
            selectedStation = station;
          }
        }
      }

      if (selectedStation == null) {
        // No suitable station found - this shouldn't happen with good data
        // Break to avoid infinite loop
        break;
      }

      stopNumber++;

      // Calculate SOC at arrival to this station
      final legDistanceKm = selectedStation.distanceFromStartKm - currentDistanceKm;
      final energyForLeg = calculateEnergyConsumption(
        distanceKm: legDistanceKm,
        consumptionWhPerKm: vehicle.consumptionWhPerKm,
        batteryCapacityKwh: vehicle.batteryCapacityKwh,
      );

      final arrivalSocPercent =
          (currentSocPercent - energyForLeg.socUsedPercent).clamp(0.0, 100.0);

      // Calculate target SOC for this stop
      // Check how much energy we need to reach the next potential stop or destination
      final distanceToDestination = totalDistanceKm - selectedStation.distanceFromStartKm;
      final energyToDestination = calculateEnergyConsumption(
        distanceKm: distanceToDestination,
        consumptionWhPerKm: vehicle.consumptionWhPerKm,
        batteryCapacityKwh: vehicle.batteryCapacityKwh,
      );

      // Target SOC should be enough to reach destination or next stop + reserve
      final targetSocPercent = (energyToDestination.socUsedPercent +
              vehicle.reserveSocPercent +
              10) // 10% buffer
          .clamp(arrivalSocPercent, preferences.maxChargePerStop);

      // Calculate charging time
      final chargingResult = calculateChargingTime(
        currentSocPercent: arrivalSocPercent,
        targetSocPercent: targetSocPercent,
        batteryCapacityKwh: vehicle.batteryCapacityKwh,
        maxVehicleChargePowerKw: vehicle.maxChargePowerKw,
        chargerPowerKw: selectedStation.chargerPowerKw,
        pricePerKwh: selectedStation.pricePerKwh,
      );

      // Calculate times
      final driveTimeToStopMin =
          (legDistanceKm / TripCalculationConstants.averageSpeedKmh * 60).ceil();
      final arrivalTime = currentTime.add(Duration(minutes: driveTimeToStopMin));
      final departureTimeFromStop =
          arrivalTime.add(Duration(minutes: chargingResult.chargingTimeMinutes));

      // Create charging stop
      final stop = ChargingStopModel(
        id: 'stop_$stopNumber',
        stationId: selectedStation.stationId,
        stationName: selectedStation.stationName,
        location: selectedStation.location,
        distanceFromStartKm: selectedStation.distanceFromStartKm,
        distanceFromPreviousKm: legDistanceKm,
        arrivalSocPercent: arrivalSocPercent,
        departureSocPercent: targetSocPercent,
        energyToChargeKwh: chargingResult.energyToChargeKwh,
        estimatedChargeTimeMin: chargingResult.chargingTimeMinutes,
        estimatedCost: chargingResult.estimatedCost,
        chargerPowerKw: chargingResult.effectiveChargePowerKw,
        pricePerKwh: selectedStation.pricePerKwh,
        network: selectedStation.network,
        amenities: selectedStation.amenities,
        arrivalTime: arrivalTime,
        departureTime: departureTimeFromStop,
        stopNumber: stopNumber,
      );

      stops.add(stop);

      // Update current state
      currentSocPercent = targetSocPercent;
      currentDistanceKm = selectedStation.distanceFromStartKm;
      currentTime = departureTimeFromStop;

      // Remove used station from list
      sortedStations.remove(selectedStation);
    }

    return stops;
  }

  // ============================================================
  // TRIP ESTIMATES CALCULATION
  // ============================================================

  /// Calculate complete trip estimates.
  ///
  /// This is the main calculation function that orchestrates all
  /// sub-calculations to produce a complete trip estimate.
  ///
  /// [totalDistanceKm] - Total trip distance.
  /// [routeDurationSeconds] - Route duration from provider.
  /// [vehicle] - Vehicle profile.
  /// [chargingStops] - Planned charging stops.
  /// [departureTime] - Planned departure time.
  /// [tollsCost] - Optional toll costs.
  /// Returns complete trip estimates.
  static TripEstimates calculateTripEstimates({
    required double totalDistanceKm,
    required int routeDurationSeconds,
    required VehicleProfileModel vehicle,
    required List<ChargingStopModel> chargingStops,
    DateTime? departureTime,
    double tollsCost = 0,
  }) {
    // Step 1: Calculate total energy consumption
    final energyResult = calculateEnergyConsumption(
      distanceKm: totalDistanceKm,
      consumptionWhPerKm: vehicle.consumptionWhPerKm,
      batteryCapacityKwh: vehicle.batteryCapacityKwh,
    );

    // Step 2: Calculate drive time
    final driveTimeMin = calculateDriveTimeMinutes(routeDurationSeconds);

    // Step 3: Calculate total charging time and cost
    var totalChargingTimeMin = 0;
    var totalChargingCost = 0.0;
    final socAtArrivalList = <double>[];
    final socAtDepartureList = <double>[];
    final distancePerLeg = <double>[];

    for (final stop in chargingStops) {
      totalChargingTimeMin += stop.estimatedChargeTimeMin;
      totalChargingCost += stop.estimatedCost;
      socAtArrivalList.add(stop.arrivalSocPercent);
      socAtDepartureList.add(stop.departureSocPercent);
      distancePerLeg.add(stop.distanceFromPreviousKm);
    }

    // Add final leg distance
    if (chargingStops.isNotEmpty) {
      final lastStop = chargingStops.last;
      distancePerLeg.add(totalDistanceKm - lastStop.distanceFromStartKm);
    } else {
      distancePerLeg.add(totalDistanceKm);
    }

    // Step 4: Calculate arrival SOC
    final lastStopSoc =
        chargingStops.isNotEmpty ? chargingStops.last.departureSocPercent : vehicle.currentSocPercent;
    final lastLegDistance = distancePerLeg.last;
    final lastLegEnergy = calculateEnergyConsumption(
      distanceKm: lastLegDistance,
      consumptionWhPerKm: vehicle.consumptionWhPerKm,
      batteryCapacityKwh: vehicle.batteryCapacityKwh,
    );
    final arrivalSocPercent =
        (lastStopSoc - lastLegEnergy.socUsedPercent).clamp(0.0, 100.0);

    // Step 5: Calculate ETA
    final totalTripTimeMin = driveTimeMin +
        totalChargingTimeMin +
        TripCalculationConstants.trafficBufferMinutes;
    final eta = departureTime?.add(Duration(minutes: totalTripTimeMin));

    // Step 6: Calculate total cost
    final totalCost = totalChargingCost + tollsCost;

    return TripEstimates(
      totalDistanceKm: totalDistanceKm,
      totalDriveTimeMin: driveTimeMin,
      totalChargingTimeMin: totalChargingTimeMin,
      estimatedEnergyKwh: energyResult.energyKwh,
      estimatedCost: totalCost,
      arrivalSocPercent: arrivalSocPercent,
      requiredStops: chargingStops.length,
      eta: eta,
      tollsCost: tollsCost,
      socAtEachStopArrival: socAtArrivalList,
      socAtEachStopDeparture: socAtDepartureList,
      distancePerLeg: distancePerLeg,
    );
  }

  // ============================================================
  // GRAPH DATA GENERATION
  // ============================================================

  /// Generate battery graph data points for visualization.
  ///
  /// Creates data points showing SOC vs distance, including
  /// charging jumps at each stop.
  ///
  /// [vehicle] - Vehicle profile.
  /// [totalDistanceKm] - Total trip distance.
  /// [chargingStops] - Planned charging stops.
  /// [sampleIntervalKm] - Distance between sample points.
  /// Returns list of battery data points.
  static List<BatteryDataPoint> generateBatteryGraphData({
    required VehicleProfileModel vehicle,
    required double totalDistanceKm,
    required List<ChargingStopModel> chargingStops,
    double sampleIntervalKm = 20.0,
  }) {
    final dataPoints = <BatteryDataPoint>[];
    var currentSocPercent = vehicle.currentSocPercent;
    var currentDistanceKm = 0.0;
    var stopIndex = 0;

    // Add starting point
    dataPoints.add(BatteryDataPoint(
      distanceKm: 0,
      socPercent: currentSocPercent,
      label: 'Start',
    ));

    while (currentDistanceKm < totalDistanceKm) {
      // Check if there's a charging stop before the next sample point
      if (stopIndex < chargingStops.length) {
        final nextStop = chargingStops[stopIndex];
        final nextSampleKm = currentDistanceKm + sampleIntervalKm;

        if (nextStop.distanceFromStartKm <= nextSampleKm) {
          // Add point at stop arrival
          final energyToStop = calculateEnergyConsumption(
            distanceKm: nextStop.distanceFromStartKm - currentDistanceKm,
            consumptionWhPerKm: vehicle.consumptionWhPerKm,
            batteryCapacityKwh: vehicle.batteryCapacityKwh,
          );
          currentSocPercent -= energyToStop.socUsedPercent;
          currentDistanceKm = nextStop.distanceFromStartKm;

          // Add arrival point
          dataPoints.add(BatteryDataPoint(
            distanceKm: currentDistanceKm,
            socPercent: currentSocPercent.clamp(0.0, 100.0),
            isChargingStop: true,
            label: 'Stop ${stopIndex + 1} (Arrive)',
          ));

          // Add departure point (after charging)
          currentSocPercent = nextStop.departureSocPercent;
          dataPoints.add(BatteryDataPoint(
            distanceKm: currentDistanceKm,
            socPercent: currentSocPercent,
            isChargingStop: true,
            label: 'Stop ${stopIndex + 1} (Depart)',
          ));

          stopIndex++;
          continue;
        }
      }

      // Regular sample point
      final nextDistanceKm = (currentDistanceKm + sampleIntervalKm)
          .clamp(0.0, totalDistanceKm);
      final segmentDistance = nextDistanceKm - currentDistanceKm;

      if (segmentDistance > 0) {
        final energyUsed = calculateEnergyConsumption(
          distanceKm: segmentDistance,
          consumptionWhPerKm: vehicle.consumptionWhPerKm,
          batteryCapacityKwh: vehicle.batteryCapacityKwh,
        );
        currentSocPercent -= energyUsed.socUsedPercent;
        currentDistanceKm = nextDistanceKm;

        dataPoints.add(BatteryDataPoint(
          distanceKm: currentDistanceKm,
          socPercent: currentSocPercent.clamp(0.0, 100.0),
        ));
      } else {
        break;
      }
    }

    // Add destination point if not already there
    if (dataPoints.last.distanceKm < totalDistanceKm) {
      final remainingDistance = totalDistanceKm - dataPoints.last.distanceKm;
      final energyUsed = calculateEnergyConsumption(
        distanceKm: remainingDistance,
        consumptionWhPerKm: vehicle.consumptionWhPerKm,
        batteryCapacityKwh: vehicle.batteryCapacityKwh,
      );
      currentSocPercent -= energyUsed.socUsedPercent;

      dataPoints.add(BatteryDataPoint(
        distanceKm: totalDistanceKm,
        socPercent: currentSocPercent.clamp(0.0, 100.0),
        label: 'Destination',
      ));
    }

    return dataPoints;
  }

  /// Generate cost breakdown for pie chart.
  ///
  /// [chargingStops] - Planned charging stops.
  /// [tollsCost] - Optional toll costs.
  /// Returns list of cost breakdown items.
  static List<CostBreakdownItem> generateCostBreakdown({
    required List<ChargingStopModel> chargingStops,
    double tollsCost = 0,
  }) {
    final breakdown = <CostBreakdownItem>[];

    // Group charging costs by network
    final networkCosts = <String, double>{};
    for (final stop in chargingStops) {
      final network = stop.network ?? 'Other';
      networkCosts[network] = (networkCosts[network] ?? 0) + stop.estimatedCost;
    }

    // Add charging costs
    final colors = ['#00C853', '#2196F3', '#7C4DFF', '#FF9800', '#E91E63'];
    var colorIndex = 0;
    for (final entry in networkCosts.entries) {
      breakdown.add(CostBreakdownItem(
        label: entry.key,
        amount: entry.value,
        colorHex: colors[colorIndex % colors.length],
      ));
      colorIndex++;
    }

    // Add tolls if any
    if (tollsCost > 0) {
      breakdown.add(CostBreakdownItem(
        label: 'Tolls',
        amount: tollsCost,
        colorHex: '#9E9E9E',
      ));
    }

    return breakdown;
  }
}

/// Helper class for charging station info during planning.
class ChargingStationInfo {
  const ChargingStationInfo({
    required this.stationId,
    required this.stationName,
    required this.location,
    required this.distanceFromStartKm,
    required this.chargerPowerKw,
    this.pricePerKwh = 0.30,
    this.network,
    this.amenities = const [],
    this.isAvailable = true,
  });

  final String stationId;
  final String stationName;
  final LocationModel location;
  final double distanceFromStartKm;
  final double chargerPowerKw;
  final double pricePerKwh;
  final String? network;
  final List<String> amenities;
  final bool isAvailable;
}

