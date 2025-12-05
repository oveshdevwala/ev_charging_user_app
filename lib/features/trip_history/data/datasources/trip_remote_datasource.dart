import '../models/monthly_analytics_model.dart';
import '../models/trip_record_model.dart';

abstract class TripRemoteDataSource {
  Future<List<TripRecordModel>> getTripHistory();
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month);
  Future<List<int>> exportTripReport(String month); // Returns bytes for PDF
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  // In a real app, inject Dio or Http client here
  // final Dio client;

  TripRemoteDataSourceImpl();

  @override
  Future<List<TripRecordModel>> getTripHistory() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock Response
    return List.generate(10, (index) {
      return TripRecordModel(
        id: 'trip_$index',
        stationName: 'Station $index',
        startTime: DateTime.now().subtract(Duration(days: index, hours: 2)),
        endTime: DateTime.now().subtract(Duration(days: index)),
        energyConsumedKWh: 15.5 + index,
        cost: 250.0 + (index * 10),
        vehicle: 'Tesla Model 3',
        efficiencyScore: 4.5,
      );
    });
  }

  @override
  Future<MonthlyAnalyticsModel> getMonthlyAnalytics(String month) async {
    await Future.delayed(const Duration(seconds: 1));

    return MonthlyAnalyticsModel(
      month: month,
      totalCost: 1500,
      totalEnergy: 300.5,
      avgEfficiency: 4.2,
      comparisonPercentage: 12.5,
      trendData: List.generate(30, (index) {
        return DailyBreakdownModel(
          date: DateTime.now().subtract(Duration(days: index)),
          cost: 50.0 + (index % 5) * 10,
          energy: 10.0 + (index % 5),
        );
      }),
    );
  }

  @override
  Future<List<int>> exportTripReport(String month) async {
    await Future.delayed(const Duration(seconds: 2));
    // Return dummy bytes
    return [0, 1, 2, 3];
  }
}
