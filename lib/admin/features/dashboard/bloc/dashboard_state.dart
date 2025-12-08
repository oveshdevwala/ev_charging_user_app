/// File: lib/admin/features/dashboard/bloc/dashboard_state.dart
/// Purpose: Dashboard state
/// Belongs To: admin/features/dashboard
library;

import 'package:equatable/equatable.dart';

/// Dashboard state.
class DashboardState extends Equatable {
  const DashboardState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.totalStations = 0,
    this.activeUsers = 0,
    this.todaySessions = 0,
    this.todayRevenue = 0,
    this.stationsChange = 0,
    this.usersChange = 0,
    this.sessionsChange = 0,
    this.revenueChange = 0,
    this.recentActivity = const [],
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final int totalStations;
  final int activeUsers;
  final int todaySessions;
  final double todayRevenue;
  final double stationsChange;
  final double usersChange;
  final double sessionsChange;
  final double revenueChange;
  final List<ActivityItem> recentActivity;

  DashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    int? totalStations,
    int? activeUsers,
    int? todaySessions,
    double? todayRevenue,
    double? stationsChange,
    double? usersChange,
    double? sessionsChange,
    double? revenueChange,
    List<ActivityItem>? recentActivity,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      totalStations: totalStations ?? this.totalStations,
      activeUsers: activeUsers ?? this.activeUsers,
      todaySessions: todaySessions ?? this.todaySessions,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      stationsChange: stationsChange ?? this.stationsChange,
      usersChange: usersChange ?? this.usersChange,
      sessionsChange: sessionsChange ?? this.sessionsChange,
      revenueChange: revenueChange ?? this.revenueChange,
      recentActivity: recentActivity ?? this.recentActivity,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRefreshing,
        error,
        totalStations,
        activeUsers,
        todaySessions,
        todayRevenue,
        stationsChange,
        usersChange,
        sessionsChange,
        revenueChange,
        recentActivity,
      ];
}

/// Activity item for recent activity list.
class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, type, title, description, timestamp];
}

