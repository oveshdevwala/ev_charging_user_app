/// File: lib/admin/repositories/local_user_repository.dart
/// Purpose: User repository with shared_preferences persistence
/// Belongs To: admin/repositories
/// Customization Guide:
///    - Modify _storageKey to change persistence key
///    - Adjust pagination default pageSize as needed
library;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/admin_assets.dart';
import '../models/admin_user.dart';

/// Local user repository with shared_preferences persistence.
class LocalUserRepository {
  LocalUserRepository() {
    _init();
  }

  static const String _storageKey = 'admin_users_store';
  List<AdminUser> _users = [];
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      await loadAll();
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _init();
    }
  }

  /// Load all users from JSON seed data and merge with persisted data.
  Future<List<AdminUser>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString(_storageKey);

      if (storedJson != null) {
        // Load from persisted storage
        final jsonList = json.decode(storedJson) as List<dynamic>;
        _users = jsonList
            .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Load from seed JSON
        final jsonString = await rootBundle.loadString(AdminAssets.jsonUsers);
        final jsonList = json.decode(jsonString) as List<dynamic>;
        _users = jsonList
            .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
            .toList();
        // Persist seed data
        await _saveToStorage();
      }
    } catch (e) {
      _users = [];
    }
    return _users;
  }

  /// Get all users with pagination, search, filter, and sort.
  Future<List<AdminUser>> getAll({
    int page = 1,
    int perPage = 25,
    String? q,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool desc = false,
  }) async {
    await _ensureInitialized();

    var users = List<AdminUser>.from(_users);

    // Search
    if (q != null && q.isNotEmpty) {
      final query = q.toLowerCase();
      users = users.where((u) {
        return u.name.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.id.toLowerCase().contains(query) ||
            (u.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Filter
    if (filters != null) {
      if (filters.containsKey('status')) {
        final status = filters['status'] as String?;
        if (status != null && status.isNotEmpty) {
          users = users.where((u) => u.status == status).toList();
        }
      }
      if (filters.containsKey('role')) {
        final role = filters['role'] as String?;
        if (role != null && role.isNotEmpty) {
          users = users.where((u) => u.role == role).toList();
        }
      }
      if (filters.containsKey('accountType')) {
        final accountType = filters['accountType'] as String?;
        if (accountType != null && accountType.isNotEmpty) {
          users = users.where((u) => u.accountType == accountType).toList();
        }
      }
      if (filters.containsKey('signupSource')) {
        final signupSource = filters['signupSource'] as String?;
        if (signupSource != null && signupSource.isNotEmpty) {
          users = users.where((u) => u.signupSource == signupSource).toList();
        }
      }
    }

    // Sort
    if (sortBy != null) {
      users.sort((a, b) {
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
          case 'lastLoginAt':
            comparison = a.lastLoginAt.compareTo(b.lastLoginAt);
            break;
          case 'walletBalance':
            comparison = a.walletBalance.compareTo(b.walletBalance);
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
    if (start >= users.length) return [];
    return users.sublist(start, end.clamp(0, users.length));
  }

  /// Get user by ID.
  Future<AdminUser?> getById(String id) async {
    await _ensureInitialized();
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a new user.
  Future<void> create(AdminUser user) async {
    await _ensureInitialized();
    _users.add(user);
    await _saveToStorage();
  }

  /// Update an existing user.
  Future<void> update(AdminUser user) async {
    await _ensureInitialized();
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index == -1) {
      throw Exception('User not found');
    }
    _users[index] = user;
    await _saveToStorage();
  }

  /// Delete a user.
  Future<void> delete(String id) async {
    await _ensureInitialized();
    _users.removeWhere((u) => u.id == id);
    await _saveToStorage();
  }

  /// Update user status.
  Future<void> updateStatus(String userId, String newStatus) async {
    await _ensureInitialized();
    final user = await getById(userId);
    if (user == null) {
      throw Exception('User not found');
    }
    final updated = user.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await update(updated);
  }

  /// Bulk update status.
  Future<void> bulkUpdateStatus(List<String> userIds, String newStatus) async {
    await _ensureInitialized();
    for (final userId in userIds) {
      await updateStatus(userId, newStatus);
    }
  }

  /// Bulk delete users.
  Future<void> bulkDelete(List<String> userIds) async {
    await _ensureInitialized();
    _users.removeWhere((u) => userIds.contains(u.id));
    await _saveToStorage();
  }

  /// Get total count (for pagination).
  Future<int> getTotalCount({
    String? q,
    Map<String, dynamic>? filters,
  }) async {
    await _ensureInitialized();
    var users = List<AdminUser>.from(_users);

    if (q != null && q.isNotEmpty) {
      final query = q.toLowerCase();
      users = users.where((u) {
        return u.name.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.id.toLowerCase().contains(query) ||
            (u.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (filters != null) {
      if (filters.containsKey('status')) {
        final status = filters['status'] as String?;
        if (status != null && status.isNotEmpty) {
          users = users.where((u) => u.status == status).toList();
        }
      }
      if (filters.containsKey('role')) {
        final role = filters['role'] as String?;
        if (role != null && role.isNotEmpty) {
          users = users.where((u) => u.role == role).toList();
        }
      }
      if (filters.containsKey('accountType')) {
        final accountType = filters['accountType'] as String?;
        if (accountType != null && accountType.isNotEmpty) {
          users = users.where((u) => u.accountType == accountType).toList();
        }
      }
      if (filters.containsKey('signupSource')) {
        final signupSource = filters['signupSource'] as String?;
        if (signupSource != null && signupSource.isNotEmpty) {
          users = users.where((u) => u.signupSource == signupSource).toList();
        }
      }
    }

    return users.length;
  }

  /// Save to shared preferences.
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _users.map((u) => u.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      // Ignore storage errors
    }
  }
}

