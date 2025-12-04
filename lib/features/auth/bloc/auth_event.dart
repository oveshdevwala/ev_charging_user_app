/// File: lib/features/auth/bloc/auth_event.dart
/// Purpose: Authentication events for BLoC
/// Belongs To: auth feature
library;

import 'package:equatable/equatable.dart';

/// Base class for auth events.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login event.
final class LoginRequested extends AuthEvent {
  const LoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Register event.
final class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });

  final String email;
  final String password;
  final String fullName;
  final String? phone;

  @override
  List<Object?> get props => [email, password, fullName, phone];
}

/// Logout event.
final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Check auth status event.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Forgot password event.
final class ForgotPasswordRequested extends AuthEvent {
  const ForgotPasswordRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

