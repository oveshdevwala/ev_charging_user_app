// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminTransaction _$AdminTransactionFromJson(Map<String, dynamic> json) =>
    AdminTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$AdminTransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecode(_$AdminTransactionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userName: json['userName'] as String?,
      description: json['description'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      sessionId: json['sessionId'] as String?,
      referenceId: json['referenceId'] as String?,
    );

Map<String, dynamic> _$AdminTransactionToJson(AdminTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$AdminTransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'status': _$AdminTransactionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'userName': instance.userName,
      'description': instance.description,
      'paymentMethod': instance.paymentMethod,
      'sessionId': instance.sessionId,
      'referenceId': instance.referenceId,
    };

const _$AdminTransactionTypeEnumMap = {
  AdminTransactionType.charge: 'charge',
  AdminTransactionType.recharge: 'recharge',
  AdminTransactionType.refund: 'refund',
  AdminTransactionType.withdrawal: 'withdrawal',
  AdminTransactionType.adjustment: 'adjustment',
};

const _$AdminTransactionStatusEnumMap = {
  AdminTransactionStatus.pending: 'pending',
  AdminTransactionStatus.completed: 'completed',
  AdminTransactionStatus.failed: 'failed',
  AdminTransactionStatus.refunded: 'refunded',
};
