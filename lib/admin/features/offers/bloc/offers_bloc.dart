/// File: lib/admin/features/offers/bloc/offers_bloc.dart
/// Purpose: Offers list BLoC handling load/search/pagination/filter/bulk actions
/// Belongs To: admin/features/offers
library;

import 'package:bloc/bloc.dart';

import '../repository/offers_local_mock.dart';
import '../repository/offers_repository.dart';
import 'offers_event.dart';
import 'offers_state.dart';

/// Handles offers list state with pagination, search, filters, and bulk actions.
class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc({required this.repository}) : super(const OffersState()) {
    on<LoadOffers>(_onLoadOffers);
    on<SearchOffers>(_onSearchOffers);
    on<ChangePage>(_onChangePage);
    on<ChangePageSize>(_onChangePageSize);
    on<ToggleSelectOffer>(_onToggleSelectOffer);
    on<SelectAllOffers>(_onSelectAllOffers);
    on<ClearSelection>(_onClearSelection);
    on<ApplyFilters>(_onApplyFilters);
    on<ResetFilters>(_onResetFilters);
    on<BulkAction>(_onBulkAction);
    on<RefreshOffers>(_onRefreshOffers);
    on<DeleteOfferFromList>(_onDeleteOffer);
    on<ActivateOfferFromList>(_onActivateOffer);
    on<DeactivateOfferFromList>(_onDeactivateOffer);
  }

  final OffersRepository repository;

  Future<void> _onLoadOffers(
    LoadOffers event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: OffersStatus.loading));

    try {
      // Build filters from state and event
      final filters =
          event.filters ??
          OfferFilters(
            status: state.filters?.status,
            discountType: state.filters?.discountType,
            search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
            sortBy: state.filters?.sortBy,
            order: state.filters?.order ?? 'asc',
          );

      final response = await repository.fetchOffers(
        page: event.page,
        perPage: event.perPage,
        filters: filters,
        forceRefresh: event.forceRefresh,
      );

      emit(
        state.copyWith(
          status: OffersStatus.loaded,
          items: response.items,
          total: response.total,
          page: response.page,
          perPage: response.perPage,
          filters: filters,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.error, error: e.toString()));
    }
  }

  void _onSearchOffers(SearchOffers event, Emitter<OffersState> emit) {
    final filters = OfferFilters(
      status: state.filters?.status,
      discountType: state.filters?.discountType,
      search: event.query.isNotEmpty ? event.query : null,
      sortBy: state.filters?.sortBy,
      order: state.filters?.order ?? 'asc',
    );

    add(LoadOffers(perPage: state.perPage, filters: filters));
  }

  void _onChangePage(ChangePage event, Emitter<OffersState> emit) {
    add(
      LoadOffers(
        page: event.page,
        perPage: state.perPage,
        filters: state.filters,
      ),
    );
  }

  void _onChangePageSize(ChangePageSize event, Emitter<OffersState> emit) {
    add(LoadOffers(perPage: event.perPage, filters: state.filters));
  }

  void _onToggleSelectOffer(
    ToggleSelectOffer event,
    Emitter<OffersState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedIds);
    if (newSelection.contains(event.offerId)) {
      newSelection.remove(event.offerId);
    } else {
      newSelection.add(event.offerId);
    }

    emit(state.copyWith(selectedIds: newSelection));
  }

  void _onSelectAllOffers(SelectAllOffers event, Emitter<OffersState> emit) {
    final allIds = state.items.map((o) => o.id).toSet();
    emit(state.copyWith(selectedIds: allIds));
  }

  void _onClearSelection(ClearSelection event, Emitter<OffersState> emit) {
    emit(state.copyWith(selectedIds: {}));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<OffersState> emit) {
    add(LoadOffers(perPage: state.perPage, filters: event.filters));
  }

  void _onResetFilters(ResetFilters event, Emitter<OffersState> emit) {
    add(LoadOffers(perPage: state.perPage));
  }

  Future<void> _onBulkAction(
    BulkAction event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: OffersStatus.loading));

    try {
      for (final offerId in event.offerIds) {
        switch (event.action) {
          case BulkActionType.activate:
            await repository.activateOffer(offerId);
            break;
          case BulkActionType.deactivate:
            await repository.deactivateOffer(offerId);
            break;
          case BulkActionType.delete:
            await repository.deleteOffer(offerId);
            break;
          case BulkActionType.export:
            // Export handled separately
            break;
        }
      }

      emit(
        state.copyWith(
          status: OffersStatus.actionSuccess,
          successMessage: 'Bulk action completed',
          selectedIds: {},
        ),
      );

      // Reload offers
      add(
        LoadOffers(
          page: state.page,
          perPage: state.perPage,
          filters: state.filters,
          forceRefresh: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRefreshOffers(
    RefreshOffers event,
    Emitter<OffersState> emit,
  ) async {
    add(
      LoadOffers(
        page: state.page,
        perPage: state.perPage,
        filters: state.filters,
        forceRefresh: true,
      ),
    );
  }

  Future<void> _onDeleteOffer(
    DeleteOfferFromList event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: OffersStatus.loading));

    try {
      await repository.deleteOffer(event.offerId);

      emit(
        state.copyWith(
          status: OffersStatus.actionSuccess,
          successMessage: 'Offer deleted successfully',
        ),
      );

      // Reload offers
      add(
        LoadOffers(
          page: state.page,
          perPage: state.perPage,
          filters: state.filters,
          forceRefresh: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.error, error: e.toString()));
    }
  }

  Future<void> _onActivateOffer(
    ActivateOfferFromList event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: OffersStatus.loading));

    try {
      await repository.activateOffer(event.offerId);

      emit(
        state.copyWith(
          status: OffersStatus.actionSuccess,
          successMessage: 'Offer activated successfully',
        ),
      );

      // Reload offers
      add(
        LoadOffers(
          page: state.page,
          perPage: state.perPage,
          filters: state.filters,
          forceRefresh: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeactivateOffer(
    DeactivateOfferFromList event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: OffersStatus.loading));

    try {
      await repository.deactivateOffer(event.offerId);

      emit(
        state.copyWith(
          status: OffersStatus.actionSuccess,
          successMessage: 'Offer deactivated successfully',
        ),
      );

      // Reload offers
      add(
        LoadOffers(
          page: state.page,
          perPage: state.perPage,
          filters: state.filters,
          forceRefresh: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.error, error: e.toString()));
    }
  }
}
