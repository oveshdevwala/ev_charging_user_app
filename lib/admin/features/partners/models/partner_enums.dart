/// File: lib/admin/features/partners/models/partner_enums.dart
/// Purpose: Enums for partner-related types and statuses
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Extend enums when adding new partner types/statuses
library;

/// Partner business type.
enum PartnerType {
  owner,
  operator,
  reseller,
}

/// Partner status in the system.
enum PartnerStatus {
  pending,
  active,
  suspended,
  rejected,
}

/// Contract status.
enum ContractStatus {
  active,
  expired,
  terminated,
}

/// Audit action types for tracking partner changes.
enum AuditActionType {
  created,
  updated,
  approved,
  rejected,
  suspended,
  activated,
  contractAdded,
  contractUpdated,
  locationAdded,
  locationUpdated,
  locationRemoved,
}

/// Helper functions for enum serialization.
PartnerType partnerTypeFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'operator':
      return PartnerType.operator;
    case 'reseller':
      return PartnerType.reseller;
    case 'owner':
    default:
      return PartnerType.owner;
  }
}

PartnerStatus partnerStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'active':
      return PartnerStatus.active;
    case 'suspended':
      return PartnerStatus.suspended;
    case 'rejected':
      return PartnerStatus.rejected;
    case 'pending':
    default:
      return PartnerStatus.pending;
  }
}

ContractStatus contractStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'expired':
      return ContractStatus.expired;
    case 'terminated':
      return ContractStatus.terminated;
    case 'active':
    default:
      return ContractStatus.active;
  }
}

AuditActionType auditActionTypeFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'updated':
      return AuditActionType.updated;
    case 'approved':
      return AuditActionType.approved;
    case 'rejected':
      return AuditActionType.rejected;
    case 'suspended':
      return AuditActionType.suspended;
    case 'activated':
      return AuditActionType.activated;
    case 'contract_added':
      return AuditActionType.contractAdded;
    case 'contract_updated':
      return AuditActionType.contractUpdated;
    case 'location_added':
      return AuditActionType.locationAdded;
    case 'location_updated':
      return AuditActionType.locationUpdated;
    case 'location_removed':
      return AuditActionType.locationRemoved;
    case 'created':
    default:
      return AuditActionType.created;
  }
}
