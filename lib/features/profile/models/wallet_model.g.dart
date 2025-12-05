// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactionModel _$WalletTransactionModelFromJson(
  Map<String, dynamic> json,
) => WalletTransactionModel(
  id: json['id'] as String,
  type: WalletTransactionModel._typeFromJson(json['type'] as String),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  createdAt: WalletTransactionModel._dateTimeFromJson(json['createdAt']),
  referenceId: json['referenceId'] as String?,
);

Map<String, dynamic> _$WalletTransactionModelToJson(
  WalletTransactionModel instance,
) => <String, dynamic>{
  'type': WalletTransactionModel._typeToJson(instance.type),
  'id': instance.id,
  'amount': instance.amount,
  'description': instance.description,
  'createdAt': WalletTransactionModel._dateTimeToJson(instance.createdAt),
  'referenceId': instance.referenceId,
};

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  balance: (json['balance'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'USD',
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'currency': instance.currency,
      'transactions': instance.transactions,
    };
