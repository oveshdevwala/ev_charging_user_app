/// File: lib/features/trip_history/data/models/trip_record_model.dart
/// Purpose: Data model for trip records with JSON serialization
/// Belongs To: trip_history feature
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/trip_record.dart';

part 'trip_record_model.g.dart';

@JsonSerializable()
class TripRecordModel extends Equatable {
  const TripRecordModel({
    required this.id,
    required this.stationName,
    required this.startTime,
    required this.endTime,
    required this.energyConsumedKWh,
    required this.cost,
    required this.vehicle,
    required this.efficiencyScore,
  });

  factory TripRecordModel.fromJson(Map<String, dynamic> json) =>
      _$TripRecordModelFromJson(json);

  factory TripRecordModel.fromEntity(TripRecord entity) {
    return TripRecordModel(
      id: entity.id,
      stationName: entity.stationName,
      startTime: entity.startTime,
      endTime: entity.endTime,
      energyConsumedKWh: entity.energyConsumedKWh,
      cost: entity.cost,
      vehicle: entity.vehicle,
      efficiencyScore: entity.efficiencyScore,
    );
  }
  final String id;
  final String stationName;
  final DateTime startTime;
  final DateTime endTime;
  final double energyConsumedKWh;
  final double cost;
  final String vehicle;
  final double efficiencyScore;

  Map<String, dynamic> toJson() => _$TripRecordModelToJson(this);

  TripRecord toEntity() {
    return TripRecord(
      id: id,
      stationName: stationName,
      startTime: startTime,
      endTime: endTime,
      energyConsumedKWh: energyConsumedKWh,
      cost: cost,
      vehicle: vehicle,
      efficiencyScore: efficiencyScore,
    );
  }

  TripRecordModel copyWith({
    String? id,
    String? stationName,
    DateTime? startTime,
    DateTime? endTime,
    double? energyConsumedKWh,
    double? cost,
    String? vehicle,
    double? efficiencyScore,
  }) {
    return TripRecordModel(
      id: id ?? this.id,
      stationName: stationName ?? this.stationName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      energyConsumedKWh: energyConsumedKWh ?? this.energyConsumedKWh,
      cost: cost ?? this.cost,
      vehicle: vehicle ?? this.vehicle,
      efficiencyScore: efficiencyScore ?? this.efficiencyScore,
    );
  }

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
