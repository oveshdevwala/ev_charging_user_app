/// File: lib/features/nearby_offers/presentation/blocs/offer_redeem/offer_redeem_event.dart
/// Purpose: Events for Offer Redeem BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

abstract class OfferRedeemEvent extends Equatable {
  const OfferRedeemEvent();

  @override
  List<Object?> get props => [];
}

/// Start redemption process.
class RedeemOffer extends OfferRedeemEvent {
  const RedeemOffer({required this.offerId, required this.userId});

  final String offerId;
  final String userId;

  @override
  List<Object?> get props => [offerId, userId];
}

/// Refresh QR code.
class RefreshQrCode extends OfferRedeemEvent {
  const RefreshQrCode(this.redemptionId);

  final String redemptionId;

  @override
  List<Object?> get props => [redemptionId];
}

/// Reset state.
class ResetRedemption extends OfferRedeemEvent {
  const ResetRedemption();
}
