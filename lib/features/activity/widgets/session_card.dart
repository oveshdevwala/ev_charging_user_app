/// File: lib/features/activity/widgets/session_card.dart
/// Purpose: Charging session card for activity history
/// Belongs To: activity feature
/// Customization Guide:
///    - Customize card appearance via params
///    - Used in sessions list
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/charging_session_model.dart';

/// Charging session card widget.
class SessionCard extends StatelessWidget {
  const SessionCard({
    required this.session,
    super.key,
    this.onTap,
    this.isCompact = false,
  });

  /// Session data.
  final ChargingSessionModel session;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Compact mode.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isCompact ? 12.r : 16.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineLight),
        ),
        child: Row(
          children: [
            // Station image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildStationImage(),
            ),
            SizedBox(width: 12.w),

            // Session details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.stationName,
                          style: TextStyle(
                            fontSize: isCompact ? 13.sp : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${session.formattedDate} · ${session.formattedTime}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildMetric(
                        icon: Iconsax.flash_1,
                        value: '${session.energyKwh.toStringAsFixed(1)} kWh',
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 16.w),
                      _buildMetric(
                        icon: Iconsax.clock,
                        value: session.formattedDuration,
                        color: AppColors.secondary,
                      ),
                      const Spacer(),
                      Text(
                        '\$${session.cost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: isCompact ? 50.r : 60.r,
      height: isCompact ? 50.r : 60.r,
      color: AppColors.surfaceVariantLight,
      child: Icon(
        Iconsax.flash_1,
        size: 24.r,
        color: AppColors.textTertiaryLight,
      ),
    );
  }

  Widget _buildStationImage() {
    final imageUrl = session.stationImageUrl;
    
    // Check if URL is valid
    final isValidUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (!isValidUrl) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: isCompact ? 50.r : 60.r,
      height: isCompact ? 50.r : 60.r,
      fit: BoxFit.cover,
      placeholder: (_, __) => _buildPlaceholder(),
      errorWidget: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String text;

    switch (session.status) {
      case SessionStatus.completed:
        bgColor = AppColors.success.withValues(alpha: 0.12);
        textColor = AppColors.successDark;
        text = 'Completed';
      case SessionStatus.inProgress:
        bgColor = AppColors.primary.withValues(alpha: 0.12);
        textColor = AppColors.primary;
        text = 'Charging';
      case SessionStatus.cancelled:
        bgColor = AppColors.warning.withValues(alpha: 0.12);
        textColor = AppColors.warningDark;
        text = 'Cancelled';
      case SessionStatus.failed:
        bgColor = AppColors.error.withValues(alpha: 0.12);
        textColor = AppColors.error;
        text = 'Failed';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
