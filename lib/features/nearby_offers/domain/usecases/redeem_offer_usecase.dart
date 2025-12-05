/// File: lib/features/nearby_offers/domain/usecases/redeem_offer_usecase.dart
/// Purpose: Usecase to redeem an offer
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/features/nearby_offers/data/models/redemption_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/repositories/partner_repository.dart';


class RedeemOfferUseCase {
  RedeemOfferUseCase(this._repository);

  final PartnerRepository _repository;

  Future<RedemptionModel> call({
    required String offerId,
    required String userId,
  }) {
    return _repository.redeemOffer(offerId: offerId, userId: userId);
  }
}
