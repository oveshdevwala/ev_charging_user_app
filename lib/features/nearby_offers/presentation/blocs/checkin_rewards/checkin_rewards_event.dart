/// File: lib/features/nearby_offers/presentation/blocs/checkin_rewards/checkin_rewards_event.dart
/// Purpose: Events for Check-in Rewards BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

abstract class CheckInRewardsEvent extends Equatable {
  const CheckInRewardsEvent();

  @override
  List<Object?> get props => [];
}

/// Perform check-in at partner.
class PerformCheckIn extends CheckInRewardsEvent {
  const PerformCheckIn({
    required this.partnerId,
    required this.userId,
    required this.userLatitude,
    required this.userLongitude,
  });

  final String partnerId;
  final String userId;
  final double userLatitude;
  final double userLongitude;

  @override
  List<Object?> get props => [partnerId, userId, userLatitude, userLongitude];
}

/// Reset check-in state (e.g., after success dialog).
class ResetCheckIn extends CheckInRewardsEvent {
  const ResetCheckIn();
}
