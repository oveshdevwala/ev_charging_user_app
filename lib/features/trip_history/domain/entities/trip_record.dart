import 'package:equatable/equatable.dart';

class TripRecord extends Equatable {
  final String id;
  final String stationName;
  final DateTime startTime;
  final DateTime endTime;
  final double energyConsumedKWh;
  final double cost;
  final String vehicle;
  final double efficiencyScore;

  const TripRecord({
    required this.id,
    required this.stationName,
    required this.startTime,
    required this.endTime,
    required this.energyConsumedKWh,
    required this.cost,
    required this.vehicle,
    required this.efficiencyScore,
  });

  @override
  List<Object?> get props => [
    id,
    stationName,
    startTime,
    endTime,
    energyConsumedKWh,
    cost,
    vehicle,
    efficiencyScore,
  ];
}
