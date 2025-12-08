/// File: lib/admin/services/csv_export_service.dart
/// Purpose: CSV export service for admin panel
/// Belongs To: admin/services
library;

import 'dart:convert';

import '../core/config/admin_config.dart';
import '../models/admin_station_model.dart';

/// CSV export service for exporting data.
class CsvExportService {
  CsvExportService();

  /// Export stations to CSV format.
  String exportStations(List<AdminStation> stations) {
    final buffer = StringBuffer();
    
    // Headers
    final headers = [
      'ID',
      'Name',
      'Address',
      'Status',
      'Latitude',
      'Longitude',
      'Total Chargers',
      'Available Chargers',
      'Rating',
      'Total Reviews',
      'Total Sessions',
      'Total Revenue',
      'Manager',
      'Phone',
      'Email',
      'Operating Hours',
      'Created At',
    ];
    buffer.writeln(headers.join(AdminConfig.csvDelimiter));

    // Data rows
    for (final station in stations) {
      final row = [
        _escape(station.id),
        _escape(station.name),
        _escape(station.address),
        _escape(station.status.name),
        station.latitude.toString(),
        station.longitude.toString(),
        station.totalChargers.toString(),
        station.availableChargers.toString(),
        station.rating?.toString() ?? '',
        station.totalReviews?.toString() ?? '',
        station.totalSessions?.toString() ?? '',
        station.totalRevenue?.toStringAsFixed(2) ?? '',
        _escape(station.managerName ?? ''),
        _escape(station.phone ?? ''),
        _escape(station.email ?? ''),
        _escape(station.operatingHours ?? ''),
        station.createdAt.toIso8601String(),
      ];
      buffer.writeln(row.join(AdminConfig.csvDelimiter));
    }

    return buffer.toString();
  }

  /// Escape a CSV field.
  String _escape(String value) {
    if (value.contains(AdminConfig.csvDelimiter) ||
        value.contains('"') ||
        value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Convert CSV string to downloadable bytes.
  List<int> toBytes(String csv) {
    return utf8.encode(csv);
  }
}

