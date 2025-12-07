/// File: lib/features/settings/presentation/blocs/appearance_bloc.dart
/// Purpose: Appearance BLoC for theme and appearance changes
/// Belongs To: settings feature
/// Customization Guide:
///    - Integrate with ThemeManager for theme switching
library;

import 'package:equatable/equatable.dart';
import 'package:ev_charging_user_app/core/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

// ============================================================
// EVENTS
// ============================================================

/// Appearance events.
abstract class AppearanceEvent extends Equatable {
  const AppearanceEvent();

  @override
  List<Object?> get props => [];
}

/// Change theme mode event.
class ChangeThemeMode extends AppearanceEvent {
  const ChangeThemeMode(this.mode);
  final ThemeModeOption mode;

  @override
  List<Object?> get props => [mode];
}

/// Change accent color event.
class ChangeAccentColor extends AppearanceEvent {
  const ChangeAccentColor(this.colorHex);
  final String colorHex;

  @override
  List<Object?> get props => [colorHex];
}

/// Change font scale event.
class ChangeFontScale extends AppearanceEvent {
  const ChangeFontScale(this.fontScale);
  final FontSizeOption fontScale;

  @override
  List<Object?> get props => [fontScale];
}

// ============================================================
// STATES
// ============================================================

/// Appearance states.
abstract class AppearanceState extends Equatable {
  const AppearanceState();

  @override
  List<Object?> get props => [];
}

/// Appearance updated state.
class AppearanceUpdated extends AppearanceState {
  const AppearanceUpdated(this.appearance);
  final AppearanceSettings appearance;

  @override
  List<Object?> get props => [appearance];
}

/// Appearance failure state.
class AppearanceFailure extends AppearanceState {
  const AppearanceFailure(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

// ============================================================
// BLOC
// ============================================================

/// Appearance BLoC.
class AppearanceBloc extends Bloc<AppearanceEvent, AppearanceState> {
  AppearanceBloc({
    required SettingsRepository repository,
    required ThemeManager themeManager,
  }) : _repository = repository,
       _themeManager = themeManager,
       super(const AppearanceUpdated(AppearanceSettings())) {
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeAccentColor>(_onChangeAccentColor);
    on<ChangeFontScale>(_onChangeFontScale);

    // Load initial appearance settings
    _loadInitialSettings();
  }

  final SettingsRepository _repository;
  final ThemeManager _themeManager;

  Future<void> _loadInitialSettings() async {
    try {
      final settings = await _repository.load();
      emit(AppearanceUpdated(settings.appearance));
    } catch (e) {
      emit(AppearanceFailure(e.toString()));
    }
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<AppearanceState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedAppearance = currentSettings.appearance.copyWith(
        themeMode: event.mode,
      );

      // Update ThemeManager
      switch (event.mode) {
        case ThemeModeOption.light:
          await _themeManager.setLightMode();
        case ThemeModeOption.dark:
          await _themeManager.setDarkMode();
        case ThemeModeOption.system:
          await _themeManager.setSystemMode();
      }

      // Save to repository
      final updatedSettings = currentSettings.copyWith(
        appearance: updatedAppearance,
      );
      await _repository.save(updatedSettings);

      emit(AppearanceUpdated(updatedAppearance));
    } catch (e) {
      emit(AppearanceFailure(e.toString()));
    }
  }

  Future<void> _onChangeAccentColor(
    ChangeAccentColor event,
    Emitter<AppearanceState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedAppearance = currentSettings.appearance.copyWith(
        accentColorHex: event.colorHex,
      );

      final updatedSettings = currentSettings.copyWith(
        appearance: updatedAppearance,
      );
      await _repository.save(updatedSettings);

      emit(AppearanceUpdated(updatedAppearance));
    } catch (e) {
      emit(AppearanceFailure(e.toString()));
    }
  }

  Future<void> _onChangeFontScale(
    ChangeFontScale event,
    Emitter<AppearanceState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedAppearance = currentSettings.appearance.copyWith(
        fontScale: event.fontScale,
      );

      final updatedSettings = currentSettings.copyWith(
        appearance: updatedAppearance,
      );
      await _repository.save(updatedSettings);

      emit(AppearanceUpdated(updatedAppearance));
    } catch (e) {
      emit(AppearanceFailure(e.toString()));
    }
  }
}
