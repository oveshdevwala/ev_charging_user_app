/// File: lib/admin/features/stations/bloc/stations_state.dart
/// Purpose: Stations state
/// Belongs To: admin/features/stations
library;

import 'package:equatable/equatable.dart';

import '../../../models/admin_station_model.dart';
import '../repository/stations_repository.dart';

/// Stations state.
class StationsState extends Equatable {
  const StationsState({
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.error,
    this.stations = const [],
    this.selectedStation,
    this.totalStations = 0,
    this.stats,
    this.searchQuery = '',
    this.filterStatus,
    this.sortBy,
    this.sortAscending = true,
    this.currentPage = 1,
    this.pageSize = 10,
    this.selectedStationIds = const {},
  });

  final bool isLoading;
  final bool isLoadingDetail;
  final String? error;
  final List<AdminStation> stations;
  final AdminStation? selectedStation;
  final int totalStations;
  final StationStats? stats;
  final String searchQuery;
  final AdminStationStatus? filterStatus;
  final String? sortBy;
  final bool sortAscending;
  final int currentPage;
  final int pageSize;
  final Set<String> selectedStationIds;

  /// Get total pages.
  int get totalPages => (totalStations / pageSize).ceil();

  /// Get paginated stations for current page.
  List<AdminStation> get paginatedStations {
    final start = (currentPage - 1) * pageSize;
    final end = start + pageSize;
    if (start >= stations.length) return [];
    return stations.sublist(start, end.clamp(0, stations.length));
  }

  /// Check if any stations are selected.
  bool get hasSelection => selectedStationIds.isNotEmpty;

  /// Get selected stations count.
  int get selectedCount => selectedStationIds.length;

  StationsState copyWith({
    bool? isLoading,
    bool? isLoadingDetail,
    String? error,
    List<AdminStation>? stations,
    AdminStation? selectedStation,
    int? totalStations,
    StationStats? stats,
    String? searchQuery,
    AdminStationStatus? filterStatus,
    String? sortBy,
    bool? sortAscending,
    int? currentPage,
    int? pageSize,
    Set<String>? selectedStationIds,
  }) {
    return StationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      error: error,
      stations: stations ?? this.stations,
      selectedStation: selectedStation ?? this.selectedStation,
      totalStations: totalStations ?? this.totalStations,
      stats: stats ?? this.stats,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      selectedStationIds: selectedStationIds ?? this.selectedStationIds,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingDetail,
        error,
        stations,
        selectedStation,
        totalStations,
        stats,
        searchQuery,
        filterStatus,
        sortBy,
        sortAscending,
        currentPage,
        pageSize,
        selectedStationIds,
      ];
}

