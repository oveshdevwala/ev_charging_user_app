// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOffer _$AdminOfferFromJson(Map<String, dynamic> json) => AdminOffer(
  id: json['id'] as String,
  title: json['title'] as String,
  discountType: $enumDecode(_$AdminDiscountTypeEnumMap, json['discountType']),
  discountValue: (json['discountValue'] as num).toDouble(),
  status: $enumDecode(_$AdminOfferStatusEnumMap, json['status']),
  validFrom: DateTime.parse(json['validFrom'] as String),
  validUntil: DateTime.parse(json['validUntil'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
  code: json['code'] as String?,
  imageUrl: json['imageUrl'] as String?,
  maxUses: (json['maxUses'] as num?)?.toInt(),
  currentUses: (json['currentUses'] as num?)?.toInt() ?? 0,
  minPurchaseAmount: (json['minPurchaseAmount'] as num?)?.toDouble(),
  applicableStations:
      (json['applicableStations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  termsAndConditions: json['termsAndConditions'] as String?,
);

Map<String, dynamic> _$AdminOfferToJson(AdminOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'discountType': _$AdminDiscountTypeEnumMap[instance.discountType]!,
      'discountValue': instance.discountValue,
      'status': _$AdminOfferStatusEnumMap[instance.status]!,
      'validFrom': instance.validFrom.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'code': instance.code,
      'imageUrl': instance.imageUrl,
      'maxUses': instance.maxUses,
      'currentUses': instance.currentUses,
      'minPurchaseAmount': instance.minPurchaseAmount,
      'applicableStations': instance.applicableStations,
      'termsAndConditions': instance.termsAndConditions,
    };

const _$AdminDiscountTypeEnumMap = {
  AdminDiscountType.percentage: 'percentage',
  AdminDiscountType.fixed: 'fixed',
  AdminDiscountType.freeEnergy: 'freeEnergy',
};

const _$AdminOfferStatusEnumMap = {
  AdminOfferStatus.active: 'active',
  AdminOfferStatus.inactive: 'inactive',
  AdminOfferStatus.scheduled: 'scheduled',
  AdminOfferStatus.expired: 'expired',
};
