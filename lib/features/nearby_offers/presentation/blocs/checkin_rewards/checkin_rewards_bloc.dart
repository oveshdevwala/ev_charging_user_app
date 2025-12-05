/// File: lib/features/nearby_offers/presentation/blocs/checkin_rewards/checkin_rewards_bloc.dart
/// Purpose: BLoC for managing check-in rewards
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/core/services/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/check_in_partner_usecase.dart';
import 'checkin_rewards_event.dart';
import 'checkin_rewards_state.dart';

class CheckInRewardsBloc
    extends Bloc<CheckInRewardsEvent, CheckInRewardsState> {
  CheckInRewardsBloc({
    required CheckInPartnerUseCase checkInPartner,
    required AnalyticsService analyticsService,
  }) : _checkInPartner = checkInPartner,
       _analyticsService = analyticsService,
       super(const CheckInRewardsState()) {
    on<PerformCheckIn>(_onPerformCheckIn);
    on<ResetCheckIn>(_onResetCheckIn);
  }

  final CheckInPartnerUseCase _checkInPartner;
  final AnalyticsService _analyticsService;

  Future<void> _onPerformCheckIn(
    PerformCheckIn event,
    Emitter<CheckInRewardsState> emit,
  ) async {
    emit(state.copyWith(status: CheckInStatus.loading));

    try {
      final result = await _checkInPartner(
        partnerId: event.partnerId,
        userId: event.userId,
        userLatitude: event.userLatitude,
        userLongitude: event.userLongitude,
      );

      if (result.isSuccess) {
        // Log analytics
        await _analyticsService.logPartnerCheckIn(
          partnerId: result.partnerId,
          partnerName: result.partnerName,
          creditsEarned: result.creditsEarned,
        );

        emit(
          state.copyWith(status: CheckInStatus.success, checkInResult: result),
        );
      } else {
        emit(
          state.copyWith(
            status: CheckInStatus.failure,
            errorMessage: result.validationMessage ?? 'Check-in failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckInStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetCheckIn(ResetCheckIn event, Emitter<CheckInRewardsState> emit) {
    emit(const CheckInRewardsState());
  }
}
