/// File: lib/features/profile/bloc/auth_security_event.dart
/// Purpose: Authentication and security BLoC events
/// Belongs To: profile feature
library;

/// Base class for auth security events.
abstract class AuthSecurityEvent {
  const AuthSecurityEvent();
}

/// Change password event.
class ChangePassword extends AuthSecurityEvent {
  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}

/// Toggle 2FA event.
class Toggle2FA extends AuthSecurityEvent {
  const Toggle2FA(this.enable);

  final bool enable;
}

/// Re-authenticate event.
class Reauthenticate extends AuthSecurityEvent {
  const Reauthenticate(this.password);

  final String password;
}

/// Delete account event.
class DeleteAccount extends AuthSecurityEvent {
  const DeleteAccount(this.reason);

  final String reason;
}

/// Clear auth error event.
class ClearAuthError extends AuthSecurityEvent {
  const ClearAuthError();
}

