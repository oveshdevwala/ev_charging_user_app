/// File: lib/features/search/ui/search_page.dart
/// Purpose: Station search screen
/// Belongs To: search feature
/// Route: /userSearch
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
import '../../../widgets/common_text_field.dart';
import '../../../widgets/loading_wrapper.dart';
import '../../../widgets/station_card.dart';

/// Search page for finding charging stations.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _stationRepository = DummyStationRepository();
  List<StationModel> _stations = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    setState(() => _isLoading = true);
    final stations = await _stationRepository.getStations();
    if (mounted) {
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchStations(String query) async {
    setState(() {
      _searchQuery = query;
      _isLoading = true;
    });

    final stations = query.isEmpty
        ? await _stationRepository.getStations()
        : await _stationRepository.searchStations(query);

    if (mounted) {
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.findChargingStation,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  controller: _searchController,
                  hint: AppStrings.searchForStations,
                  prefixIcon: Iconsax.search_normal,
                  onChanged: _searchStations,
                ),
              ),
              SizedBox(width: 12.w),
              _buildFilterButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 52.r,
      height: 52.r,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(Iconsax.setting_4, size: 22.r, color: Colors.white),
    );
  }

  Widget _buildResults() {
    return LoadingWrapper(
      isLoading: _isLoading,
      isEmpty: _stations.isEmpty,
      emptyTitle: AppStrings.noStationsFound,
      emptyIcon: Iconsax.search_status,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _stations.length,
        itemBuilder: (context, index) {
          final station = _stations[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: StationCard(
              station: station,
              compact: true,
              onTap: () => context.push(AppRoutes.stationDetails.id(station.id)),
              onFavoriteTap: () async {
                await _stationRepository.toggleFavorite(station.id);
                await _searchStations(_searchQuery);
              },
            ),
          );
        },
      ),
    );
  }
}

