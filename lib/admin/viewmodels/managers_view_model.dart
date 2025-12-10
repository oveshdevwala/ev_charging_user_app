/// File: lib/admin/viewmodels/managers_view_model.dart
/// Purpose: ViewModel for Managers feature providing convenience methods
/// Belongs To: admin/viewmodels
/// Customization Guide:
///    - Add additional helper methods as needed
///    - Adjust debounce duration if needed
library;

import 'dart:async';


import '../features/managers/blocs/managers/managers_bloc.dart';
import '../features/managers/blocs/managers/managers_event.dart';
import '../models/manager.dart';

/// ViewModel for Managers feature.
class ManagersViewModel {
  ManagersViewModel(this.bloc);

  final ManagersBloc bloc;

  Timer? _searchTimer;

  /// Load managers.
  void load() {
    bloc.add(const LoadManagers());
  }

  /// Create a new manager.
  void create(Manager manager) {
    bloc.add(CreateManagerEvent(manager));
  }

  /// Update an existing manager.
  void update(Manager manager) {
    bloc.add(UpdateManagerEvent(manager));
  }

  /// Delete a manager.
  void delete(String managerId) {
    bloc.add(DeleteManagerEvent(managerId));
  }

  /// Assign stations to a manager.
  void assignStations(String managerId, List<String> stationIds) {
    bloc.add(AssignStationsEvent(managerId, stationIds));
  }

  /// Toggle manager status.
  void toggleStatus(String managerId, String newStatus) {
    bloc.add(ToggleStatusEvent(managerId, newStatus));
  }

  /// Search with debounce.
  void search(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      bloc.add(ManagersSearchChanged(query));
    });
  }

  /// Filter managers.
  void filter(Map<String, dynamic>? filters) {
    bloc.add(ManagersFilterChanged(filters));
  }

  /// Sort managers.
  void sort(String? sortBy, bool desc) {
    bloc.add(ManagersSortChanged(sortBy, desc));
  }

  /// Change page.
  void changePage(int page) {
    bloc.add(ManagersPageChanged(page));
  }

  /// Export CSV (returns CSV string).
  String exportCsv(List<Manager> managers) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('ID,Name,Email,Phone,Assigned Stations,Roles,Status,Created At');
    
    // Rows
    for (final manager in managers) {
      final stationIds = manager.assignedStationIds.join(';');
      final roles = manager.roles.join(';');
      buffer.writeln(
        '"${manager.id}",'
        '"${manager.name}",'
        '"${manager.email}",'
        '"${manager.phone ?? ''}",'
        '"$stationIds",'
        '"$roles",'
        '"${manager.status}",'
        '"${manager.createdAt.toIso8601String()}"',
      );
    }
    
    return buffer.toString();
  }

  void dispose() {
    _searchTimer?.cancel();
  }
}

