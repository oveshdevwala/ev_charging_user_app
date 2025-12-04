/// File: lib/features/activity/bloc/activity_state.dart
/// Purpose: Activity page state for BLoC with graph data
/// Belongs To: activity feature
/// Customization Guide:
///    - Add new fields for additional analytics
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../../../models/charging_session_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/user_activity_model.dart';
import '../../../repositories/activity_repository.dart';

/// Time range for data filtering.
enum ActivityTimeRange { week, month, year }

/// Tab selection for activity details.
enum ActivityTab { overview, sessions, transactions }

/// Activity page state.
class ActivityState extends Equatable {
  const ActivityState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.summary,
    this.sessions = const [],
    this.transactions = const [],
    this.weeklyData = const [],
    this.monthlyData = const [],
    this.yearlyData = const [],
    this.insights,
    this.selectedTimeRange = ActivityTimeRange.week,
    this.selectedTab = ActivityTab.overview,
    this.error,
  });

  /// Initial state.
  factory ActivityState.initial() => const ActivityState(isLoading: true);

  /// Loading state.
  final bool isLoading;

  /// Refreshing state.
  final bool isRefreshing;

  /// User activity summary.
  final UserActivitySummary? summary;

  /// Charging sessions list.
  final List<ChargingSessionModel> sessions;

  /// Transactions list.
  final List<TransactionModel> transactions;

  /// Weekly charging data.
  final List<DailyChargingSummary> weeklyData;

  /// Monthly charging data.
  final List<DailyChargingSummary> monthlyData;

  /// Yearly charging data.
  final List<MonthlyChargingSummary> yearlyData;

  /// Activity insights.
  final ActivityInsights? insights;

  /// Selected time range filter.
  final ActivityTimeRange selectedTimeRange;

  /// Selected tab.
  final ActivityTab selectedTab;

  /// Error message.
  final String? error;

  /// Check if data is loaded.
  bool get hasData => summary != null;

  /// Check if there's an error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Get current graph data based on time range.
  List<DailyChargingSummary> get currentGraphData {
    switch (selectedTimeRange) {
      case ActivityTimeRange.week:
        return weeklyData;
      case ActivityTimeRange.month:
        return monthlyData;
      case ActivityTimeRange.year:
        return []; // Use yearlyData for monthly summary
    }
  }

  /// Calculate total energy for current range.
  double get totalEnergy {
    return currentGraphData.fold(0, (sum, day) => sum + day.energyKwh);
  }

  /// Calculate total spending for current range.
  double get totalSpending {
    return currentGraphData.fold(0, (sum, day) => sum + day.cost);
  }

  /// Calculate total sessions for current range.
  int get totalSessions {
    return currentGraphData.fold(0, (sum, day) => sum + day.sessions);
  }

  /// Copy with new values.
  ActivityState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    UserActivitySummary? summary,
    List<ChargingSessionModel>? sessions,
    List<TransactionModel>? transactions,
    List<DailyChargingSummary>? weeklyData,
    List<DailyChargingSummary>? monthlyData,
    List<MonthlyChargingSummary>? yearlyData,
    ActivityInsights? insights,
    ActivityTimeRange? selectedTimeRange,
    ActivityTab? selectedTab,
    String? error,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      summary: summary ?? this.summary,
      sessions: sessions ?? this.sessions,
      transactions: transactions ?? this.transactions,
      weeklyData: weeklyData ?? this.weeklyData,
      monthlyData: monthlyData ?? this.monthlyData,
      yearlyData: yearlyData ?? this.yearlyData,
      insights: insights ?? this.insights,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      selectedTab: selectedTab ?? this.selectedTab,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    summary,
    sessions,
    transactions,
    weeklyData,
    monthlyData,
    yearlyData,
    insights,
    selectedTimeRange,
    selectedTab,
    error,
  ];
}
