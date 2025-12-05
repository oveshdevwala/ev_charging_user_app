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
      // Load from local storage first
      final savedTheme = _prefs.getString(_themeKey);
      var themeMode = ThemeModeOption.system;
      if (savedTheme != null) {
        themeMode = ThemeModeOption.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeModeOption.system,
        );
      }

      // Load from server preferences if available
      final profile = await _repository.getProfile();
      final serverTheme = profile.preferences?.themeMode ?? themeMode;

      await _prefs.setString(_themeKey, serverTheme.name);

      emit(state.copyWith(isLoading: false, themeMode: serverTheme));
    } catch (e) {
      // Fallback to local storage
      final savedTheme = _prefs.getString(_themeKey);
      var themeMode = ThemeModeOption.system;
      if (savedTheme != null) {
        themeMode = ThemeModeOption.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeModeOption.system,
        );
      }
      emit(state.copyWith(isLoading: false, themeMode: themeMode));
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
