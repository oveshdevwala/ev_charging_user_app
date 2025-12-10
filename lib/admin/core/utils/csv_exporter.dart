/// File: lib/admin/core/utils/csv_exporter.dart
/// Purpose: CSV export utility for admin panel
/// Belongs To: admin/core/utils
/// Customization Guide:
///    - Modify downloadCsv for web platform as needed
///    - For non-web platforms, use generateManagersCsvString and handle download manually
library;

import 'dart:html' as html show Blob, Url, AnchorElement;

import 'package:ev_charging_user_app/admin/models/admin_user.dart';
import 'package:ev_charging_user_app/admin/models/manager.dart';

/// CSV exporter utility.
class CsvExporter {
  /// Export managers to CSV and trigger download (web).
  static void exportManagersToCsv(List<Manager> managers) {
    final csv = _generateManagersCsv(managers);
    _downloadCsv(csv, 'managers_export.csv');
  }

  /// Generate CSV string from managers list.
  static String _generateManagersCsv(List<Manager> managers) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'ID,Name,Email,Phone,Assigned Stations,Roles,Status,Created At',
    );

    // Rows
    for (final manager in managers) {
      final stationIds = manager.assignedStationIds.join(';');
      final roles = manager.roles.join(';');
      buffer.writeln(
        '"${_escapeCsv(manager.id)}",'
        '"${_escapeCsv(manager.name)}",'
        '"${_escapeCsv(manager.email)}",'
        '"${_escapeCsv(manager.phone ?? '')}",'
        '"$stationIds",'
        '"$roles",'
        '"${_escapeCsv(manager.status)}",'
        '"${manager.createdAt.toIso8601String()}"',
      );
    }

    return buffer.toString();
  }

  /// Escape CSV field (handles quotes and commas).
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return value.replaceAll('"', '""');
    }
    return value;
  }

  /// Download CSV file (web platform only).
  static void _downloadCsv(String csv, String filename) {
    try {
      final blob = html.Blob([csv], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      // Silently fail on non-web platforms - use generateManagersCsvString instead
    }
  }

  /// Return CSV string (for non-web platforms or testing).
  static String generateManagersCsvString(List<Manager> managers) {
    return _generateManagersCsv(managers);
  }

  /// Export users to CSV and trigger download (web).
  static void exportUsersToCsv(List<AdminUser> users) {
    final csv = _generateUsersCsv(users);
    _downloadCsv(csv, 'users_export.csv');
  }

  /// Generate CSV string from users list.
  static String _generateUsersCsv(List<AdminUser> users) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'ID,Name,Email,Phone,Status,Role,Wallet Balance,Total Sessions,Total Spent,Vehicles,Created At,Last Login',
    );

    // Rows
    for (final user in users) {
      buffer.writeln(
        '"${_escapeCsv(user.id)}",'
        '"${_escapeCsv(user.name)}",'
        '"${_escapeCsv(user.email)}",'
        '"${_escapeCsv(user.phone ?? '')}",'
        '"${_escapeCsv(user.status)}",'
        '"${_escapeCsv(user.role)}",'
        '${user.walletBalance},'
        '${user.totalSessions},'
        '${user.totalSpent},'
        '${user.vehicleCount},'
        '"${user.createdAt.toIso8601String()}",'
        '"${user.lastLoginAt.toIso8601String()}"',
      );
    }

    return buffer.toString();
  }

  /// Return CSV string for users (for non-web platforms or testing).
  static String generateUsersCsvString(List<AdminUser> users) {
    return _generateUsersCsv(users);
  }
}
