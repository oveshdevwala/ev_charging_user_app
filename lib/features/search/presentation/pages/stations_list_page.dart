/// File: lib/features/search/presentation/pages/stations_list_page.dart
/// Purpose: Paginated list page for stations (Nearby/Recent/Favorites)
/// Belongs To: search feature
/// Route: AppRoutes.stationsList
/// Customization Guide:
///    - Supports pagination with loading delays
///    - Shows 20-24 stations per page
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/services/recent_stations_service.dart';
import '../../../../models/station_model.dart';
import '../../../../repositories/station_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/widgets.dart';

/// Paginated stations list page.
class StationsListPage extends StatefulWidget {
  const StationsListPage({required this.listType, super.key});

  final StationsListType listType;

  @override
  State<StationsListPage> createState() => _StationsListPageState();
}

enum StationsListType { nearby, recent, favorites }

class _StationsListPageState extends State<StationsListPage> {
  final ScrollController _scrollController = ScrollController();
  List<StationModel> _stations = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadStations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMoreStations();
    }
  }

  Future<void> _loadStations() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });

    try {
      final stationRepository = sl<StationRepository>();
      final recentService = sl<RecentStationsService>();

      var stations = <StationModel>[];

      switch (widget.listType) {
        case StationsListType.nearby:
          try {
            final position = await Geolocator.getCurrentPosition();
            stations = await stationRepository.getNearbyStations(
              latitude: position.latitude,
              longitude: position.longitude,
            );
          } catch (e) {
            stations = await stationRepository.getNearbyStations(
              latitude: 37.7749,
              longitude: -122.4194,
            );
          }
          break;
        case StationsListType.recent:
          stations = await recentService.getRecentStations();
          break;
        case StationsListType.favorites:
          stations = await stationRepository.getFavoriteStations();
          break;
      }

      // Generate more stations for pagination (dummy data)
      if (stations.length < _pageSize) {
        final moreStations = await _generateDummyStationsForPagination(
          stations,
          _pageSize - stations.length,
        );
        stations = [...stations, ...moreStations];
      }

      setState(() {
        _stations = stations.take(_pageSize).toList();
        _hasMore = stations.length >= _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreStations() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;

      // Generate more dummy stations
      final moreStations = await _generateDummyStationsForPagination(
        _stations,
        _pageSize,
        startIndex: _stations.length,
      );

      setState(() {
        _stations = [..._stations, ...moreStations];
        _currentPage = nextPage;
        _hasMore = moreStations.length >= _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<List<StationModel>> _generateDummyStationsForPagination(
    List<StationModel> existingStations,
    int count, {
    int startIndex = 0,
  }) async {
    final stationRepository = sl<StationRepository>();
    final allStations = await stationRepository.getStations(limit: 100);

    // Generate dummy stations based on existing ones or all stations
    final baseStations = existingStations.isNotEmpty
        ? existingStations
        : allStations.take(10).toList();

    if (baseStations.isEmpty) {
      return [];
    }

    final dummyStations = <StationModel>[];
    for (var i = 0; i < count; i++) {
      final baseIndex = i % baseStations.length;
      final baseStation = baseStations[baseIndex];

      final suffix = ' ${startIndex + i + 1}';
      dummyStations.add(
        baseStation.copyWith(
          id: 'dummy_${widget.listType.name}_${startIndex + i}',
          name: '${baseStation.name}$suffix',
          latitude: baseStation.latitude + (i * 0.01),
          longitude: baseStation.longitude + (i * 0.01),
          rating: 4.0 + (i % 5) * 0.2,
          reviewCount: 50 + (startIndex + i) * 10,
          pricePerKwh: 0.30 + (i % 5) * 0.05,
          distance: (startIndex + i + 1) * 0.5,
        ),
      );
    }

    return dummyStations;
  }

  void _onStationTap(StationModel station) {
    sl<RecentStationsService>().addRecentStation(station.id);
    context.pushToWithId(AppRoutes.stationDetails, station.id);
  }

  String _getTitle() {
    switch (widget.listType) {
      case StationsListType.nearby:
        return AppStrings.nearbyStations;
      case StationsListType.recent:
        return 'Recent Stations';
      case StationsListType.favorites:
        return AppStrings.favorites;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: _getTitle()),
      body: _isLoading && _stations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStations,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: _stations.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _stations.length) {
                    return Padding(
                      padding: EdgeInsets.all(16.r),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final station = _stations[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: StationCard(
                      station: station,
                      onTap: () => _onStationTap(station),
                      onFavoriteTap: () async {
                        final repo = sl<StationRepository>();
                        await repo.toggleFavorite(station.id);
                        if (widget.listType == StationsListType.favorites) {
                          await _loadStations();
                        }
                      },
                      compact: true,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
