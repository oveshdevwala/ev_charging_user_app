import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/completed_trip.dart';
import '../../domain/entities/monthly_analytics.dart';
import '../../domain/entities/trip_record.dart';

abstract class TripHistoryState extends Equatable {
  const TripHistoryState();

  @override
  List<Object?> get props => [];
}

class TripHistoryInitial extends TripHistoryState {}

class TripHistoryLoading extends TripHistoryState {}

class TripHistoryLoaded extends TripHistoryState {
  const TripHistoryLoaded({
    required this.trips,
    this.analytics,
    this.completedTrips = const [],
  });
  final List<TripRecord> trips;
  final MonthlyAnalytics? analytics;
  final List<CompletedTrip> completedTrips;

  @override
  List<Object?> get props => [trips, analytics, completedTrips];

  TripHistoryLoaded copyWith({
    List<TripRecord>? trips,
    MonthlyAnalytics? analytics,
    List<CompletedTrip>? completedTrips,
  }) {
    return TripHistoryLoaded(
      trips: trips ?? this.trips,
      analytics: analytics ?? this.analytics,
      completedTrips: completedTrips ?? this.completedTrips,
    );
  }
}

class TripHistoryExporting extends TripHistoryState {}

class TripHistoryExported extends TripHistoryState {
  const TripHistoryExported(this.file);
  final File file;

  @override
  List<Object?> get props => [file];
}

class TripHistoryError extends TripHistoryState {
  const TripHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
