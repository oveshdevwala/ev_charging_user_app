/// File: lib/admin/features/partners/bloc/partners_bloc.dart
/// Purpose: Partners list BLoC handling load/search/pagination/filter/bulk actions
/// Belongs To: admin/features/partners
library;

import 'package:bloc/bloc.dart';

import '../repository/partners_repository.dart';
import '../repository/partners_requests.dart';
import 'partners_event.dart';
import 'partners_state.dart';

/// Handles partners list state with pagination, search, filters, and bulk actions.
class PartnersBloc extends Bloc<PartnersEvent, PartnersState> {
  PartnersBloc({required this.repository}) : super(const PartnersState()) {
    on<LoadPartners>(_onLoadPartners);
    on<SearchPartners>(_onSearchPartners);
    on<FilterPartners>(_onFilterPartners);
    on<SortPartners>(_onSortPartners);
    on<ChangePage>(_onChangePage);
    on<ChangePageSize>(_onChangePageSize);
    on<ToggleSelectPartner>(_onToggleSelectPartner);
    on<SelectAllPartners>(_onSelectAllPartners);
    on<ClearSelection>(_onClearSelection);
    on<BulkApprovePartners>(_onBulkApprovePartners);
    on<BulkRejectPartners>(_onBulkRejectPartners);
    on<RefreshPartners>(_onRefreshPartners);
  }

  final PartnersRepository repository;

  Future<void> _onLoadPartners(
    LoadPartners event,
    Emitter<PartnersState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PartnersStatus.loading,
        isRefreshing: event.forceRefresh,
      ),
    );

    try {
      // Build filters from state and event
      final filters =
          event.filters ??
          PartnersFilters(
            status: state.filters?.status,
            type: state.filters?.type,
            country: state.filters?.country,
            search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
          );

      final request = PartnersRequest(
        page: event.page,
        perPage: event.perPage,
        filters: filters,
        sortBy: event.sortBy ?? state.sortState?.columnId,
        order: event.order == 'asc' ? 'asc' : 'desc',
      );

      final response = await repository.fetchPartners(request);

      emit(
        state.copyWith(
          status: PartnersStatus.loaded,
          partners: response.items,
          total: response.total,
          page: response.page,
          perPage: response.perPage,
          filters: filters,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnersStatus.error,
          error: e.toString(),
          isRefreshing: false,
        ),
      );
    }
  }

  void _onSearchPartners(SearchPartners event, Emitter<PartnersState> emit) {
    final filters = PartnersFilters(
      status: state.filters?.status,
      type: state.filters?.type,
      country: state.filters?.country,
      search: event.query.isNotEmpty ? event.query : null,
    );

    add(
      LoadPartners(
        perPage: state.perPage,
        filters: filters,
        sortBy: state.sortState?.columnId,
        order: state.sortState?.ascending ?? false ? 'asc' : 'desc',
      ),
    );
  }

  void _onFilterPartners(FilterPartners event, Emitter<PartnersState> emit) {
    add(
      LoadPartners(
        perPage: state.perPage,
        filters: event.filters,
        sortBy: state.sortState?.columnId,
        order: state.sortState?.ascending ?? false ? 'asc' : 'desc',
      ),
    );
  }

  void _onSortPartners(SortPartners event, Emitter<PartnersState> emit) {
    final sortState = SortState(
      columnId: event.columnId,
      ascending: event.ascending,
    );

    emit(state.copyWith(sortState: sortState));

    add(
      LoadPartners(
        page: state.page,
        perPage: state.perPage,
        filters: state.filters,
        sortBy: event.columnId,
        order: event.ascending ? 'asc' : 'desc',
      ),
    );
  }

  void _onChangePage(ChangePage event, Emitter<PartnersState> emit) {
    add(
      LoadPartners(
        page: event.page,
        perPage: state.perPage,
        filters: state.filters,
        sortBy: state.sortState?.columnId,
        order: state.sortState?.ascending ?? false ? 'asc' : 'desc',
      ),
    );
  }

  void _onChangePageSize(ChangePageSize event, Emitter<PartnersState> emit) {
    add(
      LoadPartners(
        perPage: event.perPage,
        filters: state.filters,
        sortBy: state.sortState?.columnId,
        order: state.sortState?.ascending ?? false ? 'asc' : 'desc',
      ),
    );
  }

  void _onToggleSelectPartner(
    ToggleSelectPartner event,
    Emitter<PartnersState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedPartnerIds);
    if (newSelection.contains(event.partnerId)) {
      newSelection.remove(event.partnerId);
    } else {
      newSelection.add(event.partnerId);
    }

    emit(state.copyWith(selectedPartnerIds: newSelection));
  }

  void _onSelectAllPartners(
    SelectAllPartners event,
    Emitter<PartnersState> emit,
  ) {
    final allIds = state.partners.map((p) => p.id).toSet();
    emit(state.copyWith(selectedPartnerIds: allIds));
  }

  void _onClearSelection(ClearSelection event, Emitter<PartnersState> emit) {
    emit(state.copyWith(selectedPartnerIds: {}));
  }

  Future<void> _onBulkApprovePartners(
    BulkApprovePartners event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(status: PartnersStatus.loading));

    try {
      for (final partnerId in event.partnerIds) {
        await repository.approvePartner(partnerId);
      }

      emit(
        state.copyWith(
          status: PartnersStatus.actionSuccess,
          successMessage: 'Partners approved successfully',
        ),
      );

      // Refresh list
      add(const RefreshPartners());
    } catch (e) {
      emit(state.copyWith(status: PartnersStatus.error, error: e.toString()));
    }
  }

  Future<void> _onBulkRejectPartners(
    BulkRejectPartners event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(status: PartnersStatus.loading));

    try {
      for (final partnerId in event.partnerIds) {
        await repository.rejectPartner(partnerId, event.reason);
      }

      emit(
        state.copyWith(
          status: PartnersStatus.actionSuccess,
          successMessage: 'Partners rejected successfully',
        ),
      );

      // Refresh list
      add(const RefreshPartners());
    } catch (e) {
      emit(state.copyWith(status: PartnersStatus.error, error: e.toString()));
    }
  }

  void _onRefreshPartners(RefreshPartners event, Emitter<PartnersState> emit) {
    add(
      LoadPartners(
        page: state.page,
        perPage: state.perPage,
        filters: state.filters,
        sortBy: state.sortState?.columnId,
        order: state.sortState?.ascending ?? false ? 'asc' : 'desc',
        forceRefresh: true,
      ),
    );
  }
}
