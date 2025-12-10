part of 'live_sessions_bloc.dart';

/// Connection state.
enum LiveSessionsStatus { disconnected, connecting, connected, error }

/// State for live sessions.
class LiveSessionsState extends Equatable {
  const LiveSessionsState({
    this.status = LiveSessionsStatus.disconnected,
    this.events = const [],
    this.pinnedSessionId,
    this.error,
  });

  final LiveSessionsStatus status;
  final List<AdminLiveSessionEventDto> events;
  final String? pinnedSessionId;
  final String? error;

  LiveSessionsState copyWith({
    LiveSessionsStatus? status,
    List<AdminLiveSessionEventDto>? events,
    String? pinnedSessionId,
    String? error,
  }) {
    return LiveSessionsState(
      status: status ?? this.status,
      events: events ?? this.events,
      pinnedSessionId: pinnedSessionId ?? this.pinnedSessionId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, events, pinnedSessionId, error];
}

