/// File: lib/features/nearby_offers/presentation/blocs/offer_redeem/offer_redeem_bloc.dart
/// Purpose: BLoC for managing offer redemption
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/core/services/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/redeem_offer_usecase.dart';
import 'offer_redeem_event.dart';
import 'offer_redeem_state.dart';

class OfferRedeemBloc extends Bloc<OfferRedeemEvent, OfferRedeemState> {
  OfferRedeemBloc({
    required RedeemOfferUseCase redeemOffer,
    required AnalyticsService analyticsService,
  }) : _redeemOffer = redeemOffer,
       _analyticsService = analyticsService,
       super(const OfferRedeemState()) {
    on<RedeemOffer>(_onRedeemOffer);
    on<ResetRedemption>(_onResetRedemption);
  }

  final RedeemOfferUseCase _redeemOffer;
  final AnalyticsService _analyticsService;

  Future<void> _onRedeemOffer(
    RedeemOffer event,
    Emitter<OfferRedeemState> emit,
  ) async {
    emit(state.copyWith(status: RedeemStatus.loading));

    try {
      final redemption = await _redeemOffer(
        offerId: event.offerId,
        userId: event.userId,
      );

      // Log analytics
      await _analyticsService.logOfferRedeemed(
        offerId: redemption.offerId,
        partnerId: redemption.partnerId,
        discountAmount: redemption.discountApplied ?? 0,
      );

      emit(
        state.copyWith(status: RedeemStatus.success, redemption: redemption),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RedeemStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetRedemption(
    ResetRedemption event,
    Emitter<OfferRedeemState> emit,
  ) {
    emit(const OfferRedeemState());
  }
}
