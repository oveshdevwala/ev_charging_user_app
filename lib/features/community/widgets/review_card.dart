/// File: lib/features/community/widgets/review_card.dart
/// Purpose: Review card widget for displaying user reviews
/// Belongs To: community feature
/// Customization Guide:
///    - Customize layout via parameters
///    - Supports verified badge, photos, helpful actions
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';
import 'star_rating_widget.dart';

/// Review card widget.
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    required this.review, super.key,
    this.onHelpfulTap,
    this.onFlagTap,
    this.onPhotoTap,
    this.onShareTap,
    this.isExpanded = false,
    this.maxLines = 4,
  });

  final CommunityReviewModel review;
  final VoidCallback? onHelpfulTap;
  final VoidCallback? onFlagTap;
  final ValueChanged<int>? onPhotoTap;
  final VoidCallback? onShareTap;
  final bool isExpanded;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User info + Rating
          _buildHeader(context),
          SizedBox(height: 12.h),

          // Title
          if (review.title != null && review.title!.isNotEmpty) ...[
            Text(
              review.title!,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
          ],

          // Body
          if (review.body != null && review.body!.isNotEmpty)
            Text(
              review.body!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
                height: 1.5,
              ),
              maxLines: isExpanded ? null : maxLines,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),

          // Photos
          if (review.photos.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildPhotoGrid(context),
          ],

          SizedBox(height: 12.h),

          // Actions: Helpful, Flag, Share
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.outlineLight,
          backgroundImage: review.userAvatar != null
              ? CachedNetworkImageProvider(review.userAvatar!)
              : null,
          child: review.userAvatar == null
              ? Icon(
                  Iconsax.user,
                  size: 20.r,
                  color: AppColors.textSecondaryLight,
                )
              : null,
        ),
        SizedBox(width: 12.w),

        // Name + Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.displayName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  if (review.isVerifiedSession) ...[
                    SizedBox(width: 6.w),
                    _buildVerifiedBadge(),
                  ],
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                review.createdAt != null
                    ? timeago.format(review.createdAt!)
                    : 'Recently',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),

        // Rating
        StarRatingCompact(
          rating: review.rating,
          size: 12,
          showCount: false,
        ),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.verify5,
            size: 12.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context) {
    final photos = review.photos;
    final displayCount = photos.length > 4 ? 4 : photos.length;
    final hasMore = photos.length > 4;

    return SizedBox(
      height: 80.h,
      child: Row(
        children: List.generate(displayCount, (index) {
          final isLast = index == displayCount - 1;
          final showOverlay = isLast && hasMore;
          final remainingCount = photos.length - 4;

          return Expanded(
            child: GestureDetector(
              onTap: () => onPhotoTap?.call(index),
              child: Container(
                margin: EdgeInsets.only(right: index < displayCount - 1 ? 8.w : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: photos[index].effectiveUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.outlineLight,
                        ),
                        errorWidget: (context, url, error) => ColoredBox(
                          color: AppColors.outlineLight,
                          child: Icon(
                            Iconsax.image,
                            size: 24.r,
                            color: AppColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      if (showOverlay)
                        ColoredBox(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              '+$remainingCount',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Helpful button
        _ActionButton(
          icon: review.isHelpfulByMe ? Iconsax.like_15 : Iconsax.like_1,
          label: 'Helpful (${review.helpfulCount})',
          isActive: review.isHelpfulByMe,
          onTap: onHelpfulTap,
        ),
        SizedBox(width: 16.w),

        // Flag button
        _ActionButton(
          icon: Iconsax.flag,
          label: 'Report',
          isActive: review.isFlaggedByMe,
          onTap: review.isFlaggedByMe ? null : onFlagTap,
        ),

        const Spacer(),

        // Share button
        if (onShareTap != null)
          IconButton(
            onPressed: onShareTap,
            icon: Icon(
              Iconsax.share,
              size: 20.r,
              color: AppColors.textSecondaryLight,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.r, minHeight: 32.r),
          ),
      ],
    );
  }
}

/// Action button for review actions.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.r, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty reviews placeholder.
class EmptyReviewsWidget extends StatelessWidget {
  const EmptyReviewsWidget({
    super.key,
    this.onWriteReview,
  });

  final VoidCallback? onWriteReview;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.message_text,
              size: 64.r,
              color: AppColors.outlineLight,
            ),
            SizedBox(height: 16.h),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Be the first to share your experience',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onWriteReview != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onWriteReview,
                icon: Icon(Iconsax.edit, size: 18.r),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

