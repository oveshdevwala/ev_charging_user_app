import '../entities/monthly_analytics.dart';
import '../repositories/trip_repository.dart';

class GetMonthlyAnalytics {
  GetMonthlyAnalytics(this.repository);
  final TripRepository repository;

  Future<MonthlyAnalytics> call(String month) {
    return repository.getMonthlyAnalytics(month);
  }
}
