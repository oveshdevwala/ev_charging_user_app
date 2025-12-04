/// File: lib/features/home/widgets/components/offer_banner.dart
/// Purpose: Offer banner card for carousel
/// Belongs To: home feature
/// Customization Guide:
///    - Customize banner height and border radius via params
///    - Uses CachedNetworkImage for efficient loading
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';

/// Offer banner widget for carousel display.
class OfferBanner extends StatelessWidget {
  const OfferBanner({
    super.key,
    required this.bannerUrl,
    required this.onTap,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.showGradientOverlay = true,
    this.title,
    this.subtitle,
  });

  /// Banner image URL.
  final String bannerUrl;

  /// Callback when banner is tapped.
  final VoidCallback onTap;

  /// Banner height.
  final double? height;

  /// Banner width.
  final double? width;

  /// Border radius.
  final double? borderRadius;

  /// Margin around the banner.
  final EdgeInsetsGeometry? margin;

  /// Whether to show gradient overlay.
  final bool showGradientOverlay;

  /// Optional title overlay.
  final String? title;

  /// Optional subtitle overlay.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 160.h,
        width: width,
        margin: margin ?? EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariantLight,
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.r,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariantLight,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32.r,
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ),
              ),
              if (showGradientOverlay)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              if (title != null || subtitle != null)
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

