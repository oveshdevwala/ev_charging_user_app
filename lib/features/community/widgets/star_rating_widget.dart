/// File: lib/features/community/widgets/star_rating_widget.dart
/// Purpose: Interactive star rating widget
/// Belongs To: community feature
/// Customization Guide:
///    - Adjust star count, size, colors via parameters
///    - Supports half-star ratings
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';

/// Interactive star rating widget.
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    required this.rating, super.key,
    this.onRatingChanged,
    this.starCount = 5,
    this.size = 32,
    this.spacing = 4,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = false,
    this.showLabel = false,
    this.isReadOnly = false,
  });

  /// Current rating value (0-5).
  final double rating;

  /// Callback when rating changes.
  final ValueChanged<double>? onRatingChanged;

  /// Number of stars.
  final int starCount;

  /// Size of each star.
  final double size;

  /// Spacing between stars.
  final double spacing;

  /// Color for active/filled stars.
  final Color? activeColor;

  /// Color for inactive/empty stars.
  final Color? inactiveColor;

  /// Allow half-star selections.
  final bool allowHalfRating;

  /// Show rating label below stars.
  final bool showLabel;

  /// Whether read-only (no interaction).
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(starCount, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index < starCount - 1 ? spacing.w : 0),
              child: _buildStar(context, index),
            );
          }),
        ),
        if (showLabel && rating > 0) ...[
          SizedBox(height: 8.h),
          Text(
            _getRatingLabel(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: activeColor ?? AppColors.ratingActive,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(BuildContext context, int index) {
    final starValue = index + 1;
    final double fillAmount;

    if (rating >= starValue) {
      fillAmount = 1.0;
    } else if (rating > index && rating < starValue) {
      fillAmount = rating - index;
    } else {
      fillAmount = 0.0;
    }

    return GestureDetector(
      onTapDown: isReadOnly
          ? null
          : (details) {
              if (onRatingChanged == null) {
                return;
              }

              if (allowHalfRating) {
                // Calculate if tap was on left or right half
                final tapX = details.localPosition.dx;
                final halfSize = size.r / 2;
                if (tapX <= halfSize) {
                  onRatingChanged!(starValue - 0.5);
                } else {
                  onRatingChanged!(starValue.toDouble());
                }
              } else {
                onRatingChanged!(starValue.toDouble());
              }
            },
      child: SizedBox(
        width: size.r,
        height: size.r,
        child: Stack(
          children: [
            // Background star (inactive)
            Icon(
              Iconsax.star1,
              size: size.r,
              color: inactiveColor ?? AppColors.ratingInactive,
            ),
            // Filled star with clip
            ClipRect(
              clipper: _StarClipper(fillAmount),
              child: Icon(
                Iconsax.star1,
                size: size.r,
                color: activeColor ?? AppColors.ratingActive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel() {
    if (rating >= 4.5) {
      return 'Excellent';
    }
    if (rating >= 3.5) {
      return 'Good';
    }
    if (rating >= 2.5) {
      return 'Average';
    }
    if (rating >= 1.5) {
      return 'Poor';
    }
    return 'Very Poor';
  }
}

/// Custom clipper for partial star fill.
class _StarClipper extends CustomClipper<Rect> {
  _StarClipper(this.fillAmount);

  final double fillAmount;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillAmount, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) => fillAmount != oldClipper.fillAmount;
}

/// Compact star rating display (read-only).
class StarRatingCompact extends StatelessWidget {
  const StarRatingCompact({
    required this.rating, super.key,
    this.reviewCount,
    this.size = 14,
    this.showCount = true,
    this.color,
  });

  final double rating;
  final int? reviewCount;
  final double size;
  final bool showCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Iconsax.star1,
          size: size.r,
          color: color ?? AppColors.ratingActive,
        ),
        SizedBox(width: 4.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        if (showCount && reviewCount != null) ...[
          Text(
            ' (${_formatCount(reviewCount!)})',
            style: TextStyle(
              fontSize: (size - 2).sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

/// Rating selector with microcopy feedback.
class RatingSelector extends StatelessWidget {
  const RatingSelector({
    required this.rating, required this.onRatingChanged, super.key,
    this.size = 40,
  });

  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StarRatingWidget(
          rating: rating,
          onRatingChanged: onRatingChanged,
          size: size,
          spacing: 8,
          showLabel: true,
        ),
        if (rating == 0) ...[
          SizedBox(height: 8.h),
          Text(
            'Tap to rate',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}

