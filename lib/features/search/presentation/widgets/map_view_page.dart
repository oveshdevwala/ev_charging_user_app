/// File: lib/features/search/presentation/widgets/map_view_page.dart
/// Purpose: Map view with markers and clustering
/// Belongs To: search feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/station_model.dart';
import '../../data/station_api_service.dart' as search_api;
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import 'map_controls.dart';
import 'station_bottom_sheet.dart';
import 'station_map_marker.dart';

/// Map view page with markers and clustering.
class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    // Load initial stations after a short delay to ensure map is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialStations();
    });
  }

  void _loadInitialStations() {
    if (!mounted) return;
    // Load stations for initial bounds (default SF area)
    const initialBounds = search_api.Bounds(
      north: 37.8,
      south: 37.7,
      east: -122.3,
      west: -122.5,
    );
    context.read<MapBloc>().add(const LoadMarkersForBounds(initialBounds));
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final location = LatLng(position.latitude, position.longitude);
      setState(() {
        _userLocation = location;
      });

      // Move map to user location first
      _mapController.move(location, 13);

      // UserLocationUpdated will handle loading stations, no need for duplicate load
      context.read<MapBloc>().add(UserLocationUpdated(location));
    } catch (e) {
      // Handle error silently - user can still use map
      if (mounted) {
        _loadInitialStations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapLoaded && state.selectedStation != null) {
          _showStationBottomSheet(context, state.selectedStation!);
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.r,
                    color: context.appColors.danger,
                  ),
                  SizedBox(height: 16.h),
                  Text(state.message),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MapBloc>().add(
                        LoadMarkersForBounds(_getCurrentBounds()),
                      );
                    },
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          final stations = state is MapLoaded
              ? state.stations
              : <StationModel>[];

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      _userLocation ?? const LatLng(37.7749, -122.4194),
                  initialZoom: _userLocation != null ? 13.0 : 12.0,
                  minZoom: 5,
                  maxZoom: 18,
                  onMapEvent: (event) {
                    if (event is MapEventMoveEnd) {
                      final bounds = _getCurrentBounds();
                      context.read<MapBloc>().add(MapMoved(bounds));
                    }
                  },
                ),
                children: [
                  // Tile layer
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.evcharging.app',
                  ),
                  // Marker cluster layer
                  if (stations.isNotEmpty)
                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        size: Size(50.r, 50.r),
                        markers: stations.map((station) {
                          return Marker(
                            point: LatLng(station.latitude, station.longitude),
                            width: 50.r,
                            height: 50.r,
                            child: StationMapMarker(
                              station: station,
                              onTap: () {
                                context.read<MapBloc>().add(
                                  MarkerTapped(station.id),
                                );
                              },
                            ),
                          );
                        }).toList(),
                        builder: (context, markers) {
                          final count = markers.length;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.appColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  // User location marker
                  if (_userLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _userLocation!,
                          width: 30.r,
                          height: 30.r,
                          child: Icon(
                            Icons.my_location,
                            color: context.appColors.primary,
                            size: 30.r,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Map controls
              Positioned(
                bottom: 16.h,
                right: 16.w,
                child: MapControls(
                  mapController: _mapController,
                  onMyLocationTap: _getCurrentLocation,
                ),
              ),
              // Loading indicator
              if (state is MapLoading)
                Positioned(
                  top: 16.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.appColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Loading stations...',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  search_api.Bounds _getCurrentBounds() {
    final bounds = _mapController.camera.visibleBounds;
    return search_api.Bounds(
      north: bounds.north,
      south: bounds.south,
      east: bounds.east,
      west: bounds.west,
    );
  }

  void _showStationBottomSheet(BuildContext context, StationModel station) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StationBottomSheet(station: station),
    ).then((_) {
      context.read<MapBloc>().add(const ClearSelectedStation());
    });
  }
}
