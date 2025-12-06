/// File: lib/features/nearby_offers/presentation/widgets/offer_card.dart
/// Purpose: Offer display card
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/partner_offer_model.dart';
import 'distance_chip.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, required this.onTap, super.key});

  final PartnerOfferModel offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Badge
            Stack(
              children: [
                Container(
                  height: 140.h,
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: offer.imageUrl != null
                      ? Image.network(
                          offer.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : const Icon(Icons.local_offer_outlined, size: 48),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      offer.discountText,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (offer.distance != null)
                  Positioned(
                    bottom: 12.h,
                    right: 12.w,
                    child: DistanceChip(
                      distanceKm: offer.distance,
                      color: context.appColors.textPrimary.withOpacity(0.6),
                      textColor: context.appColors.surface,
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundImage: offer.partnerLogoUrl != null
                            ? NetworkImage(offer.partnerLogoUrl!)
                            : null,
                        child: offer.partnerLogoUrl == null
                            ? Icon(Icons.store, size: 14.sp)
                            : null,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          offer.partnerName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    offer.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    offer.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (offer.validUntil != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14.sp,
                              color: theme.colorScheme.error,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              DateFormatter.formatExpiry(offer.validUntil!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.sp,
                        color: theme.colorScheme.onSurfaceVariant,
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
}
