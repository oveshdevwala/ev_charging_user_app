/// File: lib/features/nearby_offers/domain/usecases/get_offer_history_usecase.dart
/// Purpose: Usecase to fetch offer redemption history
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/features/nearby_offers/data/models/partner_offer_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/models/redemption_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/repositories/partner_repository.dart';

class GetOfferHistoryUseCase {
  GetOfferHistoryUseCase(this._repository);

  final PartnerRepository _repository;

  Future<List<RedemptionModel>> call({
    required String userId,
    OfferStatus? status,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.fetchRedemptionHistory(
      userId: userId,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
