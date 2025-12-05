import 'dart:io';
import '../repositories/trip_repository.dart';

class ExportTripReport {
  ExportTripReport(this.repository);
  final TripRepository repository;

  Future<File> call(String month) {
    return repository.exportTripReport(month);
  }
}
