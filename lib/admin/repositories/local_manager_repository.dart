/// File: lib/admin/repositories/local_manager_repository.dart
/// Purpose: Manager repository with shared_preferences persistence
/// Belongs To: admin/repositories
/// Customization Guide:
///    - Modify _storageKey to change persistence key
///    - Adjust pagination default pageSize as needed
library;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/admin_assets.dart';
import '../models/manager.dart';

/// Local manager repository with shared_preferences persistence.
class LocalManagerRepository {
  LocalManagerRepository() {
    _init();
  }

  static const String _storageKey = 'admin_managers_store';
  List<Manager> _managers = [];
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      await loadAll();
      _isInitialized = true;
    }
  }

  /// Load all managers from JSON seed data and merge with persisted data.
  Future<List<Manager>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString(_storageKey);

      if (storedJson != null) {
        // Load from persisted storage
        final jsonList = json.decode(storedJson) as List<dynamic>;
        _managers = jsonList
            .map((json) => Manager.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Load from seed JSON
        final jsonString = await rootBundle.loadString(AdminAssets.jsonManagers);
        final jsonList = json.decode(jsonString) as List<dynamic>;
        _managers = jsonList
            .map((json) => Manager.fromJson(json as Map<String, dynamic>))
            .toList();
        // Persist seed data
        await _saveToStorage();
      }
    } catch (e) {
      _managers = [];
    }
    return _managers;
  }

  /// Get all managers with pagination, search, filter, and sort.
  Future<List<Manager>> getAll({
    int page = 1,
    int perPage = 25,
    String? q,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool desc = false,
  }) async {
    await _ensureInitialized();

    var managers = List<Manager>.from(_managers);

    // Search
    if (q != null && q.isNotEmpty) {
      final query = q.toLowerCase();
      managers = managers.where((m) {
        return m.name.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query) ||
            m.id.toLowerCase().contains(query) ||
            (m.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Filter
    if (filters != null) {
      if (filters.containsKey('status')) {
        final status = filters['status'] as String?;
        if (status != null) {
          managers = managers.where((m) => m.status == status).toList();
        }
      }
      if (filters.containsKey('roles')) {
        final roles = filters['roles'] as List<String>?;
        if (roles != null && roles.isNotEmpty) {
          managers = managers.where((m) {
            return m.roles.any(roles.contains);
          }).toList();
        }
      }
    }

    // Sort
    if (sortBy != null) {
      managers.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'email':
            comparison = a.email.compareTo(b.email);
            break;
          case 'status':
            comparison = a.status.compareTo(b.status);
            break;
          case 'createdAt':
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          default:
            comparison = 0;
        }
        return desc ? -comparison : comparison;
      });
    }

    // Pagination
    final start = (page - 1) * perPage;
    final end = start + perPage;
    if (start >= managers.length) return [];
    return managers.sublist(start, end.clamp(0, managers.length));
  }

  /// Get manager by ID.
  Future<Manager?> getById(String id) async {
    await _ensureInitialized();
    try {
      return _managers.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a new manager.
  Future<void> create(Manager m) async {
    await _ensureInitialized();
    _managers.add(m);
    await _saveToStorage();
  }

  /// Update an existing manager.
  Future<void> update(Manager m) async {
    await _ensureInitialized();
    final index = _managers.indexWhere((manager) => manager.id == m.id);
    if (index == -1) {
      throw Exception('Manager not found');
    }
    _managers[index] = m;
    await _saveToStorage();
  }

  /// Delete a manager.
  Future<void> delete(String id) async {
    await _ensureInitialized();
    _managers.removeWhere((m) => m.id == id);
    await _saveToStorage();
  }

  /// Assign stations to a manager.
  Future<void> assignStations(String managerId, List<String> stationIds) async {
    await _ensureInitialized();
    final manager = await getById(managerId);
    if (manager == null) {
      throw Exception('Manager not found');
    }
    final updated = manager.copyWith(assignedStationIds: stationIds);
    await update(updated);
  }

  /// Toggle manager status.
  Future<void> toggleStatus(String managerId, String newStatus) async {
    await _ensureInitialized();
    final manager = await getById(managerId);
    if (manager == null) {
      throw Exception('Manager not found');
    }
    final updated = manager.copyWith(status: newStatus);
    await update(updated);
  }

  /// Get total count (for pagination).
  Future<int> getTotalCount({
    String? q,
    Map<String, dynamic>? filters,
  }) async {
    await _ensureInitialized();
    var managers = List<Manager>.from(_managers);

    if (q != null && q.isNotEmpty) {
      final query = q.toLowerCase();
      managers = managers.where((m) {
        return m.name.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query) ||
            m.id.toLowerCase().contains(query) ||
            (m.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (filters != null) {
      if (filters.containsKey('status')) {
        final status = filters['status'] as String?;
        if (status != null) {
          managers = managers.where((m) => m.status == status).toList();
        }
      }
      if (filters.containsKey('roles')) {
        final roles = filters['roles'] as List<String>?;
        if (roles != null && roles.isNotEmpty) {
          managers = managers.where((m) {
            return m.roles.any(roles.contains);
          }).toList();
        }
      }
    }

    return managers.length;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await loadAll();
      _isInitialized = true;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _managers.map((m) => m.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      // Silently fail - in-memory cache still works
    }
  }
}

