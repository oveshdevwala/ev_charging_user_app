/// File: lib/features/search/search.dart
/// Purpose: Barrel file for search feature exports
/// Belongs To: search feature
library;

// BLoC (legacy - kept for compatibility)
export 'bloc/search_cubit.dart';
export 'bloc/search_state.dart' hide SearchState;
// Data
export 'data/station_api_service.dart';
export 'data/station_repository_impl.dart';
// Domain
export 'domain/station_repository.dart';
export 'domain/station_usecases.dart';
// Presentation BLoC
export 'presentation/bloc/filter_cubit.dart';
export 'presentation/bloc/map_bloc.dart';
export 'presentation/bloc/map_event.dart';
export 'presentation/bloc/map_state.dart';
export 'presentation/bloc/search_bloc.dart';
export 'presentation/bloc/search_event.dart';
export 'presentation/bloc/search_state.dart';
// UI
export 'presentation/pages/search_stations_page.dart';
// Widgets
export 'presentation/widgets/filter_sheet.dart';
export 'presentation/widgets/map_controls.dart';
export 'presentation/widgets/map_view_page.dart';
export 'presentation/widgets/station_bottom_sheet.dart';
export 'presentation/widgets/station_map_marker.dart';
export 'ui/search_page.dart';

