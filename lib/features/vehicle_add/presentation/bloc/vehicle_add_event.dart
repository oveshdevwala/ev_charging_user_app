/// File: lib/features/vehicle_add/presentation/bloc/vehicle_add_event.dart
/// Purpose: Events for VehicleAddBloc
/// Belongs To: vehicle_add feature
library;

import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

/// Base class for vehicle add events.
abstract class VehicleAddEvent extends Equatable {
  const VehicleAddEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize vehicle add form.
class VehicleAddInitialized extends VehicleAddEvent {
  const VehicleAddInitialized(this.userId, {this.vehicleId});

  final String userId;
  final String? vehicleId; // If provided, load for editing

  @override
  List<Object?> get props => [userId, vehicleId];
}

/// Field changed events.
class VehicleNickNameChanged extends VehicleAddEvent {
  const VehicleNickNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class VehicleMakeChanged extends VehicleAddEvent {
  const VehicleMakeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class VehicleModelChanged extends VehicleAddEvent {
  const VehicleModelChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class VehicleYearChanged extends VehicleAddEvent {
  const VehicleYearChanged(this.value);

  final int value;

  @override
  List<Object?> get props => [value];
}

class VehicleBatteryCapacityChanged extends VehicleAddEvent {
  const VehicleBatteryCapacityChanged(this.value);

  final double value;

  @override
  List<Object?> get props => [value];
}

class VehicleTypeChanged extends VehicleAddEvent {
  const VehicleTypeChanged(this.value);

  final VehicleType value;

  @override
  List<Object?> get props => [value];
}

class VehicleLicensePlateChanged extends VehicleAddEvent {
  const VehicleLicensePlateChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class VehicleIsDefaultChanged extends VehicleAddEvent {
  const VehicleIsDefaultChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

/// Image picked event.
class VehicleImagePicked extends VehicleAddEvent {
  const VehicleImagePicked(this.imageFile);

  final File imageFile;

  @override
  List<Object?> get props => [imageFile];
}

/// Image removed event.
class VehicleImageRemoved extends VehicleAddEvent {
  const VehicleImageRemoved();
}

/// Save vehicle requested.
class VehicleSaveRequested extends VehicleAddEvent {
  const VehicleSaveRequested();
}

/// Save vehicle confirmed (after validation).
class VehicleSaveConfirmed extends VehicleAddEvent {
  const VehicleSaveConfirmed();
}

/// Edit vehicle requested.
class VehicleEditRequested extends VehicleAddEvent {
  const VehicleEditRequested(this.vehicleId);

  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

/// Delete vehicle requested.
class VehicleDeleteRequested extends VehicleAddEvent {
  const VehicleDeleteRequested(this.vehicleId);

  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

/// Set default vehicle requested.
class VehicleSetDefaultRequested extends VehicleAddEvent {
  const VehicleSetDefaultRequested(this.vehicleId);

  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

/// Load user vehicles.
class VehicleListLoadRequested extends VehicleAddEvent {
  const VehicleListLoadRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Refresh vehicle list.
class VehicleListRefreshRequested extends VehicleAddEvent {
  const VehicleListRefreshRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

