/// File: lib/admin/features/partners/repository/partners_local_mock.dart
/// Purpose: Local mock data source for partners with delay/error simulation
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Replace with real API integration when backend is ready
library;

import 'dart:async';
import 'dart:math';

import '../../../core/constants/admin_assets.dart';
import '../../../core/utils/admin_helpers.dart';
import '../models/models.dart';
import 'partners_repository.dart';
import 'partners_requests.dart';

/// Local mock data source that loads partners from bundled JSON.
class PartnersLocalMock implements PartnersRepository {
  PartnersLocalMock({
    this.simulateError = false,
    this.artificialDelay = const Duration(milliseconds: 600),
  });

  bool simulateError;
  final Duration artificialDelay;

  List<PartnerModel> _partnersCache = [];
  final Map<String, List<PartnerContractModel>> _contractsCache = {};
  final Map<String, List<PartnerLocationModel>> _locationsCache = {};
  final Map<String, List<PartnerAuditModel>> _auditCache = {};
  bool _isInitialized = false;
  final Random _random = Random();

  /// Initialize data from JSON.
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      const assetPath = AdminAssets.jsonPartners;
      final data =
          await AdminHelpers.loadJsonAsset(assetPath) as Map<String, dynamic>;

      // Load partners
      final partnersData = data['partners'] as List<dynamic>? ?? [];
      _partnersCache = partnersData
          .map(
            (item) =>
                PartnerModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      // Load contracts
      final contractsData = data['contracts'] as List<dynamic>? ?? [];
      for (final item in contractsData) {
        final contract = PartnerContractModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
        _contractsCache.putIfAbsent(contract.partnerId, () => []).add(contract);
      }

      // Load locations
      final locationsData = data['locations'] as List<dynamic>? ?? [];
      for (final item in locationsData) {
        final location = PartnerLocationModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
        _locationsCache.putIfAbsent(location.partnerId, () => []).add(location);
      }

      // Load audit logs
      final auditData = data['auditLogs'] as List<dynamic>? ?? [];
      for (final item in auditData) {
        final audit = PartnerAuditModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
        _auditCache.putIfAbsent(audit.partnerId, () => []).add(audit);
      }

      _isInitialized = true;
    } catch (e) {
      // Fallback to generated data if JSON loading fails
      _partnersCache = _generateFallbackPartners();
      _isInitialized = true;
    }
  }

  @override
  Future<PaginatedPartnersResponse> fetchPartners(
    PartnersRequest request,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partners_fetch_failed');

    await _initialize();

    var filtered = List<PartnerModel>.from(_partnersCache);

    // Apply filters
    if (request.filters != null) {
      final filters = request.filters!;
      if (filters.status != null) {
        filtered = filtered.where((p) => p.status == filters.status).toList();
      }
      if (filters.type != null) {
        filtered = filtered.where((p) => p.type == filters.type).toList();
      }
      if (filters.country != null && filters.country!.isNotEmpty) {
        filtered = filtered.where((p) => p.country == filters.country).toList();
      }
      if (filters.search != null && filters.search!.isNotEmpty) {
        final query = filters.search!.toLowerCase();
        filtered = filtered.where((p) {
          return p.id.toLowerCase().contains(query) ||
              p.name.toLowerCase().contains(query) ||
              p.email.toLowerCase().contains(query);
        }).toList();
      }
    }

    // Apply sorting
    if (request.sortBy != null) {
      filtered.sort((a, b) {
        var comparison = 0;
        switch (request.sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'createdAt':
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          case 'rating':
            comparison = a.rating.compareTo(b.rating);
            break;
          default:
            comparison = 0;
        }
        return request.order == 'desc' ? -comparison : comparison;
      });
    } else {
      // Default sort by createdAt desc
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    // Pagination
    final total = filtered.length;
    final page = request.page;
    final perPage = request.perPage;
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final paginated = filtered.sublist(
      start.clamp(0, total),
      end.clamp(0, total),
    );

    return PaginatedPartnersResponse(
      items: paginated,
      total: total,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<List<PartnerModel>> searchPartners(String query) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partners_search_failed');

    await _initialize();

    final lowerQuery = query.toLowerCase();
    return _partnersCache.where((p) {
      return p.id.toLowerCase().contains(lowerQuery) ||
          p.name.toLowerCase().contains(lowerQuery) ||
          p.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<PartnerModel?> getPartnerById(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_detail_failed');

    await _initialize();

    try {
      return _partnersCache.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PartnerModel> createPartner(CreatePartnerPayload payload) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_create_failed');

    await _initialize();

    final newPartner = PartnerModel(
      id: 'partner_${DateTime.now().millisecondsSinceEpoch}',
      name: payload.name,
      type: payload.type,
      email: payload.email,
      phone: payload.phone,
      country: payload.country,
      status: PartnerStatus.pending,
      rating: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryContact: payload.primaryContact,
      logoUrl: payload.logoUrl,
    );

    _partnersCache.add(newPartner);

    // Add audit log
    await addAuditLog(
      newPartner.id,
      AuditActionType.created,
      'admin_user',
      memo: 'Partner created',
    );

    return newPartner;
  }

  @override
  Future<PartnerModel> updatePartner(
    String id,
    UpdatePartnerPayload payload,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_update_failed');

    await _initialize();

    final index = _partnersCache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('partner_not_found');

    final existing = _partnersCache[index];
    final updated = existing.copyWith(
      name: payload.name,
      type: payload.type,
      email: payload.email,
      phone: payload.phone,
      country: payload.country,
      status: payload.status,
      primaryContact: payload.primaryContact,
      logoUrl: payload.logoUrl,
      updatedAt: DateTime.now(),
    );

    _partnersCache[index] = updated;

    // Add audit log
    await addAuditLog(
      id,
      AuditActionType.updated,
      'admin_user',
      memo: 'Partner updated',
    );

    return updated;
  }

  @override
  Future<void> approvePartner(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_approve_failed');

    await _initialize();

    final index = _partnersCache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('partner_not_found');

    final existing = _partnersCache[index];
    _partnersCache[index] = existing.copyWith(
      status: PartnerStatus.active,
      updatedAt: DateTime.now(),
    );

    await addAuditLog(id, AuditActionType.approved, 'admin_user');
  }

  @override
  Future<void> rejectPartner(String id, String reason) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_reject_failed');

    await _initialize();

    final index = _partnersCache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('partner_not_found');

    final existing = _partnersCache[index];
    _partnersCache[index] = existing.copyWith(
      status: PartnerStatus.rejected,
      updatedAt: DateTime.now(),
    );

    await addAuditLog(id, AuditActionType.rejected, 'admin_user', memo: reason);
  }

  @override
  Future<void> suspendPartner(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_suspend_failed');

    await _initialize();

    final index = _partnersCache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('partner_not_found');

    final existing = _partnersCache[index];
    _partnersCache[index] = existing.copyWith(
      status: PartnerStatus.suspended,
      updatedAt: DateTime.now(),
    );

    await addAuditLog(id, AuditActionType.suspended, 'admin_user');
  }

  @override
  Future<void> activatePartner(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('partner_activate_failed');

    await _initialize();

    final index = _partnersCache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('partner_not_found');

    final existing = _partnersCache[index];
    _partnersCache[index] = existing.copyWith(
      status: PartnerStatus.active,
      updatedAt: DateTime.now(),
    );

    await addAuditLog(id, AuditActionType.activated, 'admin_user');
  }

  @override
  Future<PartnerContractModel> addContract(
    String partnerId,
    CreateContractPayload contract,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('contract_add_failed');

    await _initialize();

    final newContract = PartnerContractModel(
      id: 'contract_${DateTime.now().millisecondsSinceEpoch}',
      partnerId: partnerId,
      title: contract.title,
      startDate: contract.startDate,
      endDate: contract.endDate,
      status: ContractStatus.active,
      amount: contract.amount,
      currency: contract.currency,
      notes: contract.notes,
    );

    _contractsCache.putIfAbsent(partnerId, () => []).add(newContract);

    await addAuditLog(
      partnerId,
      AuditActionType.contractAdded,
      'admin_user',
      memo: 'Contract: ${contract.title}',
    );

    return newContract;
  }

  @override
  Future<PartnerContractModel> updateContract(
    String contractId,
    UpdateContractPayload contract,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('contract_update_failed');

    await _initialize();

    PartnerContractModel? found;
    String? partnerId;

    for (final entry in _contractsCache.entries) {
      final index = entry.value.indexWhere((c) => c.id == contractId);
      if (index != -1) {
        found = entry.value[index];
        partnerId = entry.key;
        final updated = found.copyWith(
          title: contract.title,
          startDate: contract.startDate,
          endDate: contract.endDate,
          status: contract.status,
          amount: contract.amount,
          currency: contract.currency,
          notes: contract.notes,
        );
        entry.value[index] = updated;
        found = updated;
        break;
      }
    }

    if (found == null || partnerId == null) {
      throw Exception('contract_not_found');
    }

    await addAuditLog(
      partnerId,
      AuditActionType.contractUpdated,
      'admin_user',
      memo: 'Contract updated',
    );

    return found;
  }

  @override
  Future<List<PartnerContractModel>> getContracts(String partnerId) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('contracts_fetch_failed');

    await _initialize();

    return _contractsCache[partnerId] ?? [];
  }

  @override
  Future<List<PartnerLocationModel>> getLocations(String partnerId) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('locations_fetch_failed');

    await _initialize();

    return _locationsCache[partnerId] ?? [];
  }

  @override
  Future<PartnerLocationModel> addLocation(
    String partnerId,
    CreateLocationPayload location,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('location_add_failed');

    await _initialize();

    final newLocation = PartnerLocationModel(
      id: 'location_${DateTime.now().millisecondsSinceEpoch}',
      partnerId: partnerId,
      label: location.label,
      address: location.address,
      city: location.city,
      country: location.country,
      lat: location.lat,
      lng: location.lng,
      createdAt: DateTime.now(),
    );

    _locationsCache.putIfAbsent(partnerId, () => []).add(newLocation);

    await addAuditLog(
      partnerId,
      AuditActionType.locationAdded,
      'admin_user',
      memo: 'Location: ${location.label}',
    );

    return newLocation;
  }

  @override
  Future<PartnerLocationModel> updateLocation(
    String locationId,
    UpdateLocationPayload location,
  ) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('location_update_failed');

    await _initialize();

    PartnerLocationModel? found;
    String? partnerId;

    for (final entry in _locationsCache.entries) {
      final index = entry.value.indexWhere((l) => l.id == locationId);
      if (index != -1) {
        found = entry.value[index];
        partnerId = entry.key;
        final updated = found.copyWith(
          label: location.label,
          address: location.address,
          city: location.city,
          country: location.country,
          lat: location.lat,
          lng: location.lng,
        );
        entry.value[index] = updated;
        found = updated;
        break;
      }
    }

    if (found == null || partnerId == null) {
      throw Exception('location_not_found');
    }

    await addAuditLog(
      partnerId,
      AuditActionType.locationUpdated,
      'admin_user',
      memo: 'Location updated',
    );

    return found;
  }

  @override
  Future<void> removeLocation(String locationId) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('location_remove_failed');

    await _initialize();

    String? partnerId;

    for (final entry in _locationsCache.entries) {
      final index = entry.value.indexWhere((l) => l.id == locationId);
      if (index != -1) {
        partnerId = entry.key;
        entry.value.removeAt(index);
        break;
      }
    }

    if (partnerId == null) throw Exception('location_not_found');

    await addAuditLog(
      partnerId,
      AuditActionType.locationRemoved,
      'admin_user',
      memo: 'Location removed',
    );
  }

  @override
  Future<List<PartnerAuditModel>> getAuditLogs(
    String partnerId, {
    AuditFilters? filters,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('audit_logs_failed');

    await _initialize();

    var logs = List<PartnerAuditModel>.from(_auditCache[partnerId] ?? []);

    if (filters != null) {
      if (filters.actionType != null) {
        logs = logs.where((l) => l.actionType == filters.actionType).toList();
      }
      if (filters.adminUser != null && filters.adminUser!.isNotEmpty) {
        logs = logs
            .where((l) => l.adminUser.contains(filters.adminUser!))
            .toList();
      }
    }

    // Sort by timestamp desc
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return logs;
  }

  @override
  Future<void> addAuditLog(
    String partnerId,
    AuditActionType action,
    String adminUser, {
    String? memo,
  }) async {
    final audit = PartnerAuditModel(
      id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
      partnerId: partnerId,
      actionType: action,
      adminUser: adminUser,
      timestamp: DateTime.now(),
      memo: memo,
    );

    _auditCache.putIfAbsent(partnerId, () => []).add(audit);
  }

  @override
  Future<String> exportPartnersAsCsv(PartnersRequest request) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('export_failed');

    final response = await fetchPartners(request);
    final buffer = StringBuffer();

    // Header
    buffer.writeln('ID,Name,Type,Email,Phone,Country,Status,Rating,Created At');

    // Data
    for (final partner in response.items) {
      buffer.writeln(
        '${partner.id},${partner.name},${partner.typeName},'
        '${partner.email},${partner.phone},${partner.country},'
        '${partner.statusName},${partner.rating},${partner.createdAt.toIso8601String()}',
      );
    }

    return buffer.toString();
  }

  /// Generate fallback partners if JSON loading fails.
  List<PartnerModel> _generateFallbackPartners() {
    return List.generate(10, (index) {
      const types = PartnerType.values;
      const statuses = PartnerStatus.values;
      const countries = ['IN', 'US', 'UK', 'DE'];

      return PartnerModel(
        id: 'partner_${index + 1}',
        name: 'Partner ${index + 1}',
        type: types[index % types.length],
        email: 'partner${index + 1}@example.com',
        phone: '+1-555-000${index + 1}',
        country: countries[index % countries.length],
        status: statuses[index % statuses.length],
        rating: 2.5 + (_random.nextDouble() * 2.5),
        createdAt: DateTime.now().subtract(Duration(days: index * 30)),
        updatedAt: DateTime.now().subtract(Duration(days: index * 30)),
        primaryContact: 'Contact ${index + 1}',
        logoUrl: AdminAssets.placeholderPartner,
      );
    });
  }
}
