/// File: lib/features/profile/bloc/profile_state.dart
/// Purpose: Profile BLoC state
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new state fields as needed
///    - Update copyWith accordingly
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Profile state class with Equatable and copyWith.
class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploadingAvatar = false,
    this.profile,
    this.error,
  });

  /// Initial state.
  factory ProfileState.initial() => const ProfileState();

  final bool isLoading;
  final bool isUpdating;
  final bool isUploadingAvatar;
  final UserProfileModel? profile;
  final String? error;

  /// Copy with new values.
  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isUploadingAvatar,
    UserProfileModel? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isUpdating,
        isUploadingAvatar,
        profile,
        error,
      ];
}

