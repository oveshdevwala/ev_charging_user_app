import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/monthly_analytics_model.dart';
import '../models/trip_record_model.dart';

abstract class TripLocalDataSource {
  Future<void> cacheTripHistory(List<TripRecordModel> trips);
  Future<List<TripRecordModel>> getLastTripHistory();

  Future<void> cacheMonthlyAnalytics(MonthlyAnalyticsModel analytics);
  Future<MonthlyAnalyticsModel?> getLastMonthlyAnalytics(String month);
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  TripLocalDataSourceImpl(this.box);
  final Box<String> box;

  static const String _tripHistoryKey = 'trip_history';
  static const String _analyticsKeyPrefix = 'analytics_';

  @override
  Future<void> cacheTripHistory(List<TripRecordModel> trips) async {
    final jsonList = trips.map((e) => e.toJson()).toList();
    await box.put(_tripHistoryKey, jsonEncode(jsonList));
  }

  @override
  Future<List<TripRecordModel>> getLastTripHistory() async {
    final jsonString = box.get(_tripHistoryKey);
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => TripRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('No cached data');
  }

  @override
  Future<void> cacheMonthlyAnalytics(MonthlyAnalyticsModel analytics) async {
    await box.put(
      _analyticsKeyPrefix + analytics.month,
      jsonEncode(analytics.toJson()),
    );
  }

  @override
  Future<MonthlyAnalyticsModel?> getLastMonthlyAnalytics(String month) async {
    final jsonString = box.get(_analyticsKeyPrefix + month);
    if (jsonString != null) {
      return MonthlyAnalyticsModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    }
    return null;
  }
}
