/// File: lib/features/home/widgets/sections/section_offers_carousel.dart
/// Purpose: Offers and rewards carousel section with auto-scroll
/// Belongs To: home feature
/// Customization Guide:
///    - Customize banner appearance via OfferBanner
///    - Adjust auto-scroll duration via _autoScrollDuration
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/offer_model.dart';
import '../section_header.dart';
import '../components/offer_banner.dart';

/// Offers carousel section with auto-scroll.
class SectionOffersCarousel extends StatelessWidget {
  const SectionOffersCarousel({
    super.key,
    required this.offers,
    required this.onOfferTap,
    required this.onViewAllTap,
  });

  /// List of offers.
  final List<OfferModel> offers;

  /// Callback when an offer is tapped.
  final void Function(OfferModel offer) onOfferTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.offersTitle,
          onViewAll: onViewAllTap,
        ),
        SizedBox(height: 16.h),
        _OffersCarouselAnimated(
          offers: offers,
          onOfferTap: onOfferTap,
        ),
      ],
    );
  }
}

/// Animated carousel with auto-scroll capability.
class _OffersCarouselAnimated extends StatefulWidget {
  const _OffersCarouselAnimated({
    required this.offers,
    required this.onOfferTap,
  });

  final List<OfferModel> offers;
  final void Function(OfferModel offer) onOfferTap;

  @override
  State<_OffersCarouselAnimated> createState() =>
      _OffersCarouselAnimatedState();
}

class _OffersCarouselAnimatedState extends State<_OffersCarouselAnimated> {
  late final PageController _pageController;
  int _currentPage = 0;
  static const _autoScrollDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(_autoScrollDuration, () {
      if (mounted && widget.offers.length > 1) {
        final nextPage = (_currentPage + 1) % widget.offers.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  String _getOfferTitle(OfferModel offer) {
    switch (offer.titleKey) {
      case 'offer_flash_sale_title':
        return 'Flash Sale: ${offer.discountPercent?.toInt() ?? 0}% Off';
      case 'offer_cashback_title':
        return 'Get ${offer.discountPercent?.toInt() ?? 0}% Cashback';
      case 'offer_partner_title':
        return 'Partner Exclusive Deal';
      case 'offer_seasonal_title':
        return 'Seasonal Special Offer';
      default:
        return offer.titleKey;
    }
  }

  String _getOfferSubtitle(OfferModel offer) {
    switch (offer.descKey) {
      case 'offer_flash_sale_desc':
        return 'Limited time only! Charge now and save.';
      case 'offer_cashback_desc':
        return 'Earn cashback on every charging session.';
      case 'offer_partner_desc':
        return 'Special rates at partner locations.';
      case 'offer_seasonal_desc':
        return 'Celebrate the season with savings!';
      default:
        return offer.descKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.offers.length,
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              return OfferBanner(
                bannerUrl: offer.bannerUrl,
                onTap: () => widget.onOfferTap(offer),
                title: _getOfferTitle(offer),
                subtitle: _getOfferSubtitle(offer),
              );
            },
          ),
        ),
        if (widget.offers.length > 1) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.offers.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: _currentPage == index ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.outlineLight,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

