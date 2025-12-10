/// File: lib/admin/features/offers/bloc/offer_detail_bloc.dart
/// Purpose: Offer detail BLoC for single offer actions
/// Belongs To: admin/features/offers
library;

import 'package:bloc/bloc.dart';

import '../repository/offers_repository.dart';
import 'offer_detail_event.dart';
import 'offer_detail_state.dart';

/// Handles offer detail state and actions.
class OfferDetailBloc extends Bloc<OfferDetailEvent, OfferDetailState> {
  OfferDetailBloc({required this.repository})
      : super(const OfferDetailState()) {
    on<LoadOfferDetail>(_onLoadOfferDetail);
    on<UpdateOffer>(_onUpdateOffer);
    on<DeleteOffer>(_onDeleteOffer);
    on<ActivateOffer>(_onActivateOffer);
    on<DeactivateOffer>(_onDeactivateOffer);
  }

  final OffersRepository repository;

  Future<void> _onLoadOfferDetail(
    LoadOfferDetail event,
    Emitter<OfferDetailState> emit,
  ) async {
    emit(state.copyWith(status: OfferDetailStatus.loading));

    try {
      final offer = await repository.fetchOfferById(event.offerId);
      emit(state.copyWith(status: OfferDetailStatus.loaded, offer: offer));
    } catch (e) {
      emit(
        state.copyWith(status: OfferDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onUpdateOffer(
    UpdateOffer event,
    Emitter<OfferDetailState> emit,
  ) async {
    emit(state.copyWith(status: OfferDetailStatus.processing));

    try {
      final updated = await repository.updateOffer(event.offer);

      emit(
        state.copyWith(
          status: OfferDetailStatus.loaded,
          offer: updated,
          successMessage: 'Offer updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: OfferDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onDeleteOffer(
    DeleteOffer event,
    Emitter<OfferDetailState> emit,
  ) async {
    emit(state.copyWith(status: OfferDetailStatus.processing));

    try {
      await repository.deleteOffer(event.offerId);

      emit(
        state.copyWith(
          status: OfferDetailStatus.loaded,
          successMessage: 'Offer deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: OfferDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onActivateOffer(
    ActivateOffer event,
    Emitter<OfferDetailState> emit,
  ) async {
    emit(state.copyWith(status: OfferDetailStatus.processing));

    try {
      final updated = await repository.activateOffer(event.offerId);

      emit(
        state.copyWith(
          status: OfferDetailStatus.loaded,
          offer: updated,
          successMessage: 'Offer activated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: OfferDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onDeactivateOffer(
    DeactivateOffer event,
    Emitter<OfferDetailState> emit,
  ) async {
    emit(state.copyWith(status: OfferDetailStatus.processing));

    try {
      final updated = await repository.deactivateOffer(event.offerId);

      emit(
        state.copyWith(
          status: OfferDetailStatus.loaded,
          offer: updated,
          successMessage: 'Offer deactivated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: OfferDetailStatus.error, error: e.toString()),
      );
    }
  }
}
