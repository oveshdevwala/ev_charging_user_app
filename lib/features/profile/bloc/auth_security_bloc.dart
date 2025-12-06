/// File: lib/features/profile/bloc/auth_security_bloc.dart
/// Purpose: Authentication and security BLoC
/// Belongs To: profile feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/repositories.dart';
import 'auth_security_event.dart';
import 'auth_security_state.dart';

/// Authentication and security BLoC.
class AuthSecurityBloc extends Bloc<AuthSecurityEvent, AuthSecurityState> {
  AuthSecurityBloc({required ProfileRepository repository})
      : _repository = repository,
        super(AuthSecurityState.initial()) {
    on<ChangePassword>(_onChangePassword);
    on<Toggle2FA>(_onToggle2FA);
    on<Reauthenticate>(_onReauthenticate);
    on<DeleteAccount>(_onDeleteAccount);
    on<ClearAuthError>(_onClearAuthError);
  }

  final ProfileRepository _repository;

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<AuthSecurityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Password changed successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggle2FA(
    Toggle2FA event,
    Emitter<AuthSecurityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // TODO: Implement 2FA toggle with backend
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        isLoading: false,
        is2FAEnabled: event.enable,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onReauthenticate(
    Reauthenticate event,
    Emitter<AuthSecurityState> emit,
  ) async {
    emit(state.copyWith(isReauthenticating: true));
    try {
      final isValid = await _repository.reauthenticate(event.password);
      emit(state.copyWith(
        isReauthenticating: false,
        isReauthenticated: isValid,
        error: isValid ? null : 'Invalid password',
      ));
    } catch (e) {
      emit(state.copyWith(
        isReauthenticating: false,
        isReauthenticated: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthSecurityState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true));
    try {
      await _repository.deleteAccount(event.reason);
      emit(state.copyWith(
        isDeleting: false,
        isAccountDeleted: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isDeleting: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearAuthError(
    ClearAuthError event,
    Emitter<AuthSecurityState> emit,
  ) {
    emit(state.copyWith());
  }
}

