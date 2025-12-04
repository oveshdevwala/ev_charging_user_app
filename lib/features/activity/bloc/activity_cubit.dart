/// File: lib/features/activity/bloc/activity_cubit.dart
/// Purpose: Activity page Cubit for managing activity data and graphs
/// Belongs To: activity feature
/// Customization Guide:
///    - Add new methods for additional data fetching
///    - All async operations should handle errors properly
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/activity_repository.dart';
import 'activity_state.dart';

/// Activity page Cubit managing all activity data.
class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository,
      super(ActivityState.initial());

  final ActivityRepository _activityRepository;

  /// Load all activity data.
  Future<void> loadActivityData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final summaryFuture = _activityRepository.fetchActivitySummary();
      final sessionsFuture = _activityRepository.fetchChargingSessions(
        limit: 10,
      );
      final transactionsFuture = _activityRepository.fetchTransactions(
        limit: 15,
      );
      final weeklyFuture = _activityRepository.fetchWeeklyData();
      final monthlyFuture = _activityRepository.fetchMonthlyData();
      final yearlyFuture = _activityRepository.fetchYearlyData();
      final insightsFuture = _activityRepository.fetchInsights();

      final summary = await summaryFuture;
      final sessions = await sessionsFuture;
      final transactions = await transactionsFuture;
      final weekly = await weeklyFuture;
      final monthly = await monthlyFuture;
      final yearly = await yearlyFuture;
      final insights = await insightsFuture;

      emit(
        state.copyWith(
          isLoading: false,
          summary: summary,
          sessions: sessions,
          transactions: transactions,
          weeklyData: weekly,
          monthlyData: monthly,
          yearlyData: yearly,
          insights: insights,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Refresh activity data.
  Future<void> refreshActivityData() async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final summaryFuture = _activityRepository.fetchActivitySummary();
      final sessionsFuture = _activityRepository.fetchChargingSessions(
        limit: 10,
      );
      final transactionsFuture = _activityRepository.fetchTransactions(
        limit: 15,
      );
      final weeklyFuture = _activityRepository.fetchWeeklyData();
      final monthlyFuture = _activityRepository.fetchMonthlyData();
      final yearlyFuture = _activityRepository.fetchYearlyData();
      final insightsFuture = _activityRepository.fetchInsights();

      final summary = await summaryFuture;
      final sessions = await sessionsFuture;
      final transactions = await transactionsFuture;
      final weekly = await weeklyFuture;
      final monthly = await monthlyFuture;
      final yearly = await yearlyFuture;
      final insights = await insightsFuture;

      emit(
        state.copyWith(
          isRefreshing: false,
          summary: summary,
          sessions: sessions,
          transactions: transactions,
          weeklyData: weekly,
          monthlyData: monthly,
          yearlyData: yearly,
          insights: insights,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, error: e.toString()));
    }
  }

  /// Load more sessions.
  Future<void> loadMoreSessions() async {
    try {
      final newSessions = await _activityRepository.fetchChargingSessions(
        limit: 10,
        offset: state.sessions.length,
      );

      emit(state.copyWith(sessions: [...state.sessions, ...newSessions]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Load more transactions.
  Future<void> loadMoreTransactions() async {
    try {
      final newTransactions = await _activityRepository.fetchTransactions(
        limit: 15,
        offset: state.transactions.length,
      );

      emit(
        state.copyWith(
          transactions: [...state.transactions, ...newTransactions],
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Change time range filter.
  void setTimeRange(ActivityTimeRange range) {
    emit(state.copyWith(selectedTimeRange: range));
  }

  /// Change selected tab.
  void setTab(ActivityTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  /// Clear error.
  void clearError() {
    emit(state.copyWith());
  }
}
