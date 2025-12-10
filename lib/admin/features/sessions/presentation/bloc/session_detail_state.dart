part of 'session_detail_bloc.dart';

/// State for session detail.
class SessionDetailState extends Equatable {
  const SessionDetailState({
    this.isLoading = false,
    this.streaming = false,
    this.isSubmittingIncident = false,
    this.detail,
    this.lastIncident,
    this.error,
    this.liveEvents = const [],
  });

  final bool isLoading;
  final bool streaming;
  final bool isSubmittingIncident;
  final AdminSessionDetailDto? detail;
  final AdminIncidentDto? lastIncident;
  final String? error;
  final List<AdminLiveSessionEventDto> liveEvents;

  SessionDetailState copyWith({
    bool? isLoading,
    bool? streaming,
    bool? isSubmittingIncident,
    AdminSessionDetailDto? detail,
    AdminIncidentDto? lastIncident,
    String? error,
    List<AdminLiveSessionEventDto>? liveEvents,
  }) {
    return SessionDetailState(
      isLoading: isLoading ?? this.isLoading,
      streaming: streaming ?? this.streaming,
      isSubmittingIncident: isSubmittingIncident ?? this.isSubmittingIncident,
      detail: detail ?? this.detail,
      lastIncident: lastIncident ?? this.lastIncident,
      error: error,
      liveEvents: liveEvents ?? this.liveEvents,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        streaming,
        isSubmittingIncident,
        detail,
        lastIncident,
        error,
        liveEvents,
      ];
}

