/// File: lib/features/trip_history/data/models/monthly_analytics_model.dart
/// Purpose: Data model for monthly analytics with JSON serialization
/// Belongs To: trip_history feature
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/monthly_analytics.dart';

part 'monthly_analytics_model.g.dart';

@JsonSerializable()
class MonthlyAnalyticsModel extends Equatable {
  const MonthlyAnalyticsModel({
    required this.month,
    required this.totalCost,
    required this.totalEnergy,
    required this.avgEfficiency,
    required this.comparisonPercentage,
    required this.trendData,
  });

  factory MonthlyAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyAnalyticsModelFromJson(json);
  final String month;
  final double totalCost;
  final double totalEnergy;
  final double avgEfficiency;
  final double comparisonPercentage;
  final List<DailyBreakdownModel> trendData;

  Map<String, dynamic> toJson() => _$MonthlyAnalyticsModelToJson(this);

  MonthlyAnalytics toEntity() {
    return MonthlyAnalytics(
      month: month,
      totalCost: totalCost,
      totalEnergy: totalEnergy,
      avgEfficiency: avgEfficiency,
      comparisonPercentage: comparisonPercentage,
      trendData: trendData.map((e) => e.toEntity()).toList(),
    );
  }

  MonthlyAnalyticsModel copyWith({
    String? month,
    double? totalCost,
    double? totalEnergy,
    double? avgEfficiency,
    double? comparisonPercentage,
    List<DailyBreakdownModel>? trendData,
  }) {
    return MonthlyAnalyticsModel(
      month: month ?? this.month,
      totalCost: totalCost ?? this.totalCost,
      totalEnergy: totalEnergy ?? this.totalEnergy,
      avgEfficiency: avgEfficiency ?? this.avgEfficiency,
      comparisonPercentage: comparisonPercentage ?? this.comparisonPercentage,
      trendData: trendData ?? this.trendData,
    );
  }

  @override
  List<Object?> get props => [
    month,
    totalCost,
    totalEnergy,
    avgEfficiency,
    comparisonPercentage,
    trendData,
  ];
}

@JsonSerializable()
class DailyBreakdownModel extends Equatable {
  const DailyBreakdownModel({
    required this.date,
    required this.cost,
    required this.energy,
  });

  factory DailyBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$DailyBreakdownModelFromJson(json);
  final DateTime date;
  final double cost;
  final double energy;

  Map<String, dynamic> toJson() => _$DailyBreakdownModelToJson(this);

  DailyBreakdown toEntity() {
    return DailyBreakdown(date: date, cost: cost, energy: energy);
  }

  DailyBreakdownModel copyWith({DateTime? date, double? cost, double? energy}) {
    return DailyBreakdownModel(
      date: date ?? this.date,
      cost: cost ?? this.cost,
      energy: energy ?? this.energy,
    );
  }

  @override
  List<Object?> get props => [date, cost, energy];
}
