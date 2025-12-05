/// File: lib/features/nearby_offers/presentation/widgets/partner_card.dart
/// Purpose: Partner display card
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/partner_category.dart';
import '../../data/models/partner_model.dart';
import 'distance_chip.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({required this.partner, required this.onTap, super.key});

  final PartnerModel partner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: theme.colorScheme.surfaceContainerHighest,
                  image: partner.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(partner.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: partner.imageUrl == null
                    ? Icon(partner.category.iconData, size: 32.sp)
                    : null,
              ),
              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            partner.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (partner.isVerified)
                          Icon(
                            Icons.verified,
                            size: 16.sp,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16.sp,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${partner.rating} (${partner.reviewCount})',
                          style: theme.textTheme.labelMedium,
                        ),
                        SizedBox(width: 8.w),
                        Text('•', style: theme.textTheme.labelMedium),
                        SizedBox(width: 8.w),
                        Text(
                          partner.category.name.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: partner.category.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DistanceChip(distanceKm: partner.distance),
                        if (partner.activeOfferCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${partner.activeOfferCount} Offers',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}
