/// File: lib/features/nearby_offers/domain/usecases/get_partners_usecase.dart
/// Purpose: Usecase to fetch partners list
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/features/nearby_offers/data/models/partner_category.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/models/partner_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/repositories/partner_repository.dart';

class GetPartnersUseCase {
  GetPartnersUseCase(this._repository);

  final PartnerRepository _repository;

  Future<List<PartnerModel>> call({
    PartnerCategory? category,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.fetchPartners(
      category: category,
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }
}
