/// File: lib/features/profile/bloc/profile_bloc.dart
/// Purpose: Profile BLoC for managing user profile state
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new events as needed
///    - Handle additional profile operations
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/repositories.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Profile BLoC for managing user profile operations.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<ClearProfileError>(_onClearProfileError);
  }

  final ProfileRepository _repository;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _repository.getProfile();
      emit(state.copyWith(
        isLoading: false,
        profile: profile,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, error: null));
    try {
      final updatedProfile = await _repository.updateProfile(event.profile);
      emit(state.copyWith(
        isUpdating: false,
        profile: updatedProfile,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isUploadingAvatar: true, error: null));
    try {
      final avatarUrl = await _repository.uploadAvatar(event.imagePath);
      final updatedProfile = state.profile?.copyWith(avatarUrl: avatarUrl);
      emit(state.copyWith(
        isUploadingAvatar: false,
        profile: updatedProfile,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploadingAvatar: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearProfileError(
    ClearProfileError event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(error: null));
  }
}

