/// File: lib/features/nearby_offers/presentation/blocs/partner_detail/partner_detail_bloc.dart
/// Purpose: BLoC for managing partner details
/// Belongs To: nearby_offers feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/partner_repository.dart';
import 'partner_detail_event.dart';
import 'partner_detail_state.dart';

class PartnerDetailBloc extends Bloc<PartnerDetailEvent, PartnerDetailState> {
  PartnerDetailBloc({required PartnerRepository partnerRepository})
    : _partnerRepository = partnerRepository,
      super(const PartnerDetailState()) {
    on<LoadPartnerDetail>(_onLoadPartnerDetail);
    on<RefreshPartnerDetail>(_onRefreshPartnerDetail);
  }

  final PartnerRepository _partnerRepository;

  Future<void> _onLoadPartnerDetail(
    LoadPartnerDetail event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(status: PartnerDetailStatus.loading));

    try {
      final partnerFuture = _partnerRepository.fetchPartnerById(
        event.partnerId,
      );
      final offersFuture = _partnerRepository.fetchPartnerOffers(
        event.partnerId,
      );

      final partner = await partnerFuture;
      final offers = await offersFuture;

      if (partner == null) {
        emit(
          state.copyWith(
            status: PartnerDetailStatus.error,
            errorMessage: 'Partner not found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: PartnerDetailStatus.loaded,
          partner: partner,
          offers: offers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnerDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshPartnerDetail(
    RefreshPartnerDetail event,
    Emitter<PartnerDetailState> emit,
  ) async {
    try {
      final partnerFuture = _partnerRepository.fetchPartnerById(
        event.partnerId,
      );
      final offersFuture = _partnerRepository.fetchPartnerOffers(
        event.partnerId,
      );

      final partner = await partnerFuture;
      final offers = await offersFuture;

      if (partner != null) {
        emit(
          state.copyWith(
            status: PartnerDetailStatus.loaded,
            partner: partner,
            offers: offers,
          ),
        );
      }
    } catch (e) {
      // Keep existing state on refresh error
    }
  }
}
