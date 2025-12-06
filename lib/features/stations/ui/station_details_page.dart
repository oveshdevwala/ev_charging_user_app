/// File: lib/features/stations/ui/station_details_page.dart
/// Purpose: Detailed station view
/// Belongs To: stations feature
/// Route: /stationDetails/:id
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/models.dart';
import '../../../repositories/station_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/loading_wrapper.dart';
import '../../community/community.dart';
import '../widgets/station_amenities.dart';
import '../widgets/station_charger_list.dart';
import '../widgets/station_header_info.dart';
import '../widgets/station_info_cards.dart';

/// Station details page showing full information.
class StationDetailsPage extends StatefulWidget {
  const StationDetailsPage({required this.stationId, super.key});

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
      bottomSheet: _station != null ? _buildBottomBar(context) : null,
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StationHeaderInfo(
                  station: _station!,
                  onRatingTap: _navigateToCommunity,
                ),
                SizedBox(height: 24.h),
                StationInfoCards(station: _station!),
                SizedBox(height: 24.h),
                StationChargerList(chargers: _station!.chargers),
                SizedBox(height: 24.h),
                StationAmenities(amenities: _station!.amenities),
                SizedBox(height: 24.h),
                _buildCommunitySection(context),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySection(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.communityTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: _navigateToCommunity,
              child: Row(
                children: [
                  Text(
                    AppStrings.seeAll,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Iconsax.arrow_right_3,
                    size: 16.r,
                    color: colors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Community panel
        CommunityPanel(
          stationId: _station!.id,
          onWriteReview: _navigateToReview,
          onAskQuestion: () => _navigateToCommunity(tab: CommunityTab.qa),
          onReportIssue: _showReportModal,
          onViewAllReviews: _navigateToCommunity,
          onViewAllPhotos: () => _navigateToCommunity(tab: CommunityTab.photos),
          onViewAllQuestions: () => _navigateToCommunity(tab: CommunityTab.qa),
        ),
      ],
    );
  }

  void _navigateToCommunity({CommunityTab tab = CommunityTab.reviews}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => StationCommunityPage(
          stationId: _station!.id,
          stationName: _station!.name,
          initialTab: tab,
        ),
      ),
    );
  }

  void _navigateToReview() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LeaveReviewPage(
          stationId: _station!.id,
          stationName: _station!.name,
        ),
      ),
    );
  }

  void _showReportModal() {
    ReportModal.show(
      context: context,
      targetType: ReportTargetType.station,
      targetId: _station!.id,
      onSubmit: (category, description, isAnonymous) async {
        final repo = DummyCommunityRepository();
        return repo.createReport(
          targetType: ReportTargetType.station,
          targetId: _station!.id,
          category: category,
          description: description,
          anonymous: isAnonymous,
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      leading: _buildBackButton(context),
      actions: [_buildFavoriteButton(context)],
      flexibleSpace: FlexibleSpaceBar(background: _buildHeaderImage(context)),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8)],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.r,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: () async {
        await _stationRepository.toggleFavorite(_station!.id);
        await _loadStation();
      },
      child: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8)],
        ),
        child: Icon(
          _station!.isFavorite ? Iconsax.heart5 : Iconsax.heart,
          size: 20.r,
          color: _station!.isFavorite ? colors.danger : colors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CommonButton(
                label: AppStrings.getLocation,
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
                onPressed: () =>
                    context.push(AppRoutes.booking.id(_station!.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    final colors = context.appColors;
    final imageUrl = _station?.imageUrl;

    // Check if URL is valid
    final isValidUrl =
        imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (!isValidUrl) {
      return ColoredBox(
        color: colors.surfaceVariant,
        child: Center(
          child: Icon(
            Iconsax.building_4,
            size: 64.r,
            color: colors.textTertiary,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: colors.outline),
      errorWidget: (_, __, ___) => ColoredBox(
        color: colors.outline,
        child: Icon(Iconsax.image, size: 48.r, color: colors.textTertiary),
      ),
    );
  }
}
