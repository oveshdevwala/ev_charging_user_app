/// File: lib/admin/features/offers/bloc/offer_detail_event.dart
/// Purpose: Events for offer detail BLoC
/// Belongs To: admin/features/offers
library;

import 'package:equatable/equatable.dart';

import '../models/offer_model.dart';

/// Base class for offer detail events.
abstract class OfferDetailEvent extends Equatable {
  const OfferDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load offer detail.
class LoadOfferDetail extends OfferDetailEvent {
  const LoadOfferDetail(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Update offer.
class UpdateOffer extends OfferDetailEvent {
  const UpdateOffer(this.offer);

  final OfferModel offer;

  @override
  List<Object?> get props => [offer];
}

/// Delete offer.
class DeleteOffer extends OfferDetailEvent {
  const DeleteOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Activate offer.
class ActivateOffer extends OfferDetailEvent {
  const ActivateOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Deactivate offer.
class DeactivateOffer extends OfferDetailEvent {
  const DeactivateOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}
