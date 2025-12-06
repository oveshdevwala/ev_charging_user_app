/// File: lib/features/value_packs/presentation/screens/reviews_screen.dart
/// Purpose: Reviews screen for value packs
/// Belongs To: value_packs feature
/// Route: AppRoutes.packReviews
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/common_text_field.dart';
import '../../domain/entities/review.dart';
import '../cubits/reviews_cubit.dart';
import '../cubits/reviews_state.dart';

/// Reviews screen for value packs.
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    required this.packId,
    super.key,
  });

  final String packId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _ratingController = TextEditingController();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  double _selectedRating = 5.0;
  bool _showReviewForm = false;

  @override
  void dispose() {
    _ratingController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..loadReviews(widget.packId),
      child: Scaffold(
        appBar: AppAppBar(
          title: AppStrings.valuePackReviews,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () => setState(() => _showReviewForm = !_showReviewForm),
            ),
          ],
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            return Column(
              children: [
                if (_showReviewForm)
                  _ReviewForm(
                  packId: widget.packId,
                  rating: _selectedRating,
                  onRatingChanged: (rating) => setState(() => _selectedRating = rating),
                  titleController: _titleController,
                  messageController: _messageController,
                  onCancel: () => setState(() => _showReviewForm = false),
                ),
                Expanded(
                  child: state.reviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.message,
                                size: 64.r,
                                color: context.appColors.textTertiary,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No reviews yet',
                                style: context.text.titleMedium?.copyWith(
                                  color: context.appColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16.r),
                          itemCount: state.reviews.length,
                          itemBuilder: (context, index) {
                            final review = state.reviews[index];
                            return _ReviewCard(review: review);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReviewForm extends StatelessWidget {
  const _ReviewForm({
    required this.packId,
    required this.rating,
    required this.onRatingChanged,
    required this.titleController,
    required this.messageController,
    required this.onCancel,
  });

  final String packId;
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a Review',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          // Rating selector
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating.round() ? Iconsax.star1 : Iconsax.star,
                  color: colors.warning,
                ),
                onPressed: () => onRatingChanged(index + 1.0),
              );
            }),
          ),
          SizedBox(height: 12.h),
          CommonTextField(
            controller: titleController,
            hint: 'Review title',
          ),
          SizedBox(height: 12.h),
          CommonTextField(
            controller: messageController,
            hint: 'Write your review...',
            maxLines: 4,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text(AppStrings.cancel),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: BlocBuilder<ReviewsCubit, ReviewsState>(
                  builder: (context, state) {
                    return CommonButton(
                      label: state.submitting ? 'Submitting...' : AppStrings.submit,
                      onPressed: state.submitting
                          ? null
                          : () {
                              context.read<ReviewsCubit>().submitReview(
                                    packId: packId,
                                    rating: rating,
                                    title: titleController.text,
                                    message: messageController.text,
                                  );
                            },
                      isLoading: state.submitting,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  child: Text(review.userName[0].toUpperCase()),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating.round()
                                  ? Iconsax.star1
                                  : Iconsax.star,
                              size: 16.r,
                              color: colors.warning,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                if (review.createdAt != null)
                  Text(
                    _formatDate(review.createdAt!),
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
              ],
            ),
            if (review.title.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                review.title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Text(
              review.message,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}

