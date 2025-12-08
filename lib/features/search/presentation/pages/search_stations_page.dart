/// File: lib/features/search/presentation/pages/search_stations_page.dart
/// Purpose: Main search stations page with list/map toggle
/// Belongs To: search feature
/// Route: AppRoutes.userSearch
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/services/recent_stations_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/station_model.dart';
import '../../../../repositories/station_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/widgets.dart';
import '../../domain/station_usecases.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../pages/stations_list_page.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/map_view_page.dart';

/// Main search stations page with list and map views.
class SearchStationsPage extends StatefulWidget {
  const SearchStationsPage({super.key});

  @override
  State<SearchStationsPage> createState() => _SearchStationsPageState();
}

class _SearchStationsPageState extends State<SearchStationsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isMapView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: AppStrings.findChargingStation,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
            tooltip: _isMapView ? 'List View' : 'Map View',
          ),
          BlocBuilder<FilterCubit, StationFilters>(
            builder: (context, filters) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterSheet(context),
                    tooltip: AppStrings.filter,
                  ),
                  if (filters.hasActiveFilters)
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: context.appColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.r),
            child: CommonTextField(
              controller: _searchController,
              hint: AppStrings.searchForStations,
              prefixIcon: Icons.search,
              suffixIcon: _searchController.text.isNotEmpty
                  ? Icons.clear
                  : null,
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              onSuffixTap: () {
                _searchController.clear();
                context.read<SearchBloc>().add(const ClearSearch());
              },
            ),
          ),
          // Content
          Expanded(
            child: _isMapView ? const MapViewPage() : const _StationListView(),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    // Capture the FilterCubit from the current context before showing the sheet
    final filterCubit = context.read<FilterCubit>();
    final searchBloc = context.read<SearchBloc>();

    showBottomSheet(
      context: context,

      // isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: filterCubit),
          BlocProvider.value(value: searchBloc),
        ],
        child: const FilterSheet(),
      ),
    );
  }
}

/// Station list view widget.
class _StationListView extends StatefulWidget {
  const _StationListView();

  @override
  State<_StationListView> createState() => _StationListViewState();
}

class _StationListViewState extends State<_StationListView> {
  List<StationModel> _nearbyStations = [];
  List<StationModel> _recentStations = [];
  List<StationModel> _favoriteStations = [];
  bool _isLoading = true;
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreloadedStations();
    });
  }

  Future<void> _loadPreloadedStations() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final stationRepository = sl<StationRepository>();
      final recentService = sl<RecentStationsService>();

      // Load nearby stations (using default SF location if permission denied)
      try {
        final position = await Geolocator.getCurrentPosition();
        final nearby = await stationRepository.getNearbyStations(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        _nearbyStations = nearby.take(4).toList();
      } catch (e) {
        // Fallback to default location
        final nearby = await stationRepository.getNearbyStations(
          latitude: 37.7749,
          longitude: -122.4194,
        );
        _nearbyStations = nearby.take(4).toList();
      }

      // Load recent stations (limit to 4 for preview)
      final recent = await recentService.getRecentStations();
      _recentStations = recent.take(4).toList();

      // Load favorite stations (limit to 4 for preview)
      final favorites = await stationRepository.getFavoriteStations();
      _favoriteStations = favorites.take(4).toList();
    } catch (e) {
      // Handle error silently - ensure lists are initialized
      _nearbyStations = _nearbyStations;
      _recentStations = _recentStations;
      _favoriteStations = _favoriteStations;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasLoadedOnce = true;
        });
      }
    }
  }

  void _onStationTap(StationModel station) {
    // Add to recent stations
    sl<RecentStationsService>().addRecentStation(station.id);

    // Navigate to details
    context.pushToWithId(AppRoutes.stationDetails, station.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        // Show search results if there's a query
        if (state is SearchLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchLoadFailure) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              context.read<SearchBloc>().add(const RefreshRequested());
            },
          );
        }

        if (state is SearchLoadSuccess) {
          if (state.stations.isEmpty) {
            return const EmptyStateWidget(
              title: AppStrings.noStationsFound,
              message: 'Try adjusting your search or filters',
              icon: Icons.ev_station_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<SearchBloc>().add(const RefreshRequested());
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: state.stations.length,
              itemBuilder: (context, index) {
                final station = state.stations[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: StationCard(
                    station: station,
                    onTap: () => _onStationTap(station),
                    onFavoriteTap: () {
                      // Handle favorite toggle
                    },
                  ),
                );
              },
            ),
          );
        }

        // Show preloaded sections when no search query
        if (_isLoading && !_hasLoadedOnce) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _loadPreloadedStations,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            children: [
              // Nearby Stations Section
              if (_nearbyStations.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  AppStrings.nearbyStations,
                  Icons.near_me,
                  onViewAll: () {
                    context.push(
                      AppRoutes.stationsList.path,
                      extra: StationsListType.nearby,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                ..._nearbyStations
                    .take(4)
                    .map(
                      (station) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: StationCard(
                          station: station,
                          onTap: () => _onStationTap(station),
                          onFavoriteTap: () async {
                            final repo = sl<StationRepository>();
                            await repo.toggleFavorite(station.id);
                            await _loadPreloadedStations();
                          },
                          compact: true,
                        ),
                      ),
                    ),
                SizedBox(height: 20.h),
              ],
              // Recent Stations Section
              if (_recentStations.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Recent Stations',
                  Icons.history,
                  onViewAll: () {
                    context.push(
                      AppRoutes.stationsList.name,
                      extra: StationsListType.recent,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                ..._recentStations
                    .take(4)
                    .map(
                      (station) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: StationCard(
                          station: station,
                          onTap: () => _onStationTap(station),
                          onFavoriteTap: () async {
                            final repo = sl<StationRepository>();
                            await repo.toggleFavorite(station.id);
                            await _loadPreloadedStations();
                          },
                          compact: true,
                        ),
                      ),
                    ),
                SizedBox(height: 20.h),
              ],
              // Favorite Stations Section
              if (_favoriteStations.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  AppStrings.favorites,
                  Icons.favorite,
                  onViewAll: () {
                    context.push(
                      AppRoutes.stationsList.name,
                      extra: StationsListType.favorites,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                ..._favoriteStations
                    .take(4)
                    .map(
                      (station) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: StationCard(
                          station: station,
                          onTap: () => _onStationTap(station),
                          onFavoriteTap: () async {
                            final repo = sl<StationRepository>();
                            await repo.toggleFavorite(station.id);
                            await _loadPreloadedStations();
                          },
                          compact: true,
                        ),
                      ),
                    ),
              ],
              // Empty state if no preloaded stations
              if (_nearbyStations.isEmpty &&
                  _recentStations.isEmpty &&
                  _favoriteStations.isEmpty)
                const EmptyStateWidget(
                  title: 'Start Searching',
                  message:
                      'Enter a location or station name to find charging stations',
                  icon: Icons.search,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onViewAll,
  }) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.r, color: colors.primary),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              AppStrings.seeAll,
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
