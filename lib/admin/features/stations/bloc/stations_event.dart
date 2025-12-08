/// File: lib/admin/features/stations/bloc/stations_event.dart
/// Purpose: Stations events
/// Belongs To: admin/features/stations
library;

import 'package:equatable/equatable.dart';

import '../../../models/admin_station_model.dart';

/// Base class for stations events.
abstract class StationsEvent extends Equatable {
  const StationsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load stations list.
class StationsLoadRequested extends StationsEvent {
  const StationsLoadRequested();
}

/// Event to refresh stations list.
class StationsRefreshRequested extends StationsEvent {
  const StationsRefreshRequested();
}

/// Event when search query changes.
class StationsSearchChanged extends StationsEvent {
  const StationsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event when filter changes.
class StationsFilterChanged extends StationsEvent {
  const StationsFilterChanged(this.status);

  final AdminStationStatus? status;

  @override
  List<Object?> get props => [status];
}

/// Event when sort changes.
class StationsSortChanged extends StationsEvent {
  const StationsSortChanged(this.sortBy);

  final String sortBy;

  @override
  List<Object?> get props => [sortBy];
}

/// Event when page changes.
class StationsPageChanged extends StationsEvent {
  const StationsPageChanged(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

/// Event when selection changes.
class StationsSelectionChanged extends StationsEvent {
  const StationsSelectionChanged(this.selectedIds);

  final Set<String> selectedIds;

  @override
  List<Object?> get props => [selectedIds];
}

/// Event to delete a station.
class StationDeleteRequested extends StationsEvent {
  const StationDeleteRequested(this.stationId);

  final String stationId;

  @override
  List<Object?> get props => [stationId];
}

/// Event to load station detail.
class StationDetailLoadRequested extends StationsEvent {
  const StationDetailLoadRequested(this.stationId);

  final String stationId;

  @override
  List<Object?> get props => [stationId];
}

/// Event to save station.
class StationSaveRequested extends StationsEvent {
  const StationSaveRequested(this.station);

  final AdminStation station;

  @override
  List<Object?> get props => [station];
}

/// Event to assign manager to station.
class StationAssignManagerRequested extends StationsEvent {
  const StationAssignManagerRequested({
    required this.stationId,
    required this.managerId,
    required this.managerName,
  });

  final String stationId;
  final String managerId;
  final String managerName;

  @override
  List<Object?> get props => [stationId, managerId, managerName];
}

