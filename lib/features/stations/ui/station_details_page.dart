/// File: lib/features/stations/ui/station_details_page.dart
/// Purpose: Detailed station view
/// Belongs To: stations feature
/// Route: /stationDetails/:id
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../models/models.dart';
import '../../../repositories/station_repository.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/loading_wrapper.dart';
import '../widgets/station_header_info.dart';
import '../widgets/station_info_cards.dart';
import '../widgets/station_charger_list.dart';
import '../widgets/station_amenities.dart';

/// Station details page showing full information.
class StationDetailsPage extends StatefulWidget {
  const StationDetailsPage({super.key, required this.stationId});

  final String stationId;

  @override
  State<StationDetailsPage> createState() => _StationDetailsPageState();
}

class _StationDetailsPageState extends State<StationDetailsPage> {
  final _stationRepository = DummyStationRepository();
  StationModel? _station;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStation();
  }

  Future<void> _loadStation() async {
    final station = await _stationRepository.getStationById(widget.stationId);
    if (mounted) {
      setState(() {
        _station = station;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWrapper(
        isLoading: _isLoading,
        error: _station == null && !_isLoading ? 'Station not found' : null,
        child: _station != null ? _buildContent() : const SizedBox(),
      ),
      bottomSheet: _station != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StationHeaderInfo(station: _station!),
                SizedBox(height: 24.h),
                StationInfoCards(station: _station!),
                SizedBox(height: 24.h),
                StationChargerList(chargers: _station!.chargers),
                SizedBox(height: 24.h),
                StationAmenities(amenities: _station!.amenities),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      leading: _buildBackButton(),
      actions: [_buildFavoriteButton()],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: _station!.imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.outlineLight),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.outlineLight,
            child: Icon(Iconsax.image, size: 48.r, color: AppColors.textTertiaryLight),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8)],
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, size: 18.r),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () async {
        await _stationRepository.toggleFavorite(_station!.id);
        _loadStation();
      },
      child: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8)],
        ),
        child: Icon(
          _station!.isFavorite ? Iconsax.heart5 : Iconsax.heart,
          size: 20.r,
          color: _station!.isFavorite ? AppColors.error : AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CommonButton(
                label: AppStrings.getDirections,
                variant: ButtonVariant.outlined,
                icon: Iconsax.location,
                onPressed: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CommonButton(
                label: AppStrings.bookNow,
                icon: Iconsax.flash_1,
                onPressed: () => context.push(AppRoutes.booking.id(_station!.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

