/// File: lib/widgets/pexels_image_widget.dart
/// Purpose: Reusable widget for displaying Pexels images
/// Belongs To: shared
/// Customization Guide:
///    - Customize placeholder and error widgets
///    - Adjust BoxFit as needed
///    - Add loading animations
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../core/data/models/pexels/pexels.dart';
import '../core/extensions/context_ext.dart';
import '../core/theme/app_theme_extensions.dart';
import '../core/utils/image_url_resolver.dart';

/// Reusable widget for displaying Pexels images.
/// 
/// Features:
/// - Cached network image loading
/// - Shimmer placeholder
/// - Error fallback
/// - Customizable size and styling
class PexelsImageWidget extends StatelessWidget {
  const PexelsImageWidget({
    required this.photo,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.size = ImageSize.medium,
    this.showShimmer = true,
    this.fallbackAsset,
    super.key,
  });

  /// Pexels photo model
  final PexelsPhoto photo;

  /// Image width
  final double? width;

  /// Image height
  final double? height;

  /// Border radius
  final double? borderRadius;

  /// BoxFit for image
  final BoxFit fit;

  /// Image size preference
  final ImageSize size;

  /// Show shimmer placeholder
  final bool showShimmer;

  /// Fallback asset path if image fails to load
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlResolver.getImageUrl(photo, size: size);
    final appColors = context.appColors;
    final iconSize = (width != null && height != null)
        ? (width! < height! ? width! : height!) * 0.3
        : 32.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius ?? 0.r,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: showShimmer
            ? (context, url) => _buildShimmerPlaceholder(context)
            : (context, url) => _buildLoadingPlaceholder(context, appColors),
        errorWidget: (context, url, error) =>
            _buildErrorWidget(context, appColors, iconSize),
      ),
    );
  }

  /// Build shimmer placeholder
  Widget _buildShimmerPlaceholder(BuildContext context) {
    final appColors = context.appColors;
    return Shimmer.fromColors(
      baseColor: appColors.outline,
      highlightColor: appColors.outline.withOpacity(0.5),
      child: Container(
        width: width,
        height: height,
        color: appColors.outline,
      ),
    );
  }

  /// Build loading placeholder
  Widget _buildLoadingPlaceholder(BuildContext context, AppColors appColors) {
    return Container(
      width: width,
      height: height,
      color: appColors.outline,
      child: Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(appColors.primary),
          ),
        ),
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(
    BuildContext context,
    AppColors appColors,
    double iconSize,
  ) {
    return Container(
      width: width,
      height: height,
      color: appColors.outline,
      child: Center(
        child: Icon(
          Iconsax.image,
          size: iconSize,
          color: appColors.textTertiary,
        ),
      ),
    );
  }
}

/// Widget for displaying Pexels image from URL string.
/// 
/// Use this when you only have the image URL (not the full photo model).
class PexelsImageFromUrl extends StatelessWidget {
  const PexelsImageFromUrl({
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.showShimmer = true,
    this.fallbackAsset,
    super.key,
  });

  /// Image URL
  final String imageUrl;

  /// Image width
  final double? width;

  /// Image height
  final double? height;

  /// Border radius
  final double? borderRadius;

  /// BoxFit for image
  final BoxFit fit;

  /// Show shimmer placeholder
  final bool showShimmer;

  /// Fallback asset path
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final iconSize = (width != null && height != null)
        ? (width! < height! ? width! : height!) * 0.3
        : 32.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius ?? 0.r,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: showShimmer
            ? (context, url) => Shimmer.fromColors(
                  baseColor: appColors.outline,
                  highlightColor: appColors.outline.withOpacity(0.5),
                  child: Container(
                    width: width,
                    height: height,
                    color: appColors.outline,
                  ),
                )
            : (context, url) => Container(
                  width: width,
                  height: height,
                  color: appColors.outline,
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          appColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: appColors.outline,
          child: Center(
            child: Icon(
              Iconsax.image,
              size: iconSize,
              color: appColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

