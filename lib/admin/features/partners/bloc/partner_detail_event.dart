/// File: lib/admin/features/partners/bloc/partner_detail_event.dart
/// Purpose: Events for partner detail BLoC
/// Belongs To: admin/features/partners
library;

import 'package:equatable/equatable.dart';

import '../repository/partners_requests.dart';

/// Base class for partner detail events.
abstract class PartnerDetailEvent extends Equatable {
  const PartnerDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load partner detail.
class LoadPartnerDetail extends PartnerDetailEvent {
  const LoadPartnerDetail(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Approve partner.
class ApprovePartner extends PartnerDetailEvent {
  const ApprovePartner(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Reject partner.
class RejectPartner extends PartnerDetailEvent {
  const RejectPartner({required this.partnerId, required this.reason});

  final String partnerId;
  final String reason;

  @override
  List<Object?> get props => [partnerId, reason];
}

/// Suspend partner.
class SuspendPartner extends PartnerDetailEvent {
  const SuspendPartner(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Activate partner.
class ActivatePartner extends PartnerDetailEvent {
  const ActivatePartner(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Add contract.
class AddContract extends PartnerDetailEvent {
  const AddContract({required this.partnerId, required this.contract});

  final String partnerId;
  final CreateContractPayload contract;

  @override
  List<Object?> get props => [partnerId, contract];
}

/// Update contract.
class UpdateContract extends PartnerDetailEvent {
  const UpdateContract({required this.contractId, required this.contract});

  final String contractId;
  final UpdateContractPayload contract;

  @override
  List<Object?> get props => [contractId, contract];
}

/// Add location.
class AddLocation extends PartnerDetailEvent {
  const AddLocation({required this.partnerId, required this.location});

  final String partnerId;
  final CreateLocationPayload location;

  @override
  List<Object?> get props => [partnerId, location];
}

/// Update location.
class UpdateLocation extends PartnerDetailEvent {
  const UpdateLocation({required this.locationId, required this.location});

  final String locationId;
  final UpdateLocationPayload location;

  @override
  List<Object?> get props => [locationId, location];
}

/// Remove location.
class RemoveLocation extends PartnerDetailEvent {
  const RemoveLocation(this.locationId);

  final String locationId;

  @override
  List<Object?> get props => [locationId];
}

/// Load audit logs.
class LoadAuditLogs extends PartnerDetailEvent {
  const LoadAuditLogs({required this.partnerId, this.filters});

  final String partnerId;
  final AuditFilters? filters;

  @override
  List<Object?> get props => [partnerId, filters];
}
