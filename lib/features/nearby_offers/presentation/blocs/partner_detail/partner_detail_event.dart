/// File: lib/features/nearby_offers/presentation/blocs/partner_detail/partner_detail_event.dart
/// Purpose: Events for Partner Detail BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

abstract class PartnerDetailEvent extends Equatable {
  const PartnerDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load partner details.
class LoadPartnerDetail extends PartnerDetailEvent {
  const LoadPartnerDetail(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Refresh partner details.
class RefreshPartnerDetail extends PartnerDetailEvent {
  const RefreshPartnerDetail(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}
