/// File: lib/admin/features/sessions/data/sessions_sources.dart
/// Purpose: Data sources for sessions monitoring (remote/local/stream)
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Swap implementations when backend endpoints are ready
///    - Configure devMode to toggle mocks and streams
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/admin_assets.dart';
import 'session_models.dart';

/// Remote source using Dio for REST + export job hooks.
class AdminSessionsRemoteSource {
  AdminSessionsRemoteSource({
    required this.dio,
    this.baseUrl = '/admin',
    this.devMode = true,
  });

  final Dio dio;
  final String baseUrl;
  final bool devMode;

  Future<AdminSessionsPageDto> fetchSessions({
    String? cursor,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    if (devMode) {
      final data = await rootBundle.loadString(AdminAssets.jsonSessions);
      final decoded = jsonDecode(data) as List<dynamic>;
      final items = decoded
          .map((e) => AdminSessionSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList();
      final sliced = items.take(limit).toList();
      return AdminSessionsPageDto(items: sliced, nextCursor: null, hasMore: false);
    }

    final response = await dio.get<Map<String, dynamic>>(
      '$baseUrl/sessions',
      queryParameters: {
        'cursor': cursor,
        'limit': limit,
        ...?filters,
      },
    );
    return AdminSessionsPageDto.fromJson(response.data ?? {});
  }

  Future<AdminSessionDetailDto> fetchSessionDetail(String sessionId) async {
    if (devMode) {
      final base = await fetchSessions(limit: 1);
      final summary = base.items.first;
      final now = DateTime.now().toUtc();
      return AdminSessionDetailDto(
        summary: summary.copyWith(id: sessionId, startAt: now.subtract(const Duration(minutes: 20))),
        timeline: List.generate(
          4,
          (index) => AdminSessionEventDto(
            timestamp: now.subtract(Duration(minutes: 20 - (index * 5))),
            type: 'phase',
            message: 'Phase ${index + 1}',
            code: 'P$index',
            metadata: {'seq': index},
          ),
        ),
        telemetry: List.generate(
          20,
          (index) => AdminTelemetryPointDto(
            timestamp: now.subtract(Duration(minutes: 20 - index)),
            powerKw: 22 + index / 3,
            voltage: 410,
            currentA: 32 + index.toDouble(),
            socPercent: 30 + index.toDouble(),
            meterReading: 1000 + index * 2,
          ),
        ),
        events: [
          AdminSessionEventDto(
            timestamp: now.subtract(const Duration(minutes: 15)),
            type: 'billing',
            message: 'Authorization confirmed',
            code: 'BILL_OK',
            metadata: const {'amount': 10.5},
          ),
        ],
        auditTrail: [
          AdminSessionEventDto(
            timestamp: now.subtract(const Duration(minutes: 1)),
            type: 'audit',
            message: 'Viewed by admin',
          ),
        ],
        mapPolyline: const [
          [37.7749, -122.4194],
          [37.775, -122.418],
        ],
        rawUrl: 'https://example.com/raw/$sessionId.json',
      );
    }

    final response = await dio.get<Map<String, dynamic>>('$baseUrl/sessions/$sessionId');
    return AdminSessionDetailDto.fromJson(response.data ?? {});
  }

  Future<String> requestExport({
    required List<String> sessionIds,
    required String format,
  }) async {
    if (devMode) return 'job_${DateTime.now().millisecondsSinceEpoch}';
    final response = await dio.post<Map<String, dynamic>>(
      '$baseUrl/sessions/export',
      data: {'ids': sessionIds, 'format': format},
    );
    return (response.data ?? {})['jobId'] as String;
  }
}

/// Local cache for filters and lightweight persistence.
class AdminSessionsLocalSource {
  const AdminSessionsLocalSource();

  Future<void> saveFilters(Map<String, dynamic> filters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_sessions_filters', jsonEncode(filters));
  }

  Future<Map<String, dynamic>> loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('admin_sessions_filters');
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}

/// Stream source to simulate websocket/MQTT events.
class AdminSessionsStreamSource {
  AdminSessionsStreamSource({this.devMode = true});

  final bool devMode;
  StreamController<AdminLiveSessionEventDto>? _controller;

  Stream<AdminLiveSessionEventDto> connect() {
    if (!devMode) {
      _controller = StreamController.broadcast();
      return _controller!.stream;
    }

    _controller ??= StreamController<AdminLiveSessionEventDto>.broadcast();
    final now = DateTime.now().toUtc();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller?.hasListener != true) return;
      _controller?.add(
        AdminLiveSessionEventDto(
          sessionId: 'ses_live_${timer.tick % 3}',
          timestamp: now.add(Duration(seconds: timer.tick)),
          type: timer.tick % 2 == 0 ? 'telemetry' : 'status',
          payload: {
            'powerKw': 20 + timer.tick,
            'status': timer.tick % 2 == 0 ? 'active' : 'completed',
          },
        ),
      );
      if (timer.tick > 20) timer.cancel();
    });
    return _controller!.stream;
  }

  Future<void> disconnect() async {
    await _controller?.close();
    _controller = null;
  }
}

