/// File: lib/features/auth/bloc/auth_state.dart
/// Purpose: Authentication state for BLoC
/// Belongs To: auth feature
library;

import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';

/// Authentication state.
class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  /// Initial state.
  factory AuthState.initial() => const AuthState();

  /// Loading state.
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// Authenticated state.
  factory AuthState.authenticated(UserModel user) => AuthState(
        isAuthenticated: true,
        user: user,
      );

  /// Error state.
  factory AuthState.error(String message) => AuthState(error: message);

  /// Copy with new values.
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isAuthenticated, user, error];
}

