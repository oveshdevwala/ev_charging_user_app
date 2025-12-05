/// File: lib/features/profile/bloc/language_state.dart
/// Purpose: Language BLoC state
/// Belongs To: profile feature
library;

import 'package:equatable/equatable.dart';

/// Language state.
class LanguageState extends Equatable {
  const LanguageState({
    this.isLoading = false,
    this.language = 'en',
    this.error,
  });

  /// Initial state.
  factory LanguageState.initial() => const LanguageState();

  final bool isLoading;
  final String language;
  final String? error;

  /// Copy with new values.
  LanguageState copyWith({
    bool? isLoading,
    String? language,
    String? error,
  }) {
    return LanguageState(
      isLoading: isLoading ?? this.isLoading,
      language: language ?? this.language,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, language, error];
}

