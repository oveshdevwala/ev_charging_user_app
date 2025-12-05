/// File: lib/features/profile/bloc/language_bloc.dart
/// Purpose: Language management BLoC
/// Belongs To: profile feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'language_event.dart';
import 'language_state.dart';

/// Language BLoC for managing language preferences.
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({
    required ProfileRepository repository,
    required SharedPreferences prefs,
  })  : _repository = repository,
        _prefs = prefs,
        super(LanguageState.initial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<SetLanguage>(_onSetLanguage);
  }

  final ProfileRepository _repository;
  final SharedPreferences _prefs;

  static const String _languageKey = 'app_language';

  Future<void> _onLoadLanguage(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Load from local storage first
      final savedLanguage = _prefs.getString(_languageKey) ?? 'en';

      // Load from server preferences if available
      final profile = await _repository.getProfile();
      final serverLanguage = profile.preferences?.language ?? savedLanguage;

      await _prefs.setString(_languageKey, serverLanguage);

      emit(state.copyWith(
        isLoading: false,
        language: serverLanguage,
      ));
    } catch (e) {
      // Fallback to local storage
      final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
      emit(state.copyWith(
        isLoading: false,
        language: savedLanguage,
      ));
    }
  }

  Future<void> _onSetLanguage(
    SetLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Save to local storage
      await _prefs.setString(_languageKey, event.language);

      // Update server preferences
      final profile = await _repository.getProfile();
      final updatedPreferences = (profile.preferences ?? const UserPreferencesModel())
          .copyWith(language: event.language);
      await _repository.updatePreferences(updatedPreferences);

      emit(state.copyWith(
        isLoading: false,
        language: event.language,
      ));
    } catch (e) {
      // Still save locally even if server update fails
      await _prefs.setString(_languageKey, event.language);
      emit(state.copyWith(
        isLoading: false,
        language: event.language,
        error: e.toString(),
      ));
    }
  }
}

