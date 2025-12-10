/// File: lib/admin/features/sessions/data/sessions_repository_impl.dart
/// Purpose: Repository implementation for sessions monitoring
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace mock data with production API wiring
///    - Inject analytics/tracing hooks as needed
library;

import '../domain/sessions_repository.dart';
import 'session_models.dart';
import 'sessions_sources.dart';

/// Concrete repository orchestrating remote, local, and stream sources.
class AdminSessionsRepositoryImpl implements AdminSessionsRepository {
  AdminSessionsRepositoryImpl({
    required this.remote,
    required this.local,
    required this.stream,
  });

  final AdminSessionsRemoteSource remote;
  final AdminSessionsLocalSource local;
  final AdminSessionsStreamSource stream;

  @override
  Future<AdminSessionsPageDto> fetchSessions({
    String? cursor,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) {
    return remote.fetchSessions(cursor: cursor, limit: limit, filters: filters);
  }

  @override
  Future<AdminSessionDetailDto> fetchSessionDetail(String sessionId) {
    return remote.fetchSessionDetail(sessionId);
  }

  @override
  Stream<AdminLiveSessionEventDto> streamLiveSessions() {
    return stream.connect();
  }

  @override
  Future<String> requestExport({
    required List<String> sessionIds,
    required String format,
  }) {
    return remote.requestExport(sessionIds: sessionIds, format: format);
  }

  @override
  Future<AdminIncidentDto> createIncident(AdminIncidentDto incident) async {
    // Mocked creation in dev mode; replace with API call later.
    return incident;
  }

  /// Persist filters locally.
  Future<void> saveFilters(Map<String, dynamic> filters) => local.saveFilters(filters);

  /// Load persisted filters.
  Future<Map<String, dynamic>> loadFilters() => local.loadFilters();
}

