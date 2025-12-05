// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expMonth: (json['expMonth'] as num).toInt(),
      expYear: (json['expYear'] as num).toInt(),
      isDefault: json['isDefault'] as bool? ?? false,
      gatewayToken: json['gatewayToken'] as String?,
      type: json['type'] == null
          ? PaymentMethodType.card
          : PaymentMethodModel._typeFromJson(json['type'] as String),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'last4': instance.last4,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'isDefault': instance.isDefault,
      'gatewayToken': instance.gatewayToken,
      'type': PaymentMethodModel._typeToJson(instance.type),
    };
