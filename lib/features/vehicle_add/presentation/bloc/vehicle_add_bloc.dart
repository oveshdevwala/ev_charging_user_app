/// File: lib/features/vehicle_add/presentation/bloc/vehicle_add_bloc.dart
/// Purpose: BLoC for managing vehicle add/edit state
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Add analytics tracking as needed
///    - Adjust error handling
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../core/services/analytics_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';
import '../../utils/utils.dart';
import 'vehicle_add_event.dart';
import 'vehicle_add_state.dart';

/// Vehicle add BLoC.
class VehicleAddBloc extends Bloc<VehicleAddEvent, VehicleAddState> {
  VehicleAddBloc({
    required AddVehicle addVehicle,
    required GetUserVehicles getUserVehicles,
    required UpdateVehicle updateVehicle,
    required DeleteVehicle deleteVehicle,
    required SetDefaultVehicle setDefaultVehicle,
    AnalyticsService? analyticsService,
  }) : _addVehicle = addVehicle,
       _getUserVehicles = getUserVehicles,
       _updateVehicle = updateVehicle,
       _deleteVehicle = deleteVehicle,
       _setDefaultVehicle = setDefaultVehicle,
       _analyticsService = analyticsService,
       super(const VehicleAddInitial()) {
    on<VehicleAddInitialized>(_onInitialized);
    on<VehicleNickNameChanged>(_onNickNameChanged);
    on<VehicleMakeChanged>(_onMakeChanged);
    on<VehicleModelChanged>(_onModelChanged);
    on<VehicleYearChanged>(_onYearChanged);
    on<VehicleBatteryCapacityChanged>(_onBatteryCapacityChanged);
    on<VehicleTypeChanged>(_onVehicleTypeChanged);
    on<VehicleLicensePlateChanged>(_onLicensePlateChanged);
    on<VehicleIsDefaultChanged>(_onIsDefaultChanged);
    on<VehicleImagePicked>(_onImagePicked);
    on<VehicleImageRemoved>(_onImageRemoved);
    on<VehicleSaveRequested>(_onSaveRequested);
    on<VehicleSaveConfirmed>(_onSaveConfirmed);
    on<VehicleEditRequested>(_onEditRequested);
    on<VehicleDeleteRequested>(_onDeleteRequested);
    on<VehicleSetDefaultRequested>(_onSetDefaultRequested);
    on<VehicleListLoadRequested>(_onListLoadRequested);
    on<VehicleListRefreshRequested>(_onListRefreshRequested);
  }

  final AddVehicle _addVehicle;
  final GetUserVehicles _getUserVehicles;
  final UpdateVehicle _updateVehicle;
  final DeleteVehicle _deleteVehicle;
  final SetDefaultVehicle _setDefaultVehicle;
  final AnalyticsService? _analyticsService;

  String? _currentUserId;

  Future<void> _onInitialized(
    VehicleAddInitialized event,
    Emitter<VehicleAddState> emit,
  ) async {
    _currentUserId = event.userId;

    if (event.vehicleId != null) {
      // Load vehicle for editing
      final result = await _getUserVehicles(event.userId);
      result.fold(
        (Failure failure) => emit(
          VehicleAddFailure(failure.message ?? 'Failed to load vehicle'),
        ),
        (List<Vehicle> vehicles) {
          final vehicle = vehicles.firstWhere(
            (Vehicle v) => v.id == event.vehicleId,
            orElse: () => throw Exception('Vehicle not found'),
          );
          final form = VehicleForm(
            nickName: vehicle.nickName,
            make: vehicle.make,
            model: vehicle.model,
            year: vehicle.year,
            batteryCapacityKWh: vehicle.batteryCapacityKWh,
            vehicleType: vehicle.vehicleType,
            licensePlate: vehicle.licensePlate ?? '',
            isDefault: vehicle.isDefault,
            imageUrl: vehicle.imageUrl,
            vehicleId: vehicle.id,
          );
          emit(VehicleAddInitial(form: form));
        },
      );
    } else {
      emit(const VehicleAddInitial());
    }

    _analyticsService?.logEvent('vehicle_add_started', {
      'mode': event.vehicleId != null ? 'edit' : 'add',
    });
  }

  void _onNickNameChanged(
    VehicleNickNameChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(nickName: event.value);
      final errors = _validateField('nickName', event.value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onMakeChanged(VehicleMakeChanged event, Emitter<VehicleAddState> emit) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(make: event.value);
      final errors = _validateField('make', event.value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onModelChanged(
    VehicleModelChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(model: event.value);
      final errors = _validateField('model', event.value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onYearChanged(VehicleYearChanged event, Emitter<VehicleAddState> emit) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(year: event.value);
      final errors = _validateField('year', event.value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onBatteryCapacityChanged(
    VehicleBatteryCapacityChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(batteryCapacityKWh: event.value);
      final errors = _validateField('batteryCapacity', event.value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onVehicleTypeChanged(
    VehicleTypeChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(vehicleType: event.value);
      emit(currentState.copyWith(form: form));
    }
  }

  void _onLicensePlateChanged(
    VehicleLicensePlateChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      // Uppercase and trim
      final value = event.value.trim().toUpperCase();
      final form = currentState.form.copyWith(licensePlate: value);
      final errors = _validateField('licensePlate', value);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onIsDefaultChanged(
    VehicleIsDefaultChanged event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(isDefault: event.value);
      emit(currentState.copyWith(form: form));
    }
  }

  void _onImagePicked(VehicleImagePicked event, Emitter<VehicleAddState> emit) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith(imageFile: event.imageFile);
      final fileSize = event.imageFile.lengthSync();
      final errors = _validateField('image', event.imageFile.path, fileSize);
      emit(
        currentState.copyWith(
          form: form,
          fieldErrors: {...currentState.fieldErrors, ...errors},
        ),
      );
    }
  }

  void _onImageRemoved(
    VehicleImageRemoved event,
    Emitter<VehicleAddState> emit,
  ) {
    if (state is VehicleAddInitial) {
      final currentState = state as VehicleAddInitial;
      final form = currentState.form.copyWith();
      final errors = Map<String, String?>.from(currentState.fieldErrors);
      errors.remove('image');
      emit(currentState.copyWith(form: form, fieldErrors: errors));
    }
  }

  Future<void> _onSaveRequested(
    VehicleSaveRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    if (state is! VehicleAddInitial) return;

    final currentState = state as VehicleAddInitial;
    final form = currentState.form;

    // Validate all fields
    final errors = VehicleValidator.validateForm(
      nickName: form.nickName,
      make: form.make,
      model: form.model,
      year: form.year,
      batteryCapacity: form.batteryCapacityKWh,
      licensePlate: form.licensePlate,
      imageSizeBytes: form.imageFile?.lengthSync(),
      imagePath: form.imageFile?.path,
    );

    if (errors.isNotEmpty) {
      emit(currentState.copyWith(fieldErrors: errors));
      return;
    }

    // Emit loading and proceed to save
    emit(const VehicleAddLoading());
    add(const VehicleSaveConfirmed());
  }

  Future<void> _onSaveConfirmed(
    VehicleSaveConfirmed event,
    Emitter<VehicleAddState> emit,
  ) async {
    if (state is! VehicleAddLoading) return;

    final previousState = _getInitialState();
    if (previousState == null || _currentUserId == null) return;

    final form = previousState.form;

    try {
      if (form.vehicleId != null) {
        // Update existing vehicle
        final params = UpdateVehicleParams(
          vehicleId: form.vehicleId!,
          nickName: form.nickName,
          make: form.make,
          model: form.model,
          year: form.year,
          batteryCapacityKWh: form.batteryCapacityKWh,
          vehicleType: form.vehicleType,
          licensePlate: form.licensePlate.isEmpty ? null : form.licensePlate,
          isDefault: form.isDefault,
          imageUrl: form.imageUrl, // TODO: Upload image and get URL
        );

        final result = await _updateVehicle(params);
        result.fold(
          (Failure failure) => emit(
            VehicleAddFailure(failure.message ?? 'Failed to update vehicle'),
          ),
          (Vehicle vehicle) {
            _analyticsService?.logEvent('vehicle_add_success', {
              'mode': 'edit',
              'vehicleType': form.vehicleType.toString(),
              'year': form.year?.toString() ?? '',
            });
            emit(VehicleAddSuccess(vehicle));
          },
        );
      } else {
        // Add new vehicle
        final params = AddVehicleParams(
          userId: _currentUserId!,
          nickName: form.nickName,
          make: form.make,
          model: form.model,
          year: form.year!,
          batteryCapacityKWh: form.batteryCapacityKWh!,
          vehicleType: form.vehicleType,
          licensePlate: form.licensePlate.isEmpty ? null : form.licensePlate,
          isDefault: form.isDefault,
          imageUrl: form.imageUrl, // TODO: Upload image and get URL
        );

        final result = await _addVehicle(params);
        result.fold(
          (Failure failure) => emit(
            VehicleAddFailure(failure.message ?? 'Failed to add vehicle'),
          ),
          (Vehicle vehicle) {
            _analyticsService?.logEvent('vehicle_add_success', {
              'mode': 'add',
              'vehicleType': form.vehicleType.toString(),
              'year': form.year?.toString() ?? '',
            });
            emit(VehicleAddSuccess(vehicle));
          },
        );
      }
    } catch (e) {
      _analyticsService?.logEvent('vehicle_add_failure', {
        'error': e.toString(),
      });
      emit(VehicleAddFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onEditRequested(
    VehicleEditRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    if (_currentUserId == null) return;

    emit(const VehicleAddLoading());
    add(VehicleAddInitialized(_currentUserId!, vehicleId: event.vehicleId));
  }

  Future<void> _onDeleteRequested(
    VehicleDeleteRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    emit(const VehicleAddLoading());

    final result = await _deleteVehicle(event.vehicleId);
    result.fold(
      (Failure failure) => emit(
        VehicleAddFailure(failure.message ?? 'Failed to delete vehicle'),
      ),
      (void _) {
        // Reload list
        if (_currentUserId != null) {
          add(VehicleListLoadRequested(_currentUserId!));
        }
      },
    );
  }

  Future<void> _onSetDefaultRequested(
    VehicleSetDefaultRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    if (_currentUserId == null) return;

    emit(const VehicleAddLoading());

    final result = await _setDefaultVehicle(_currentUserId!, event.vehicleId);
    result.fold(
      (Failure failure) => emit(
        VehicleAddFailure(failure.message ?? 'Failed to set default vehicle'),
      ),
      (Vehicle vehicle) {
        _analyticsService?.logEvent('vehicle_set_default', {
          'vehicleId': event.vehicleId,
        });
        // Reload list
        add(VehicleListLoadRequested(_currentUserId!));
      },
    );
  }

  Future<void> _onListLoadRequested(
    VehicleListLoadRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    _currentUserId = event.userId;
    emit(const VehicleListLoadInProgress());

    final result = await _getUserVehicles(event.userId);
    result.fold(
      (Failure failure) => emit(
        VehicleListLoadFailure(failure.message ?? 'Failed to load vehicles'),
      ),
      (List<Vehicle> vehicles) => emit(VehicleListLoadSuccess(vehicles)),
    );
  }

  Future<void> _onListRefreshRequested(
    VehicleListRefreshRequested event,
    Emitter<VehicleAddState> emit,
  ) async {
    add(VehicleListLoadRequested(event.userId));
  }

  /// Validate a single field.
  Map<String, String?> _validateField(
    String fieldName,
    value, [
    int? fileSizeBytes,
  ]) {
    final errors = <String, String?>{};

    switch (fieldName) {
      case 'nickName':
        final validation = VehicleValidator.validateNickName(value as String?);
        if (!validation.isValid) {
          errors['nickName'] = validation.errorKey;
        }
        break;
      case 'make':
        final validation = VehicleValidator.validateMake(value as String?);
        if (!validation.isValid) {
          errors['make'] = validation.errorKey;
        }
        break;
      case 'model':
        final validation = VehicleValidator.validateModel(value as String?);
        if (!validation.isValid) {
          errors['model'] = validation.errorKey;
        }
        break;
      case 'year':
        final validation = VehicleValidator.validateYear(value as int?);
        if (!validation.isValid) {
          errors['year'] = validation.errorKey;
        }
        break;
      case 'batteryCapacity':
        final validation = VehicleValidator.validateBatteryCapacity(
          value as double?,
        );
        if (!validation.isValid) {
          errors['batteryCapacity'] = validation.errorKey;
        }
        break;
      case 'licensePlate':
        final validation = VehicleValidator.validateLicensePlate(
          value as String?,
        );
        if (!validation.isValid) {
          errors['licensePlate'] = validation.errorKey;
        }
        break;
      case 'image':
        if (fileSizeBytes != null) {
          final sizeValidation = VehicleValidator.validateImageSize(
            fileSizeBytes,
          );
          if (!sizeValidation.isValid) {
            errors['image'] = sizeValidation.errorKey;
          }
        }
        if (value != null) {
          final typeValidation = VehicleValidator.validateImageType(
            value as String,
          );
          if (!typeValidation.isValid) {
            errors['image'] = typeValidation.errorKey;
          }
        }
        break;
    }

    return errors;
  }

  /// Get initial state from history.
  VehicleAddInitial? _getInitialState() {
    // Try to get from current state
    if (state is VehicleAddInitial) {
      return state as VehicleAddInitial;
    }
    return null;
  }
}
