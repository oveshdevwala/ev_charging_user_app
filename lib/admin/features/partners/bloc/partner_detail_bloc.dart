/// File: lib/admin/features/partners/bloc/partner_detail_bloc.dart
/// Purpose: Partner detail BLoC for single partner actions
/// Belongs To: admin/features/partners
library;

import 'package:bloc/bloc.dart';

import '../repository/partners_repository.dart';
import 'partner_detail_event.dart';
import 'partner_detail_state.dart';

/// Handles partner detail state and actions.
class PartnerDetailBloc
    extends Bloc<PartnerDetailEvent, PartnerDetailState> {
  PartnerDetailBloc({required this.repository})
      : super(const PartnerDetailState()) {
    on<LoadPartnerDetail>(_onLoadPartnerDetail);
    on<ApprovePartner>(_onApprovePartner);
    on<RejectPartner>(_onRejectPartner);
    on<SuspendPartner>(_onSuspendPartner);
    on<ActivatePartner>(_onActivatePartner);
    on<AddContract>(_onAddContract);
    on<UpdateContract>(_onUpdateContract);
    on<AddLocation>(_onAddLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<RemoveLocation>(_onRemoveLocation);
    on<LoadAuditLogs>(_onLoadAuditLogs);
  }

  final PartnersRepository repository;

  Future<void> _onLoadPartnerDetail(
    LoadPartnerDetail event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(status: PartnerDetailStatus.loading));

    try {
      final partner = await repository.getPartnerById(event.partnerId);
      if (partner == null) {
        emit(
          state.copyWith(
            status: PartnerDetailStatus.error,
            error: 'Partner not found',
          ),
        );
        return;
      }

      // Load related data
      final contracts = await repository.getContracts(event.partnerId);
      final locations = await repository.getLocations(event.partnerId);
      final auditLogs = await repository.getAuditLogs(event.partnerId);

      emit(
        state.copyWith(
          status: PartnerDetailStatus.loaded,
          partner: partner,
          contracts: contracts,
          locations: locations,
          auditLogs: auditLogs,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnerDetailStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onApprovePartner(
    ApprovePartner event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isApproving: true));

    try {
      await repository.approvePartner(event.partnerId);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isApproving: false,
          successMessage: 'Partner approved successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isApproving: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRejectPartner(
    RejectPartner event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isRejecting: true));

    try {
      await repository.rejectPartner(event.partnerId, event.reason);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isRejecting: false,
          successMessage: 'Partner rejected successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRejecting: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSuspendPartner(
    SuspendPartner event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isSuspending: true));

    try {
      await repository.suspendPartner(event.partnerId);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isSuspending: false,
          successMessage: 'Partner suspended successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSuspending: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onActivatePartner(
    ActivatePartner event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isActivating: true));

    try {
      await repository.activatePartner(event.partnerId);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isActivating: false,
          successMessage: 'Partner activated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActivating: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddContract(
    AddContract event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isAddingContract: true));

    try {
      await repository.addContract(event.partnerId, event.contract);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isAddingContract: false,
          successMessage: 'Contract added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isAddingContract: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateContract(
    UpdateContract event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(status: PartnerDetailStatus.processing));

    try {
      await repository.updateContract(event.contractId, event.contract);

      // Reload partner data
      if (state.partner != null) {
        add(LoadPartnerDetail(state.partner!.id));
      }

      emit(
        state.copyWith(
          status: PartnerDetailStatus.loaded,
          successMessage: 'Contract updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnerDetailStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddLocation(
    AddLocation event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isUpdatingLocation: true));

    try {
      await repository.addLocation(event.partnerId, event.location);

      // Reload partner data
      add(LoadPartnerDetail(event.partnerId));

      emit(
        state.copyWith(
          isUpdatingLocation: false,
          successMessage: 'Location added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUpdatingLocation: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(isUpdatingLocation: true));

    try {
      await repository.updateLocation(event.locationId, event.location);

      // Reload partner data
      if (state.partner != null) {
        add(LoadPartnerDetail(state.partner!.id));
      }

      emit(
        state.copyWith(
          isUpdatingLocation: false,
          successMessage: 'Location updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUpdatingLocation: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveLocation(
    RemoveLocation event,
    Emitter<PartnerDetailState> emit,
  ) async {
    emit(state.copyWith(status: PartnerDetailStatus.processing));

    try {
      await repository.removeLocation(event.locationId);

      // Reload partner data
      if (state.partner != null) {
        add(LoadPartnerDetail(state.partner!.id));
      }

      emit(
        state.copyWith(
          status: PartnerDetailStatus.loaded,
          successMessage: 'Location removed successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnerDetailStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadAuditLogs(
    LoadAuditLogs event,
    Emitter<PartnerDetailState> emit,
  ) async {
    try {
      final logs = await repository.getAuditLogs(
        event.partnerId,
        filters: event.filters,
      );

      emit(state.copyWith(auditLogs: logs));
    } catch (e) {
      emit(
        state.copyWith(
          status: PartnerDetailStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
