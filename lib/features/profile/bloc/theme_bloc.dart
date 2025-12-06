/// File: lib/features/profile/bloc/theme_bloc.dart
/// Purpose: Theme management BLoC
/// Belongs To: profile feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/theme_manager.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// Theme BLoC for managing theme preferences.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    required ProfileRepository repository,
    required SharedPreferences prefs,
  }) : _repository = repository,
       _prefs = prefs,
       super(ThemeState.initial()) {
    on<LoadTheme>(_onLoadTheme);
    on<SetThemeMode>(_onSetThemeMode);
  }

  final ProfileRepository _repository;
  final SharedPreferences _prefs;

  static const String _themeKey = 'theme_mode';

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Load from local storage first - handle both int and String (migration)
      var themeMode = ThemeModeOption.system;
      if (_prefs.containsKey(_themeKey)) {
        final value = _prefs.get(_themeKey);
        if (value is String) {
          // New format: stored as string
          themeMode = ThemeModeOption.values.firstWhere(
            (e) => e.name == value,
            orElse: () => ThemeModeOption.system,
          );
        } else if (value is int) {
          // Old format: stored as int (from ThemeManager)
          // Map ThemeMode enum to ThemeModeOption
          if (value >= 0 && value < 3) {
            switch (value) {
              case 0: // ThemeMode.system
                themeMode = ThemeModeOption.system;
                break;
              case 1: // ThemeMode.light
                themeMode = ThemeModeOption.light;
                break;
              case 2: // ThemeMode.dark
                themeMode = ThemeModeOption.dark;
                break;
            }
            // Migrate to string format
            await _prefs.setString(_themeKey, themeMode.name);
          }
        }
      }

      // Load from server preferences if available
      try {
        final profile = await _repository.getProfile();
        final serverTheme = profile.preferences?.themeMode;
        if (serverTheme != null) {
          themeMode = serverTheme;
          await _prefs.setString(_themeKey, serverTheme.name);
        }
      } catch (_) {
        // Server fetch failed, use local value
      }

      emit(state.copyWith(isLoading: false, themeMode: themeMode));
    } catch (e) {
      // Fallback to system mode
      emit(
        state.copyWith(
          isLoading: false,
          themeMode: ThemeModeOption.system,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSetThemeMode(
    SetThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Save to local storage
      await _prefs.setString(_themeKey, event.themeMode.name);

      // Update server preferences
      final profile = await _repository.getProfile();
      final updatedPreferences =
          (profile.preferences ?? const UserPreferencesModel()).copyWith(
            themeMode: event.themeMode,
          );
      await _repository.updatePreferences(updatedPreferences);

      // Update ThemeManager to sync with app theme
      try {
        final themeManager = sl<ThemeManager>();
        switch (event.themeMode) {
          case ThemeModeOption.system:
            await themeManager.setSystemMode();
            break;
          case ThemeModeOption.light:
            await themeManager.setLightMode();
            break;
          case ThemeModeOption.dark:
            await themeManager.setDarkMode();
            break;
        }
      } catch (_) {
        // ThemeManager update failed, but continue
      }

      emit(state.copyWith(isLoading: false, themeMode: event.themeMode));
    } catch (e) {
      // Still save locally even if server update fails
      await _prefs.setString(_themeKey, event.themeMode.name);

      // Still update ThemeManager
      try {
        final themeManager = sl<ThemeManager>();
        switch (event.themeMode) {
          case ThemeModeOption.system:
            await themeManager.setSystemMode();
            break;
          case ThemeModeOption.light:
            await themeManager.setLightMode();
            break;
          case ThemeModeOption.dark:
            await themeManager.setDarkMode();
            break;
        }
      } catch (_) {
        // ThemeManager update failed
      }

      emit(
        state.copyWith(
          isLoading: false,
          themeMode: event.themeMode,
          error: e.toString(),
        ),
      );
    }
  }
}
