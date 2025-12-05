// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripRecordModel _$TripRecordModelFromJson(Map<String, dynamic> json) =>
    TripRecordModel(
      id: json['id'] as String,
      stationName: json['stationName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      energyConsumedKWh: (json['energyConsumedKWh'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      vehicle: json['vehicle'] as String,
      efficiencyScore: (json['efficiencyScore'] as num).toDouble(),
    );

Map<String, dynamic> _$TripRecordModelToJson(TripRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stationName': instance.stationName,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'energyConsumedKWh': instance.energyConsumedKWh,
      'cost': instance.cost,
      'vehicle': instance.vehicle,
      'efficiencyScore': instance.efficiencyScore,
    };
