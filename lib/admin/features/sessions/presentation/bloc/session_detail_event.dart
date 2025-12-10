part of 'session_detail_bloc.dart';

/// Base event.
abstract class SessionDetailEvent extends Equatable {
  const SessionDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load a specific session.
class SessionDetailLoadRequested extends SessionDetailEvent {
  const SessionDetailLoadRequested(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

/// Start telemetry streaming.
class SessionTelemetryStreamStarted extends SessionDetailEvent {
  const SessionTelemetryStreamStarted(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

/// Stop telemetry streaming.
class SessionTelemetryStreamStopped extends SessionDetailEvent {
  const SessionTelemetryStreamStopped();
}

/// Create incident from session.
class SessionIncidentRequested extends SessionDetailEvent {
  const SessionIncidentRequested(this.payload);

  final AdminIncidentDto payload;

  @override
  List<Object?> get props => [payload];
}

