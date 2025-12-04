/// File: lib/features/home/widgets/components/bundle_card.dart
/// Purpose: Bundle/subscription card for recommendations
/// Belongs To: home feature
/// Customization Guide:
///    - Customize colors and badges via params
///    - Supports discount display and popular badge
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/bundle_model.dart';

/// Bundle card widget for subscription packs.
class BundleCard extends StatelessWidget {
  const BundleCard({
    required this.bundle,
    required this.onTap,
    super.key,
    this.width,
    this.isCompact = false,
  });

  /// Bundle model data.
  final BundleModel bundle;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Card width.
  final double? width;

  /// Whether to use compact layout.
  final bool isCompact;

  Color get _bundleColor {
    if (bundle.color != null) {
      try {
        return Color(int.parse(bundle.color!.replaceFirst('#', '0xFF')));
      } catch (_) {
        return AppColors.primary;
      }
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 180.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: bundle.isPopular || bundle.isBestValue
                ? _bundleColor.withValues(alpha: 0.5)
                : AppColors.outlineLight,
            width: bundle.isPopular || bundle.isBestValue ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and badge
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: _bundleColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getBundleIcon(),
                    size: 24.r,
                    color: _bundleColor,
                  ),
                ),
                const Spacer(),
                if (bundle.isPopular || bundle.isBestValue)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _bundleColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      bundle.isPopular ? 'Popular' : 'Best Value',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              _getLocalizedTitle(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),

            // Benefit description
            Text(
              _getLocalizedBenefit(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${bundle.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: _bundleColor,
                  ),
                ),
                SizedBox(width: 4.w),
                if (bundle.hasDiscount) ...[
                  Text(
                    '\$${bundle.originalPrice!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiaryLight,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      '/${bundle.durationText}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (bundle.hasDiscount) ...[
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Save ${bundle.discountPercent}%',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.successDark,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getBundleIcon() {
    switch (bundle.type) {
      case BundleType.unlimited:
        return Iconsax.unlimited;
      case BundleType.monthly:
        return Iconsax.calendar_1;
      case BundleType.homeCharging:
        return Iconsax.home;
      case BundleType.business:
        return Iconsax.briefcase;
      case BundleType.starter:
        return Iconsax.flash_1;
    }
  }

  String _getLocalizedTitle() {
    // In production, use AppLocalizations
    switch (bundle.titleKey) {
      case 'bundle_unlimited_title':
        return 'Unlimited';
      case 'bundle_saver_title':
        return 'Monthly Saver';
      case 'bundle_home_title':
        return 'Home Setup';
      case 'bundle_business_title':
        return 'Business';
      default:
        return bundle.titleKey;
    }
  }

  String _getLocalizedBenefit() {
    switch (bundle.benefitKey) {
      case 'bundle_unlimited_desc':
        return 'Charge unlimited with priority access';
      case 'bundle_saver_desc':
        return '200 kWh included monthly';
      case 'bundle_home_desc':
        return 'Complete home charger setup';
      case 'bundle_business_desc':
        return 'Fleet management solution';
      default:
        return bundle.benefitKey;
    }
  }
}
