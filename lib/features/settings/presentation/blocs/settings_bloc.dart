/// File: lib/features/settings/presentation/blocs/settings_bloc.dart
/// Purpose: Settings BLoC for managing settings state
/// Belongs To: settings feature
/// Customization Guide:
///    - Add new events/states as needed
///    - Handle errors appropriately
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

// ============================================================
// EVENTS
// ============================================================

/// Settings events.
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load settings event.
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Update settings event.
class UpdateSettings extends SettingsEvent {
  const UpdateSettings(this.settings);
  final SettingsModel settings;

  @override
  List<Object?> get props => [settings];
}

/// Reset settings event.
class ResetSettings extends SettingsEvent {
  const ResetSettings();
}

/// Export settings event.
class ExportSettings extends SettingsEvent {
  const ExportSettings();
}

/// Import settings event.
class ImportSettings extends SettingsEvent {
  const ImportSettings(this.json, {this.replace = false});
  final String json;
  final bool replace;

  @override
  List<Object?> get props => [json, replace];
}

// ============================================================
// STATES
// ============================================================

/// Settings states.
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading state.
class SettingsLoadInProgress extends SettingsState {
  const SettingsLoadInProgress();
}

/// Load success state.
class SettingsLoadSuccess extends SettingsState {
  const SettingsLoadSuccess(this.settings);
  final SettingsModel settings;

  @override
  List<Object?> get props => [settings];
}

/// Save success state.
class SettingsSaveSuccess extends SettingsState {
  const SettingsSaveSuccess(this.settings);
  final SettingsModel settings;

  @override
  List<Object?> get props => [settings];
}

/// Export success state.
class SettingsExportSuccess extends SettingsState {
  const SettingsExportSuccess(this.json);
  final String json;

  @override
  List<Object?> get props => [json];
}

/// Import success state.
class SettingsImportSuccess extends SettingsState {
  const SettingsImportSuccess(this.settings);
  final SettingsModel settings;

  @override
  List<Object?> get props => [settings];
}

/// Reset success state.
class SettingsResetSuccess extends SettingsState {
  const SettingsResetSuccess(this.settings);
  final SettingsModel settings;

  @override
  List<Object?> get props => [settings];
}

/// Failure state.
class SettingsFailure extends SettingsState {
  const SettingsFailure(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

// ============================================================
// BLOC
// ============================================================

/// Settings BLoC.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository repository})
      : _repository = repository,
        super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
    on<ResetSettings>(_onResetSettings);
    on<ExportSettings>(_onExportSettings);
    on<ImportSettings>(_onImportSettings);
  }

  final SettingsRepository _repository;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoadInProgress());
    try {
      final settings = await _repository.load();
      emit(SettingsLoadSuccess(settings));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.save(event.settings);
      emit(SettingsSaveSuccess(event.settings));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.resetToDefaults();
      final settings = await _repository.load();
      emit(SettingsResetSuccess(settings));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onExportSettings(
    ExportSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final json = await _repository.exportJson();
      emit(SettingsExportSuccess(json));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onImportSettings(
    ImportSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.importJson(event.json, replace: event.replace);
      final settings = await _repository.load();
      emit(SettingsImportSuccess(settings));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }
}

