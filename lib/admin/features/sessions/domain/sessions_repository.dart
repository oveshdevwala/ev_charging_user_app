/// File: lib/admin/features/sessions/domain/sessions_repository.dart
/// Purpose: Domain repository contract for sessions monitoring
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Swap implementations without touching UI
///    - Keep interfaces stable for BLoC usecases
library;

import '../data/session_models.dart';

/// Contract for fetching and streaming sessions data.
abstract class AdminSessionsRepository {
  Future<AdminSessionsPageDto> fetchSessions({
    String? cursor,
    int limit,
    Map<String, dynamic>? filters,
  });

  Future<AdminSessionDetailDto> fetchSessionDetail(String sessionId);

  Stream<AdminLiveSessionEventDto> streamLiveSessions();

  Future<String> requestExport({
    required List<String> sessionIds,
    required String format,
  });

  Future<AdminIncidentDto> createIncident(AdminIncidentDto incident);
}

