/// File: lib/features/nearby_offers/domain/usecases/check_in_partner_usecase.dart
/// Purpose: Usecase to check in at a partner location
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/features/nearby_offers/data/models/check_in_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/models/redemption_model.dart';
import 'package:ev_charging_user_app/features/nearby_offers/data/repositories/partner_repository.dart';

class CheckInPartnerUseCase {
  CheckInPartnerUseCase(this._repository);

  final PartnerRepository _repository;

  Future<CheckInModel> call({
    required String partnerId,
    required String userId,
    required double userLatitude,
    required double userLongitude,
  }) {
    return _repository.checkInAtPartner(
      partnerId: partnerId,
      userId: userId,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
    );
  }
}
