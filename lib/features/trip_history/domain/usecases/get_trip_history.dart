import '../entities/trip_record.dart';
import '../repositories/trip_repository.dart';

class GetTripHistory {
  GetTripHistory(this.repository);
  final TripRepository repository;

  Future<List<TripRecord>> call() {
    return repository.getTripHistory();
  }
}
