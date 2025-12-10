/// File: lib/admin/features/partners/repository/partners_requests.dart
/// Purpose: Request and response models for partners repository
/// Belongs To: admin/features/partners
library;

import '../models/models.dart';

/// Filter parameters for partner queries.
class PartnersFilters {
  const PartnersFilters({
    this.status,
    this.type,
    this.country,
    this.search,
  });

  final PartnerStatus? status;
  final PartnerType? type;
  final String? country;
  final String? search;
}

/// Request parameters for fetching partners.
class PartnersRequest {
  const PartnersRequest({
    this.page = 1,
    this.perPage = 25,
    this.filters,
    this.sortBy,
    this.order = 'desc',
  });

  final int page;
  final int perPage;
  final PartnersFilters? filters;
  final String? sortBy; // 'name', 'createdAt', 'rating'
  final String order; // 'asc' or 'desc'
}

/// Paginated partners response.
class PaginatedPartnersResponse {
  const PaginatedPartnersResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<PartnerModel> items;
  final int total;
  final int page;
  final int perPage;
}

/// Payload for creating a partner.
class CreatePartnerPayload {
  const CreatePartnerPayload({
    required this.name,
    required this.type,
    required this.email,
    required this.phone,
    required this.country,
    required this.primaryContact,
    this.logoUrl,
  });

  final String name;
  final PartnerType type;
  final String email;
  final String phone;
  final String country;
  final String primaryContact;
  final String? logoUrl;
}

/// Payload for updating a partner.
class UpdatePartnerPayload {
  const UpdatePartnerPayload({
    this.name,
    this.type,
    this.email,
    this.phone,
    this.country,
    this.status,
    this.primaryContact,
    this.logoUrl,
  });

  final String? name;
  final PartnerType? type;
  final String? email;
  final String? phone;
  final String? country;
  final PartnerStatus? status;
  final String? primaryContact;
  final String? logoUrl;
}

/// Payload for creating a contract.
class CreateContractPayload {
  const CreateContractPayload({
    required this.title,
    required this.startDate,
    required this.amount,
    required this.currency,
    this.endDate,
    this.notes,
  });

  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final double amount;
  final String currency;
  final String? notes;
}

/// Payload for updating a contract.
class UpdateContractPayload {
  const UpdateContractPayload({
    this.title,
    this.startDate,
    this.endDate,
    this.status,
    this.amount,
    this.currency,
    this.notes,
  });

  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final ContractStatus? status;
  final double? amount;
  final String? currency;
  final String? notes;
}

/// Payload for creating a location.
class CreateLocationPayload {
  const CreateLocationPayload({
    required this.label,
    required this.address,
    required this.city,
    required this.country,
    required this.lat,
    required this.lng,
  });

  final String label;
  final String address;
  final String city;
  final String country;
  final double lat;
  final double lng;
}

/// Payload for updating a location.
class UpdateLocationPayload {
  const UpdateLocationPayload({
    this.label,
    this.address,
    this.city,
    this.country,
    this.lat,
    this.lng,
  });

  final String? label;
  final String? address;
  final String? city;
  final String? country;
  final double? lat;
  final double? lng;
}

/// Filters for audit logs.
class AuditFilters {
  const AuditFilters({
    this.actionType,
    this.adminUser,
  });

  final AuditActionType? actionType;
  final String? adminUser;
}
