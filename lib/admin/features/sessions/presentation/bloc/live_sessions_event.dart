part of 'live_sessions_bloc.dart';

/// Base event.
abstract class LiveSessionsEvent extends Equatable {
  const LiveSessionsEvent();

  @override
  List<Object?> get props => [];
}

/// Connect to live stream.
class LiveSessionsConnectRequested extends LiveSessionsEvent {
  const LiveSessionsConnectRequested();
}

/// Disconnect from live stream.
class LiveSessionsDisconnectRequested extends LiveSessionsEvent {
  const LiveSessionsDisconnectRequested();
}

/// Pin a session.
class LiveSessionsPinRequested extends LiveSessionsEvent {
  const LiveSessionsPinRequested(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

/// Internal event: Stream event received.
class LiveSessionsStreamEventReceived extends LiveSessionsEvent {
  const LiveSessionsStreamEventReceived(this.event);

  final AdminLiveSessionEventDto event;

  @override
  List<Object?> get props => [event];
}

/// Internal event: Stream error received.
class LiveSessionsStreamErrorReceived extends LiveSessionsEvent {
  const LiveSessionsStreamErrorReceived(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

