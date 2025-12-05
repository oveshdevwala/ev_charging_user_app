/// File: lib/features/profile/bloc/auth_security_state.dart
/// Purpose: Authentication and security BLoC state
/// Belongs To: profile feature
library;

import 'package:equatable/equatable.dart';

/// Authentication and security state.
class AuthSecurityState extends Equatable {
  const AuthSecurityState({
    this.isLoading = false,
    this.isReauthenticating = false,
    this.isDeleting = false,
    this.isReauthenticated = false,
    this.isAccountDeleted = false,
    this.is2FAEnabled = false,
    this.error,
    this.successMessage,
  });

  /// Initial state.
  factory AuthSecurityState.initial() => const AuthSecurityState();

  final bool isLoading;
  final bool isReauthenticating;
  final bool isDeleting;
  final bool isReauthenticated;
  final bool isAccountDeleted;
  final bool is2FAEnabled;
  final String? error;
  final String? successMessage;

  /// Copy with new values.
  AuthSecurityState copyWith({
    bool? isLoading,
    bool? isReauthenticating,
    bool? isDeleting,
    bool? isReauthenticated,
    bool? isAccountDeleted,
    bool? is2FAEnabled,
    String? error,
    String? successMessage,
  }) {
    return AuthSecurityState(
      isLoading: isLoading ?? this.isLoading,
      isReauthenticating: isReauthenticating ?? this.isReauthenticating,
      isDeleting: isDeleting ?? this.isDeleting,
      isReauthenticated: isReauthenticated ?? this.isReauthenticated,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
      is2FAEnabled: is2FAEnabled ?? this.is2FAEnabled,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isReauthenticating,
        isDeleting,
        isReauthenticated,
        isAccountDeleted,
        is2FAEnabled,
        error,
        successMessage,
      ];
}

