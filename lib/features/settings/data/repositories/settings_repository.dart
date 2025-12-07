/// File: lib/features/settings/data/repositories/settings_repository.dart
/// Purpose: Settings repository with SharedPreferences and JSON export/import
/// Belongs To: settings feature
/// Customization Guide:
///    - Modify storage key if needed
///    - Adjust validation logic for import
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Storage key for settings.
const String _settingsKey = 'app_settings_v1';

/// Settings repository exceptions.
class SettingsException implements Exception {
  const SettingsException(this.message);
  final String message;
  @override
  String toString() => 'SettingsException: $message';
}

class ValidationException extends SettingsException {
  const ValidationException(super.message);
}

class PersistenceException extends SettingsException {
  const PersistenceException(super.message);
}

/// Settings repository interface.
abstract class SettingsRepository {
  /// Load settings from storage.
  Future<SettingsModel> load();

  /// Save settings to storage.
  Future<void> save(SettingsModel settings);

  /// Export settings as JSON string.
  Future<String> exportJson();

  /// Import settings from JSON string.
  /// [replace] if true, replaces all settings; if false, merges with existing.
  Future<void> importJson(String json, {bool replace = false});

  /// Reset settings to defaults.
  Future<void> resetToDefaults();

  /// Clear all settings.
  Future<void> clear();
}

/// Settings repository implementation using SharedPreferences.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<SettingsModel> load() async {
    try {
      final jsonString = _prefs.getString(_settingsKey);
      if (jsonString == null) {
        return SettingsModel.defaults();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SettingsModel.fromJson(json);
    } catch (e) {
      // If parsing fails, return defaults
      return SettingsModel.defaults();
    }
  }

  @override
  Future<void> save(SettingsModel settings) async {
    try {
      final json = settings.toJson();
      final jsonString = jsonEncode(json);
      await _prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      throw PersistenceException('Failed to save settings: $e');
    }
  }

  @override
  Future<String> exportJson() async {
    try {
      final settings = await load();
      final json = settings.toJson();
      return jsonEncode(json);
    } catch (e) {
      throw PersistenceException('Failed to export settings: $e');
    }
  }

  @override
  Future<void> importJson(String json, {bool replace = false}) async {
    try {
      // Validate JSON structure
      final jsonMap = jsonDecode(json) as Map<String, dynamic>;
      
      // Validate required keys exist
      final requiredKeys = [
        'appearance',
        'notifications',
        'security',
        'privacy',
        'data',
        'account',
        'locale',
        'accessibility',
      ];
      
      for (final key in requiredKeys) {
        if (!jsonMap.containsKey(key)) {
          throw ValidationException('Missing required key: $key');
        }
      }

      // Parse to validate structure
      final importedSettings = SettingsModel.fromJson(jsonMap);

      if (replace) {
        // Replace all settings
        await save(importedSettings);
      } else {
        // Merge with existing settings - for now just replace
        // In future, implement proper merging logic if needed
        await save(importedSettings);
      }
    } on ValidationException {
      rethrow;
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw ValidationException('Invalid JSON format: $e');
    }
  }

  @override
  Future<void> resetToDefaults() async {
    try {
      await save(SettingsModel.defaults());
    } catch (e) {
      throw PersistenceException('Failed to reset settings: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _prefs.remove(_settingsKey);
    } catch (e) {
      throw PersistenceException('Failed to clear settings: $e');
    }
  }
}

