import 'dart:io';
import '../entities/monthly_analytics.dart';
import '../entities/trip_record.dart';

abstract class TripRepository {
  Future<List<TripRecord>> getTripHistory();
  Future<MonthlyAnalytics> getMonthlyAnalytics(String month);
  Future<File> exportTripReport(String month);
}
