/// File: lib/admin/features/sessions/di/sessions_di.dart
/// Purpose: Dependency registration for sessions feature
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace with actual DI container wiring when available
library;

import 'package:dio/dio.dart';

import '../data/sessions_repository_impl.dart';
import '../data/sessions_sources.dart';
import '../domain/sessions_repository.dart';
import '../domain/sessions_usecases.dart';

/// Simple factory to build repository and use cases.
class SessionsModule {
  SessionsModule._();

  static AdminSessionsRepository buildRepository(Dio dio, {bool devMode = true}) {
    return AdminSessionsRepositoryImpl(
      remote: AdminSessionsRemoteSource(dio: dio, devMode: devMode),
      local: const AdminSessionsLocalSource(),
      stream: AdminSessionsStreamSource(devMode: devMode),
    );
  }

  static ({
    GetSessionsUseCase getSessions,
    GetSessionDetailUseCase getDetail,
    StreamLiveSessionsUseCase streamLive,
    ExportSessionsUseCase exportSessions,
    CreateIncidentUseCase createIncident,
  }) useCases(AdminSessionsRepository repository) {
    return (
      getSessions: GetSessionsUseCase(repository),
      getDetail: GetSessionDetailUseCase(repository),
      streamLive: StreamLiveSessionsUseCase(repository),
      exportSessions: ExportSessionsUseCase(repository),
      createIncident: CreateIncidentUseCase(repository),
    );
  }
}

