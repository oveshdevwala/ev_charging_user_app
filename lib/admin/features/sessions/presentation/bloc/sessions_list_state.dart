part of 'sessions_list_bloc.dart';

/// State for sessions list.
class SessionsListState extends Equatable {
  const SessionsListState({
    this.isLoading = false,
    this.isExporting = false,
    this.sessions = const [],
    this.cursor,
    this.hasMore = false,
    this.error,
    this.filters = const {},
    this.pageSize = 20,
    Set<String>? selectedIds,
  }) : selectedIds = selectedIds ?? const {};

  final bool isLoading;
  final bool isExporting;
  final List<AdminSessionSummaryDto> sessions;
  final String? cursor;
  final bool hasMore;
  final String? error;
  final Map<String, dynamic> filters;
  final int pageSize;
  final Set<String> selectedIds;

  SessionsListState copyWith({
    bool? isLoading,
    bool? isExporting,
    List<AdminSessionSummaryDto>? sessions,
    String? cursor,
    bool? hasMore,
    String? error,
    Map<String, dynamic>? filters,
    int? pageSize,
    Set<String>? selectedIds,
  }) {
    return SessionsListState(
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      sessions: sessions ?? this.sessions,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filters: filters ?? this.filters,
      pageSize: pageSize ?? this.pageSize,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isExporting,
        sessions,
        cursor,
        hasMore,
        error,
        filters,
        pageSize,
        selectedIds,
      ];
}

