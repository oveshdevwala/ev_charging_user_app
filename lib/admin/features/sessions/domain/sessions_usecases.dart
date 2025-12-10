/// File: lib/admin/features/sessions/domain/sessions_usecases.dart
/// Purpose: Use cases for sessions monitoring module
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Extend with additional analytics or alert rules
///    - Keep usecases thin wrappers over repository
library;

import 'sessions_repository.dart';
import '../data/session_models.dart';

/// Fetch paginated sessions list.
class GetSessionsUseCase {
  const GetSessionsUseCase(this.repository);

  final AdminSessionsRepository repository;

  Future<AdminSessionsPageDto> call({
    String? cursor,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) {
    return repository.fetchSessions(cursor: cursor, limit: limit, filters: filters);
  }
}

/// Fetch full session detail with telemetry.
class GetSessionDetailUseCase {
  const GetSessionDetailUseCase(this.repository);

  final AdminSessionsRepository repository;

  Future<AdminSessionDetailDto> call(String sessionId) {
    return repository.fetchSessionDetail(sessionId);
  }
}

/// Stream live session events.
class StreamLiveSessionsUseCase {
  const StreamLiveSessionsUseCase(this.repository);

  final AdminSessionsRepository repository;

  Stream<AdminLiveSessionEventDto> call() {
    return repository.streamLiveSessions();
  }
}

/// Trigger export job for sessions.
class ExportSessionsUseCase {
  const ExportSessionsUseCase(this.repository);

  final AdminSessionsRepository repository;

  Future<String> call({
    required List<String> ids,
    required String format,
  }) {
    return repository.requestExport(sessionIds: ids, format: format);
  }
}

/// Create incident from a session context.
class CreateIncidentUseCase {
  const CreateIncidentUseCase(this.repository);

  final AdminSessionsRepository repository;

  Future<AdminIncidentDto> call(AdminIncidentDto payload) {
    return repository.createIncident(payload);
  }
}

