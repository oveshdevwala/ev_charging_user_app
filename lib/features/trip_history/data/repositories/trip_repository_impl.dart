import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/monthly_analytics.dart';
import '../../domain/entities/trip_record.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_local_datasource.dart';
import '../datasources/trip_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final TripRemoteDataSource remoteDataSource;
  final TripLocalDataSource localDataSource;

  @override
  Future<List<TripRecord>> getTripHistory() async {
    try {
      final remoteTrips = await remoteDataSource.getTripHistory();
      await localDataSource.cacheTripHistory(remoteTrips);
      return remoteTrips.map((e) => e.toEntity()).toList();
    } catch (e) {
      // Fallback to local
      try {
        final localTrips = await localDataSource.getLastTripHistory();
        return localTrips.map((e) => e.toEntity()).toList();
      } catch (localError) {
        throw Exception('Failed to fetch trip history');
      }
    }
  }

  @override
  Future<MonthlyAnalytics> getMonthlyAnalytics(String month) async {
    try {
      final remoteAnalytics = await remoteDataSource.getMonthlyAnalytics(month);
      await localDataSource.cacheMonthlyAnalytics(remoteAnalytics);
      return remoteAnalytics.toEntity();
    } catch (e) {
      final localAnalytics = await localDataSource.getLastMonthlyAnalytics(
        month,
      );
      if (localAnalytics != null) {
        return localAnalytics.toEntity();
      }
      throw Exception('Failed to fetch analytics');
    }
  }

  @override
  Future<File> exportTripReport(String month) async {
    final bytes = await remoteDataSource.exportTripReport(month);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/trip_report_$month.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
