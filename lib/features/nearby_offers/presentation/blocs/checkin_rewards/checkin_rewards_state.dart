/// File: lib/features/nearby_offers/presentation/blocs/checkin_rewards/checkin_rewards_state.dart
/// Purpose: State for Check-in Rewards BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/models/check_in_model.dart';

enum CheckInStatus { initial, loading, success, failure }

class CheckInRewardsState extends Equatable {
  const CheckInRewardsState({
    this.status = CheckInStatus.initial,
    this.checkInResult,
    this.errorMessage,
  });

  final CheckInStatus status;
  final CheckInModel? checkInResult;
  final String? errorMessage;

  CheckInRewardsState copyWith({
    CheckInStatus? status,
    CheckInModel? checkInResult,
    String? errorMessage,
  }) {
    return CheckInRewardsState(
      status: status ?? this.status,
      checkInResult: checkInResult ?? this.checkInResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, checkInResult, errorMessage];
}
