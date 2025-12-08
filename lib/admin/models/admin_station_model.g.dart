// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCharger _$AdminChargerFromJson(Map<String, dynamic> json) => AdminCharger(
  id: json['id'] as String,
  type: $enumDecode(_$AdminChargerTypeEnumMap, json['type']),
  powerKw: (json['powerKw'] as num).toDouble(),
  status: json['status'] as String,
  connectorId: json['connectorId'] as String?,
  pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AdminChargerToJson(AdminCharger instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AdminChargerTypeEnumMap[instance.type]!,
      'powerKw': instance.powerKw,
      'status': instance.status,
      'connectorId': instance.connectorId,
      'pricePerKwh': instance.pricePerKwh,
    };

const _$AdminChargerTypeEnumMap = {
  AdminChargerType.ccs: 'ccs',
  AdminChargerType.chademo: 'chademo',
  AdminChargerType.type2: 'type2',
  AdminChargerType.tesla: 'tesla',
  AdminChargerType.j1772: 'j1772',
};

AdminStation _$AdminStationFromJson(Map<String, dynamic> json) => AdminStation(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  status: $enumDecode(_$AdminStationStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  imageUrl: json['imageUrl'] as String?,
  chargers:
      (json['chargers'] as List<dynamic>?)
          ?.map((e) => AdminCharger.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  operatingHours: json['operatingHours'] as String?,
  managerId: json['managerId'] as String?,
  managerName: json['managerName'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  totalReviews: (json['totalReviews'] as num?)?.toInt(),
  totalSessions: (json['totalSessions'] as num?)?.toInt(),
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AdminStationToJson(AdminStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': _$AdminStationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'phone': instance.phone,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'chargers': instance.chargers,
      'amenities': instance.amenities,
      'operatingHours': instance.operatingHours,
      'managerId': instance.managerId,
      'managerName': instance.managerName,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'totalSessions': instance.totalSessions,
      'totalRevenue': instance.totalRevenue,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AdminStationStatusEnumMap = {
  AdminStationStatus.active: 'active',
  AdminStationStatus.inactive: 'inactive',
  AdminStationStatus.maintenance: 'maintenance',
  AdminStationStatus.pending: 'pending',
};
