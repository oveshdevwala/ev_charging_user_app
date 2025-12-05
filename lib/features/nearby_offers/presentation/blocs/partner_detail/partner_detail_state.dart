/// File: lib/features/nearby_offers/presentation/blocs/partner_detail/partner_detail_state.dart
/// Purpose: State for Partner Detail BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/models/partner_model.dart';
import '../../../data/models/partner_offer_model.dart';

enum PartnerDetailStatus { initial, loading, loaded, error }

class PartnerDetailState extends Equatable {
  const PartnerDetailState({
    this.status = PartnerDetailStatus.initial,
    this.partner,
    this.offers = const [],
    this.errorMessage,
  });

  final PartnerDetailStatus status;
  final PartnerModel? partner;
  final List<PartnerOfferModel> offers;
  final String? errorMessage;

  PartnerDetailState copyWith({
    PartnerDetailStatus? status,
    PartnerModel? partner,
    List<PartnerOfferModel>? offers,
    String? errorMessage,
  }) {
    return PartnerDetailState(
      status: status ?? this.status,
      partner: partner ?? this.partner,
      offers: offers ?? this.offers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, partner, offers, errorMessage];
}
