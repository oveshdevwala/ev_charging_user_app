/// File: lib/features/search/presentation/widgets/station_bottom_sheet.dart
/// Purpose: Compact quick-details bottom sheet for station preview from map
/// Belongs To: search feature
/// Customization Guide:
///    - This is a quick preview, full details are in StationDetailsPage
///    - Keep it compact and focused on essential info only
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/station_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/common_button.dart';

/// Compact bottom sheet for quick station preview.
/// Navigate to StationDetailsPage for full details.
class StationBottomSheet extends StatelessWidget {
  const StationBottomSheet({required this.station, super.key});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      initialChildSize: 0.54,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Station Name
                      Text(
                        station.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 18.r,
                            color: AppColors.ratingActive,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${station.rating.toStringAsFixed(1)} (${station.reviewCount})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18.r,
                            color: colors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              station.address,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: colors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Price Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '\$${station.pricePerKwh.toStringAsFixed(2)}/kWh',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Charger Types
                      if (station.chargers.isNotEmpty) ...[
                        Text(
                          AppStrings.chargerTypes,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: station.chargers
                              .map(
                                (charger) => _buildChargerChip(
                                  context,
                                  charger.typeDisplayName,
                                  charger.powerDisplay,
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      // Availability Status
                      Row(
                        children: [
                          _buildAvailabilityChip(
                            context,
                            'Available',
                            station.availableChargers,
                            AppColors.available,
                          ),
                          SizedBox(width: 12.w),
                          _buildAvailabilityChip(
                            context,
                            'Occupied',
                            station.totalChargers - station.availableChargers,
                            AppColors.occupied,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CommonButton(
                              label: AppStrings.tripPlannerNavigate,
                              onPressed: () => _openDirections(context),
                              icon: Icons.directions,
                              variant: ButtonVariant.outlined,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CommonButton(
                              label: AppStrings.viewDetails,
                              onPressed: () {
                                Navigator.pop(context);
                                context.pushToWithId(
                                  AppRoutes.stationDetails,
                                  station.id,
                                );
                              },
                              icon: Icons.info_outline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChargerChip(BuildContext context, String type, String power) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '$type $power',
        style: TextStyle(
          fontSize: 12.sp,
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAvailabilityChip(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(BuildContext context) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination='
      '${station.latitude},${station.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        context.showErrorSnackBar('Could not open directions');
      }
    }
  }
}
