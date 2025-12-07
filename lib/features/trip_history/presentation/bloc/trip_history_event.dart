import 'package:equatable/equatable.dart';

abstract class TripHistoryEvent extends Equatable {
  const TripHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchTripHistory extends TripHistoryEvent {}

class FetchMonthlyAnalytics extends TripHistoryEvent {
  const FetchMonthlyAnalytics(this.month);
  final String month;

  @override
  List<Object> get props => [month];
}

class ExportReportPDF extends TripHistoryEvent {
  const ExportReportPDF(this.month);
  final String month;

  @override
  List<Object> get props => [month];
}

class FetchCompletedTrips extends TripHistoryEvent {}

class ToggleTripFavorite extends TripHistoryEvent {
  const ToggleTripFavorite(this.tripId);
  final String tripId;

  @override
  List<Object> get props => [tripId];
}
