/// File: lib/admin/features/partners/repository/partners_repository.dart
/// Purpose: Repository interface for partners operations
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Replace mock implementation with real API when backend is ready
library;

import '../models/models.dart';
import 'partners_requests.dart';

/// Repository interface for partner operations.
abstract class PartnersRepository {
  // List operations
  Future<PaginatedPartnersResponse> fetchPartners(PartnersRequest request);
  Future<List<PartnerModel>> searchPartners(String query);

  // Single partner operations
  Future<PartnerModel?> getPartnerById(String id);
  Future<PartnerModel> createPartner(CreatePartnerPayload payload);
  Future<PartnerModel> updatePartner(String id, UpdatePartnerPayload payload);

  // Status operations
  Future<void> approvePartner(String id);
  Future<void> rejectPartner(String id, String reason);
  Future<void> suspendPartner(String id);
  Future<void> activatePartner(String id);

  // Contract operations
  Future<PartnerContractModel> addContract(
    String partnerId,
    CreateContractPayload contract,
  );
  Future<PartnerContractModel> updateContract(
    String contractId,
    UpdateContractPayload contract,
  );
  Future<List<PartnerContractModel>> getContracts(String partnerId);

  // Location operations
  Future<List<PartnerLocationModel>> getLocations(String partnerId);
  Future<PartnerLocationModel> addLocation(
    String partnerId,
    CreateLocationPayload location,
  );
  Future<PartnerLocationModel> updateLocation(
    String locationId,
    UpdateLocationPayload location,
  );
  Future<void> removeLocation(String locationId);

  // Audit operations
  Future<List<PartnerAuditModel>> getAuditLogs(
    String partnerId, {
    AuditFilters? filters,
  });
  Future<void> addAuditLog(
    String partnerId,
    AuditActionType action,
    String adminUser, {
    String? memo,
  });

  // Export operations
  Future<String> exportPartnersAsCsv(PartnersRequest request);
}
