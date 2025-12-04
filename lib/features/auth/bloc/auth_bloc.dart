/// File: lib/features/auth/bloc/auth_bloc.dart
/// Purpose: Authentication BLoC for managing auth state
/// Belongs To: auth feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );

    if (result.success && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      emit(AuthState.error(result.error ?? 'Login failed'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final result = await _authRepository.register(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      phone: event.phone,
    );

    if (result.success && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      emit(AuthState.error(result.error ?? 'Registration failed'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    await _authRepository.logout();
    emit(AuthState.initial());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final user = await _authRepository.getCurrentUser();

    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(AuthState.initial());
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final success = await _authRepository.forgotPassword(event.email);

    if (success) {
      emit(state.copyWith(isLoading: false));
    } else {
      emit(AuthState.error('Failed to send reset email'));
    }
  }
}

