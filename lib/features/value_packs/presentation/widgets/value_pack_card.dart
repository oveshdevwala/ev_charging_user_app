/// File: lib/features/value_packs/presentation/widgets/value_pack_card.dart
/// Purpose: Reusable card widget for displaying value packs
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Customize colors and layout via params
///    - Supports discount display and badges
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/value_pack.dart';
import 'price_badge.dart';
import 'tag_badge.dart';

/// Value pack card widget.
class ValuePackCard extends StatelessWidget {
  const ValuePackCard({
    required this.pack,
    required this.onTap,
    super.key,
    this.onSave,
    this.isSaved = false,
    this.isCompact = false,
  });

  /// Value pack data.
  final ValuePack pack;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Callback when save button is tapped.
  final VoidCallback? onSave;

  /// Whether pack is saved.
  final bool isSaved;

  /// Whether to use compact layout.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: colors.primaryContainer.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, Badge, Save button
              Row(
                children: [
                  // Icon
                  if (pack.iconUrl != null)
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Iconsax.flash,
                        size: 24.r,
                        color: colors.primary,
                      ),
                    )
                  else
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Iconsax.flash,
                        size: 24.r,
                        color: colors.primary,
                      ),
                    ),
                  SizedBox(width: 12.w),
                  // Title and Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pack.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (pack.badge != null) ...[
                          SizedBox(height: 4.h),
                          TagBadge(label: pack.badge!, color: colors.primary),
                        ],
                      ],
                    ),
                  ),
                  // Save button
                  if (onSave != null)
                    IconButton(
                      onPressed: onSave,
                      icon: Icon(
                        isSaved ? Iconsax.heart5 : Iconsax.heart,
                        size: 20.r,
                        color: isSaved ? colors.danger : colors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              // Subtitle
              Text(
                pack.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: colors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.h),
              // Price and Savings
              Row(
                children: [
                  Expanded(
                    child: PriceBadge(
                      price: pack.price,
                      currency: pack.priceCurrency,
                      oldPrice: pack.oldPrice,
                      billingCycle: pack.billingCycle,
                    ),
                  ),
                  if (pack.hasDiscount) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${pack.discountPercent.toStringAsFixed(0)}% OFF',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 12.sp,
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (!isCompact) ...[
                SizedBox(height: 12.h),
                // Features preview
                if (pack.features.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...pack.features
                          .take(2)
                          .map(
                            (feature) => Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.tick_circle,
                                    size: 16.r,
                                    color: colors.success,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: textTheme.bodySmall?.copyWith(
                                        fontSize: 12.sp,
                                        color: colors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                SizedBox(height: 8.h),
                // Rating
                Row(
                  children: [
                    Icon(
                      Iconsax.star1,
                      size: 16.r,
                      color: AppColors.ratingActive,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      pack.rating.toStringAsFixed(1),
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '(${pack.reviewsCount})',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
