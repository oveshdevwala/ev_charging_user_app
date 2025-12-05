/// File: lib/features/profile/bloc/profile_event.dart
/// Purpose: Profile BLoC events
/// Belongs To: profile feature
library;

import '../models/models.dart';

/// Base class for profile events.
abstract class ProfileEvent {
  const ProfileEvent();
}

/// Load user profile event.
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Update user profile event.
class UpdateProfile extends ProfileEvent {
  const UpdateProfile(this.profile);

  final UserProfileModel profile;
}

/// Update avatar event.
class UpdateAvatar extends ProfileEvent {
  const UpdateAvatar(this.imagePath);

  final String imagePath;
}

/// Clear profile error event.
class ClearProfileError extends ProfileEvent {
  const ClearProfileError();
}

