/// File: lib/admin/features/offers/bloc/offer_detail_state.dart
/// Purpose: State definitions for offer detail BLoC
/// Belongs To: admin/features/offers
library;

import 'package:equatable/equatable.dart';

import '../models/offer_model.dart';

/// Lifecycle status for offer detail.
enum OfferDetailStatus { initial, loading, loaded, processing, error }

/// State for [OfferDetailBloc].
class OfferDetailState extends Equatable {
  const OfferDetailState({
    this.status = OfferDetailStatus.initial,
    this.offer,
    this.error,
    this.successMessage,
  });

  final OfferDetailStatus status;
  final OfferModel? offer;
  final String? error;
  final String? successMessage;

  bool get isLoading => status == OfferDetailStatus.loading;
  bool get isProcessing => status == OfferDetailStatus.processing;

  OfferDetailState copyWith({
    OfferDetailStatus? status,
    OfferModel? offer,
    String? error,
    String? successMessage,
  }) {
    return OfferDetailState(
      status: status ?? this.status,
      offer: offer ?? this.offer,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        offer,
        error,
        successMessage,
      ];
}
