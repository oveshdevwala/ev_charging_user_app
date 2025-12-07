/// File: lib/features/settings/presentation/blocs/security_bloc.dart
/// Purpose: Security BLoC for PIN and biometric settings
/// Belongs To: settings feature
/// Customization Guide:
///    - Integrate with local_auth for biometrics
///    - Use proper hashing for PIN storage
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

// ============================================================
// EVENTS
// ============================================================

/// Security events.
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

/// Enable biometrics event.
class EnableBiometrics extends SecurityEvent {
  const EnableBiometrics();
}

/// Disable biometrics event.
class DisableBiometrics extends SecurityEvent {
  const DisableBiometrics();
}

/// Set PIN event.
class SetPin extends SecurityEvent {
  const SetPin(this.pin);
  final String pin;

  @override
  List<Object?> get props => [pin];
}

/// Verify PIN event.
class VerifyPin extends SecurityEvent {
  const VerifyPin(this.pin);
  final String pin;

  @override
  List<Object?> get props => [pin];
}

/// Change session timeout event.
class ChangeSessionTimeout extends SecurityEvent {
  const ChangeSessionTimeout(this.minutes);
  final int minutes;

  @override
  List<Object?> get props => [minutes];
}

// ============================================================
// STATES
// ============================================================

/// Security states.
abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

/// Security updated state.
class SecurityUpdated extends SecurityState {
  const SecurityUpdated(this.security);
  final SecuritySettings security;

  @override
  List<Object?> get props => [security];
}

/// PIN verified state.
class PinVerified extends SecurityState {
  const PinVerified();
}

/// PIN verification failed state.
class PinVerificationFailed extends SecurityState {
  const PinVerificationFailed();
}

/// Security failure state.
class SecurityFailure extends SecurityState {
  const SecurityFailure(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

// ============================================================
// BLOC
// ============================================================

/// Security BLoC.
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc({required SettingsRepository repository})
      : _repository = repository,
        super(const SecurityUpdated(SecuritySettings())) {
    on<EnableBiometrics>(_onEnableBiometrics);
    on<DisableBiometrics>(_onDisableBiometrics);
    on<SetPin>(_onSetPin);
    on<VerifyPin>(_onVerifyPin);
    on<ChangeSessionTimeout>(_onChangeSessionTimeout);

    // Load initial security settings
    _loadInitialSettings();
  }

  final SettingsRepository _repository;

  Future<void> _loadInitialSettings() async {
    try {
      final settings = await _repository.load();
      emit(SecurityUpdated(settings.security));
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }

  /// Hash PIN using SHA-256 with salt.
  String _hashPin(String pin) {
    // In production, use a proper salt stored securely
    const salt = 'ev_charging_app_salt'; // Should be stored securely
    final bytes = utf8.encode('$pin$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _onEnableBiometrics(
    EnableBiometrics event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedSecurity = currentSettings.security.copyWith(
        biometricsEnabled: true,
      );

      final updatedSettings = currentSettings.copyWith(
        security: updatedSecurity,
      );
      await _repository.save(updatedSettings);

      emit(SecurityUpdated(updatedSecurity));
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }

  Future<void> _onDisableBiometrics(
    DisableBiometrics event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedSecurity = currentSettings.security.copyWith(
        biometricsEnabled: false,
      );

      final updatedSettings = currentSettings.copyWith(
        security: updatedSecurity,
      );
      await _repository.save(updatedSettings);

      emit(SecurityUpdated(updatedSecurity));
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }

  Future<void> _onSetPin(
    SetPin event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      if (event.pin.length < 4) {
        emit(const SecurityFailure('PIN must be at least 4 digits'));
        return;
      }

      final pinHash = _hashPin(event.pin);
      final currentSettings = await _repository.load();
      final updatedSecurity = currentSettings.security.copyWith(
        pinHash: pinHash,
      );

      final updatedSettings = currentSettings.copyWith(
        security: updatedSecurity,
      );
      await _repository.save(updatedSettings);

      emit(SecurityUpdated(updatedSecurity));
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }

  Future<void> _onVerifyPin(
    VerifyPin event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final storedPinHash = currentSettings.security.pinHash;

      if (storedPinHash == null) {
        emit(const PinVerificationFailed());
        return;
      }

      final inputPinHash = _hashPin(event.pin);
      if (inputPinHash == storedPinHash) {
        emit(const PinVerified());
      } else {
        emit(const PinVerificationFailed());
      }
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }

  Future<void> _onChangeSessionTimeout(
    ChangeSessionTimeout event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final currentSettings = await _repository.load();
      final updatedSecurity = currentSettings.security.copyWith(
        sessionTimeoutMinutes: event.minutes,
      );

      final updatedSettings = currentSettings.copyWith(
        security: updatedSecurity,
      );
      await _repository.save(updatedSettings);

      emit(SecurityUpdated(updatedSecurity));
    } catch (e) {
      emit(SecurityFailure(e.toString()));
    }
  }
}

