import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/export_trip_report.dart';
import '../../domain/usecases/get_monthly_analytics.dart';
import '../../domain/usecases/get_trip_history.dart';
import 'trip_history_event.dart';
import 'trip_history_state.dart';

class TripHistoryBloc extends Bloc<TripHistoryEvent, TripHistoryState> {
  final GetTripHistory getTripHistory;
  final GetMonthlyAnalytics getMonthlyAnalytics;
  final ExportTripReport exportTripReport;

  TripHistoryBloc({
    required this.getTripHistory,
    required this.getMonthlyAnalytics,
    required this.exportTripReport,
  }) : super(TripHistoryInitial()) {
    on<FetchTripHistory>(_onFetchTripHistory);
    on<FetchMonthlyAnalytics>(_onFetchMonthlyAnalytics);
    on<ExportReportPDF>(_onExportReportPDF);
  }

  Future<void> _onFetchTripHistory(
    FetchTripHistory event,
    Emitter<TripHistoryState> emit,
  ) async {
    emit(TripHistoryLoading());
    try {
      final trips = await getTripHistory();
      // Also fetch analytics for current month by default
      final currentMonth = DateTime.now().toIso8601String().substring(0, 7);
      try {
        final analytics = await getMonthlyAnalytics(currentMonth);
        emit(TripHistoryLoaded(trips: trips, analytics: analytics));
      } catch (e) {
        // If analytics fail, still show trips
        emit(TripHistoryLoaded(trips: trips));
      }
    } catch (e) {
      emit(TripHistoryError(e.toString()));
    }
  }

  Future<void> _onFetchMonthlyAnalytics(
    FetchMonthlyAnalytics event,
    Emitter<TripHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripHistoryLoaded) {
      try {
        final analytics = await getMonthlyAnalytics(event.month);
        emit(currentState.copyWith(analytics: analytics));
      } catch (e) {
        emit(TripHistoryError(e.toString()));
      }
    }
  }

  Future<void> _onExportReportPDF(
    ExportReportPDF event,
    Emitter<TripHistoryState> emit,
  ) async {
    emit(TripHistoryExporting());
    try {
      final file = await exportTripReport(event.month);
      emit(TripHistoryExported(file));
      // Revert to loaded state after export? Or let UI handle it.
      // Usually UI listens to Exported, shows snackbar, then we can go back to Loaded if needed.
      // But here we might lose the loaded data if we switch state completely.
      // Better to use a "Side Effect" or keep data in Exporting/Exported state.
      // For simplicity, I'll just emit Exported and assume UI handles navigation or overlay.
      // Actually, to preserve data, Exported should probably hold the data too, or we use a separate "Action" stream.
      // But standard BLoC uses State.
      // I'll make Exported extend Loaded or hold data?
      // No, I'll just emit Exported, and then UI can trigger a reload or I can emit Loaded again.
      // Let's emit Loaded again after a delay or let UI re-trigger.
      // Or better: Exporting/Exported are "Overlay" states?
      // I'll stick to the simple flow: Exporting -> Exported.
      // If the user wants to see the list again, they might need to refresh or I should pass the data through.
      // I'll modify State to always hold data if possible.
      // But for now, I'll follow the prompt's state list.
    } catch (e) {
      emit(TripHistoryError(e.toString()));
    }
  }
}
