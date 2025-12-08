/// File: lib/admin/features/dashboard/bloc/dashboard_event.dart
/// Purpose: Dashboard events
/// Belongs To: admin/features/dashboard
library;

import 'package:equatable/equatable.dart';

/// Base class for dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data.
class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

/// Event to refresh dashboard data.
class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

/// Event to change date range.
class DashboardDateRangeChanged extends DashboardEvent {
  const DashboardDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

