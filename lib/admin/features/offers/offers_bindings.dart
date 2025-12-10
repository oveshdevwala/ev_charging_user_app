/// File: lib/admin/features/offers/offers_bindings.dart
/// Purpose: Helper factory for wiring blocs/repository for offers module
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Swap repository with API implementation while preserving factory helpers
library;

import 'bloc/offer_detail_bloc.dart';
import 'bloc/offers_bloc.dart';
import 'repository/offers_repository.dart';

/// Simple binding helper to keep bloc creation consistent across routes.
class OffersBindings {
  OffersBindings({OffersRepository? repository})
    : repository = repository ?? OffersRepository();

  /// Shared singleton for module wiring.
  static final OffersBindings instance = OffersBindings();

  final OffersRepository repository;

  OffersBloc offersBloc() => OffersBloc(repository: repository);

  OfferDetailBloc offerDetailBloc() => OfferDetailBloc(repository: repository);
}
