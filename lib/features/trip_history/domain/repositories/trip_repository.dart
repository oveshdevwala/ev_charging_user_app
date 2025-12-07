import 'dart:io';
import '../entities/completed_trip.dart';
import '../entities/monthly_analytics.dart';
import '../entities/trip_record.dart';

abstract class TripRepository {
  Future<List<TripRecord>> getTripHistory();
  Future<MonthlyAnalytics> getMonthlyAnalytics(String month);
  Future<File> exportTripReport(String month);

  /// Get all completed trips for trip history screen.
  Future<List<CompletedTrip>> getAllTrips();

  /// Get a single completed trip by ID.
  Future<CompletedTrip?> getTripById(String tripId);
}
