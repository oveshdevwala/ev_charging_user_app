/// File: lib/admin/blocs/managers/managers_event.dart
/// Purpose: Managers events
/// Belongs To: admin/blocs/managers
library;

import 'package:equatable/equatable.dart';
import 'package:ev_charging_user_app/admin/models/manager.dart';


/// Base class for managers events.
abstract class ManagersEvent extends Equatable {
  const ManagersEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load managers list.
class LoadManagers extends ManagersEvent {
  const LoadManagers();
}

/// Event to create a new manager.
class CreateManagerEvent extends ManagersEvent {
  const CreateManagerEvent(this.manager);

  final Manager manager;

  @override
  List<Object?> get props => [manager];
}

/// Event to update an existing manager.
class UpdateManagerEvent extends ManagersEvent {
  const UpdateManagerEvent(this.manager);

  final Manager manager;

  @override
  List<Object?> get props => [manager];
}

/// Event to delete a manager.
class DeleteManagerEvent extends ManagersEvent {
  const DeleteManagerEvent(this.managerId);

  final String managerId;

  @override
  List<Object?> get props => [managerId];
}

/// Event to assign stations to a manager.
class AssignStationsEvent extends ManagersEvent {
  const AssignStationsEvent(this.managerId, this.stationIds);

  final String managerId;
  final List<String> stationIds;

  @override
  List<Object?> get props => [managerId, stationIds];
}

/// Event to toggle manager status.
class ToggleStatusEvent extends ManagersEvent {
  const ToggleStatusEvent(this.managerId, this.newStatus);

  final String managerId;
  final String newStatus;

  @override
  List<Object?> get props => [managerId, newStatus];
}

/// Event when search query changes.
class ManagersSearchChanged extends ManagersEvent {
  const ManagersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event when filter changes.
class ManagersFilterChanged extends ManagersEvent {
  const ManagersFilterChanged(this.filters);

  final Map<String, dynamic>? filters;

  @override
  List<Object?> get props => [filters];
}

/// Event when sort changes.
class ManagersSortChanged extends ManagersEvent {
  const ManagersSortChanged(this.sortBy, this.desc);

  final String? sortBy;
  final bool desc;

  @override
  List<Object?> get props => [sortBy, desc];
}

/// Event when page changes.
class ManagersPageChanged extends ManagersEvent {
  const ManagersPageChanged(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

