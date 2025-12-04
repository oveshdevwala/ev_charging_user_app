/// File: lib/features/home/widgets/sections/section_offers_carousel.dart
/// Purpose: Simple offers list section (no carousel)
/// Belongs To: home feature
/// Customization Guide:
///    - Customize offer item appearance via _OfferListItem
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/offer_model.dart';
import '../section_header.dart';

/// Simple offers list section.
class SectionOffersCarousel extends StatelessWidget {
  const SectionOffersCarousel({
    required this.offers,
    required this.onOfferTap,
    required this.onViewAllTap,
    super.key,
  });

  /// List of offers.
  final List<OfferModel> offers;

  /// Callback when an offer is tapped.
  final void Function(OfferModel offer) onOfferTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: AppStrings.offersTitle,
            onViewAll: onViewAllTap,
            showAction: false,
          ),
          SizedBox(height: 12.h),
          ...offers
              .take(3)
              .map(
                (offer) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _OfferListItem(
                    offer: offer,
                    onTap: () => onOfferTap(offer),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// Simple offer list item.
class _OfferListItem extends StatelessWidget {
  const _OfferListItem({required this.offer, required this.onTap});

  final OfferModel offer;
  final VoidCallback onTap;

  String _getOfferTitle() {
    switch (offer.titleKey) {
      case 'offer_flash_sale_title':
        return 'Flash Sale: ${offer.discountPercent?.toInt() ?? 0}% Off';
      case 'offer_cashback_title':
        return '${offer.discountPercent?.toInt() ?? 0}% Cashback';
      case 'offer_partner_title':
        return 'Partner Deal';
      case 'offer_seasonal_title':
        return 'Seasonal Special';
      default:
        return offer.titleKey;
    }
  }

  String _getOfferSubtitle() {
    switch (offer.descKey) {
      case 'offer_flash_sale_desc':
        return 'Limited time offer';
      case 'offer_cashback_desc':
        return 'On every session';
      case 'offer_partner_desc':
        return 'At partner stations';
      case 'offer_seasonal_desc':
        return 'Season savings';
      default:
        return offer.descKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.outlineLight.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.discount_shape,
                  size: 18.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getOfferTitle(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _getOfferSubtitle(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                size: 16.r,
                color: AppColors.textTertiaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
