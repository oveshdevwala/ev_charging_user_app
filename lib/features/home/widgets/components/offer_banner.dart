/// File: lib/features/home/widgets/components/offer_banner.dart
/// Purpose: Offer banner card for carousel
/// Belongs To: home feature
/// Customization Guide:
///    - Customize banner height and border radius via params
///    - Uses CachedNetworkImage for efficient loading
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';

/// Offer banner widget for carousel display.
class OfferBanner extends StatelessWidget {
  const OfferBanner({
    required this.bannerUrl,
    required this.onTap,
    super.key,
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
    final colors = context.appColors;

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
              color: colors.shadow,
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
              _buildBannerImage(context),
              if (showGradientOverlay)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, colors.scrim],
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
                            color: colors.textPrimary,
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
                            color: colors.textSecondary,
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

  /// Build banner image with URL validation.
  Widget _buildBannerImage(BuildContext context) {
    final colors = context.appColors;

    // Check if URL is valid
    final isValidUrl =
        bannerUrl.isNotEmpty &&
        (bannerUrl.startsWith('http://') || bannerUrl.startsWith('https://'));

    if (!isValidUrl) {
      // Show placeholder for invalid/empty URLs
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.8),
              colors.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Iconsax.discount_shape5,
            size: 48.r,
            color: colors.textPrimary.withValues(alpha: 0.3),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: bannerUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => ColoredBox(
        color: colors.surfaceVariant,
        child: Center(
          child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.r,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.8),
              colors.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Iconsax.discount_shape5,
            size: 48.r,
            color: colors.textPrimary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
