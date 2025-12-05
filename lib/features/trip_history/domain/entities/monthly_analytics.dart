import 'package:equatable/equatable.dart';

class MonthlyAnalytics extends Equatable {
  final String month; // YYYY-MM
  final double totalCost;
  final double totalEnergy;
  final double avgEfficiency;
  final double comparisonPercentage;
  final List<DailyBreakdown> trendData;

  const MonthlyAnalytics({
    required this.month,
    required this.totalCost,
    required this.totalEnergy,
    required this.avgEfficiency,
    required this.comparisonPercentage,
    required this.trendData,
  });

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

class DailyBreakdown extends Equatable {
  final DateTime date;
  final double cost;
  final double energy;

  const DailyBreakdown({
    required this.date,
    required this.cost,
    required this.energy,
  });

  @override
  List<Object?> get props => [date, cost, energy];
}
