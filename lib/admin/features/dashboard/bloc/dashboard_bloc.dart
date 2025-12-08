/// File: lib/admin/features/dashboard/bloc/dashboard_bloc.dart
/// Purpose: Dashboard BLoC for managing dashboard state
/// Belongs To: admin/features/dashboard
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
        isLoading: false,
        totalStations: 25,
        activeUsers: 1250,
        todaySessions: 342,
        todayRevenue: 5680.50,
        stationsChange: 8.5,
        usersChange: 12.3,
        sessionsChange: -2.1,
        revenueChange: 15.7,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      emit(state.copyWith(
        isRefreshing: false,
        todaySessions: state.todaySessions + 5,
        todayRevenue: state.todayRevenue + 125.50,
      ));
    } catch (e) {
      emit(state.copyWith(isRefreshing: false));
    }
  }
}

