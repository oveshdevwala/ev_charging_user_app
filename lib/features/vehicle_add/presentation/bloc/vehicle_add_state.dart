/// File: lib/features/vehicle_add/presentation/bloc/vehicle_add_state.dart
/// Purpose: States for VehicleAddBloc
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Add new state fields as needed
///    - Update copyWith accordingly
library;

import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

/// Vehicle form data DTO.
class VehicleForm extends Equatable {
  const VehicleForm({
    this.nickName = '',
    this.make = '',
    this.model = '',
    this.year,
    this.batteryCapacityKWh,
    this.vehicleType = VehicleType.BEV,
    this.licensePlate = '',
    this.isDefault = false,
    this.imageFile,
    this.imageUrl,
    this.vehicleId, // For edit mode
  });

  final String nickName;
  final String make;
  final String model;
  final int? year;
  final double? batteryCapacityKWh;
  final VehicleType vehicleType;
  final String licensePlate;
  final bool isDefault;
  final File? imageFile;
  final String? imageUrl;
  final String? vehicleId;

  VehicleForm copyWith({
    String? nickName,
    String? make,
    String? model,
    int? year,
    double? batteryCapacityKWh,
    VehicleType? vehicleType,
    String? licensePlate,
    bool? isDefault,
    File? imageFile,
    String? imageUrl,
    String? vehicleId,
  }) {
    return VehicleForm(
      nickName: nickName ?? this.nickName,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      batteryCapacityKWh: batteryCapacityKWh ?? this.batteryCapacityKWh,
      vehicleType: vehicleType ?? this.vehicleType,
      licensePlate: licensePlate ?? this.licensePlate,
      isDefault: isDefault ?? this.isDefault,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }

  @override
  List<Object?> get props => [
        nickName,
        make,
        model,
        year,
        batteryCapacityKWh,
        vehicleType,
        licensePlate,
        isDefault,
        imageFile,
        imageUrl,
        vehicleId,
      ];
}

/// Base vehicle add state.
abstract class VehicleAddState extends Equatable {
  const VehicleAddState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class VehicleAddInitial extends VehicleAddState {
  const VehicleAddInitial({
    this.form = const VehicleForm(),
    this.fieldErrors = const {},
  });

  final VehicleForm form;
  final Map<String, String?> fieldErrors; // Field name -> error i18n key

  VehicleAddInitial copyWith({
    VehicleForm? form,
    Map<String, String?>? fieldErrors,
  }) {
    return VehicleAddInitial(
      form: form ?? this.form,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [form, fieldErrors];
}

/// Loading state.
class VehicleAddLoading extends VehicleAddState {
  const VehicleAddLoading();
}

/// Success state.
class VehicleAddSuccess extends VehicleAddState {
  const VehicleAddSuccess(this.vehicle);

  final Vehicle vehicle;

  @override
  List<Object?> get props => [vehicle];
}

/// Failure state.
class VehicleAddFailure extends VehicleAddState {
  const VehicleAddFailure(
    this.errorMessage, {
    this.fieldErrors = const {},
  });

  final String errorMessage;
  final Map<String, String?> fieldErrors;

  @override
  List<Object?> get props => [errorMessage, fieldErrors];
}

/// Vehicle list states.
class VehicleListInitial extends VehicleAddState {
  const VehicleListInitial();
}

class VehicleListLoadInProgress extends VehicleAddState {
  const VehicleListLoadInProgress();
}

class VehicleListLoadSuccess extends VehicleAddState {
  const VehicleListLoadSuccess(this.vehicles);

  final List<Vehicle> vehicles;

  @override
  List<Object?> get props => [vehicles];
}

class VehicleListLoadFailure extends VehicleAddState {
  const VehicleListLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

