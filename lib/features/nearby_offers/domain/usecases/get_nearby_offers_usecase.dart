/// File: lib/features/nearby_offers/domain/usecases/get_nearby_offers_usecase.dart
/// Purpose: Usecase to fetch nearby offers with filters
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/features/nearby_offers/data/repositories/partner_repository.dart';

import '../../data/datasources/partner_remote_datasource.dart';
import '../../data/models/partner_offer_model.dart';
class GetNearbyOffersUseCase {
  GetNearbyOffersUseCase(this._repository);

  final PartnerRepository _repository;

  Future<List<PartnerOfferModel>> call(OfferFilterParams params) {
    return _repository.fetchNearbyOffers(params);
  }
}
