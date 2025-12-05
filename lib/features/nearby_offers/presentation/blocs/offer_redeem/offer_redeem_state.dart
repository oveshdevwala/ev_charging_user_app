/// File: lib/features/nearby_offers/presentation/blocs/offer_redeem/offer_redeem_state.dart
/// Purpose: State for Offer Redeem BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/models/redemption_model.dart';

enum RedeemStatus { initial, loading, success, failure }

class OfferRedeemState extends Equatable {
  const OfferRedeemState({
    this.status = RedeemStatus.initial,
    this.redemption,
    this.errorMessage,
  });

  final RedeemStatus status;
  final RedemptionModel? redemption;
  final String? errorMessage;

  OfferRedeemState copyWith({
    RedeemStatus? status,
    RedemptionModel? redemption,
    String? errorMessage,
  }) {
    return OfferRedeemState(
      status: status ?? this.status,
      redemption: redemption ?? this.redemption,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, redemption, errorMessage];
}
