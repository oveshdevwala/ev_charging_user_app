// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  nickName: json['nickName'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  batteryCapacityKWh: (json['batteryCapacityKWh'] as num).toDouble(),
  vehicleType: json['vehicleType'] as String,
  licensePlate: json['licensePlate'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  imageUrl: json['imageUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nickName': instance.nickName,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'batteryCapacityKWh': instance.batteryCapacityKWh,
      'vehicleType': instance.vehicleType,
      'licensePlate': instance.licensePlate,
      'isDefault': instance.isDefault,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
