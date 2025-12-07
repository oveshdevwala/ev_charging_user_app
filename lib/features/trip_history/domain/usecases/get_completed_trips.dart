/// File: lib/features/trip_history/domain/usecases/get_completed_trips.dart
/// Purpose: Use case for fetching all completed trips
/// Belongs To: trip_history feature
library;

import '../entities/completed_trip.dart';
import '../repositories/trip_repository.dart';

/// Use case for getting all completed trips.
class GetCompletedTrips {
  const GetCompletedTrips(this.repository);

  final TripRepository repository;

  Future<List<CompletedTrip>> call() async {
    return await repository.getAllTrips();
  }
}
