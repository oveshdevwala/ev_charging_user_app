/// File: lib/features/favorites/ui/favorites_page.dart
/// Purpose: Favorite stations screen
/// Belongs To: favorites feature
/// Route: /userFavorites
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/station_model.dart';
import '../../../repositories/station_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/loading_wrapper.dart';
import '../../../widgets/station_card.dart';

/// Favorites page showing saved charging stations.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _stationRepository = DummyStationRepository();
  List<StationModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _stationRepository.getFavoriteStations();
    if (mounted) {
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Text(
        AppStrings.favorites,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LoadingWrapper(
      isLoading: _isLoading,
      isEmpty: _favorites.isEmpty,
      emptyTitle: AppStrings.noFavorites,
      emptyMessage: 'Save your favorite stations for quick access',
      emptyIcon: Iconsax.heart,
      child: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            final station = _favorites[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: StationCard(
                station: station,
                onTap: () =>
                    context.push(AppRoutes.stationDetails.id(station.id)),
                onFavoriteTap: () async {
                  await _stationRepository.toggleFavorite(station.id);
                await  _loadFavorites();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
