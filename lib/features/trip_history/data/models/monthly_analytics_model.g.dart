// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyAnalyticsModel _$MonthlyAnalyticsModelFromJson(
  Map<String, dynamic> json,
) => MonthlyAnalyticsModel(
  month: json['month'] as String,
  totalCost: (json['totalCost'] as num).toDouble(),
  totalEnergy: (json['totalEnergy'] as num).toDouble(),
  avgEfficiency: (json['avgEfficiency'] as num).toDouble(),
  comparisonPercentage: (json['comparisonPercentage'] as num).toDouble(),
  trendData: (json['trendData'] as List<dynamic>)
      .map((e) => DailyBreakdownModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MonthlyAnalyticsModelToJson(
  MonthlyAnalyticsModel instance,
) => <String, dynamic>{
  'month': instance.month,
  'totalCost': instance.totalCost,
  'totalEnergy': instance.totalEnergy,
  'avgEfficiency': instance.avgEfficiency,
  'comparisonPercentage': instance.comparisonPercentage,
  'trendData': instance.trendData,
};

DailyBreakdownModel _$DailyBreakdownModelFromJson(Map<String, dynamic> json) =>
    DailyBreakdownModel(
      date: DateTime.parse(json['date'] as String),
      cost: (json['cost'] as num).toDouble(),
      energy: (json['energy'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyBreakdownModelToJson(
  DailyBreakdownModel instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'cost': instance.cost,
  'energy': instance.energy,
};
