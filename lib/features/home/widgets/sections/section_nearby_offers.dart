/// File: lib/features/home/widgets/sections/section_nearby_offers.dart
/// Purpose: Nearby offers section with horizontal scrolling
/// Belongs To: home feature
/// Customization Guide:
///    - Customize card appearance via OfferCard from nearby_offers
///    - Adjust number of items shown
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../features/nearby_offers/data/models/partner_offer_model.dart';
import '../../../../features/nearby_offers/presentation/widgets/offer_card.dart';
import '../section_header.dart';

/// Nearby offers section with horizontal scrolling.
class SectionNearbyOffers extends StatelessWidget {
  const SectionNearbyOffers({
    required this.offers,
    required this.onOfferTap,
    required this.onViewAllTap,
    super.key,
  });

  /// List of nearby offers.
  final List<PartnerOfferModel> offers;

  /// Callback when an offer is tapped.
  final void Function(PartnerOfferModel offer) onOfferTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.nearbyOffers,
          onViewAll: onViewAllTap,
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 300.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                width: 320.w,
                margin: EdgeInsets.only(right: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: OfferCard(
                    offer: offer,
                    onTap: () => onOfferTap(offer),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

