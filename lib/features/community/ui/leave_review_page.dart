/// File: lib/features/community/ui/leave_review_page.dart
/// Purpose: Full-screen page for leaving a review
/// Belongs To: community feature
/// Route: /stationCommunity/:id/review
/// Customization Guide:
///    - Adjust form validation rules
///    - Customize photo upload flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../repositories/community_repository.dart';
import '../widgets/widgets.dart';

/// Leave review page.
class LeaveReviewPage extends StatelessWidget {
  const LeaveReviewPage({
    required this.stationId,
    required this.stationName,
    super.key,
    this.onReviewSubmitted,
  });

  final String stationId;
  final String stationName;
  final ValueChanged<CommunityReviewModel>? onReviewSubmitted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewEditorCubit(
        repository: DummyCommunityRepository(),
        stationId: stationId,
      ),
      child: _LeaveReviewContent(
        stationName: stationName,
        onReviewSubmitted: onReviewSubmitted,
      ),
    );
  }
}

class _LeaveReviewContent extends StatefulWidget {
  const _LeaveReviewContent({
    required this.stationName,
    this.onReviewSubmitted,
  });

  final String stationName;
  final ValueChanged<CommunityReviewModel>? onReviewSubmitted;

  @override
  State<_LeaveReviewContent> createState() => _LeaveReviewContentState();
}

class _LeaveReviewContentState extends State<_LeaveReviewContent> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewEditorCubit, ReviewEditorState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<ReviewEditorCubit>().clearError();
        }

        if (state.submitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Write a Review'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => _handleBack(context, state),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Station info
                        _buildStationInfo(),
                        SizedBox(height: 24.h),

                        // Rating selector
                        _buildRatingSection(context, state),
                        SizedBox(height: 24.h),

                        // Title
                        _buildTitleSection(context),
                        SizedBox(height: 16.h),

                        // Body
                        _buildBodySection(context, state),
                        SizedBox(height: 20.h),

                        // Photos
                        _buildPhotosSection(context, state),
                        SizedBox(height: 20.h),

                        // Options
                        _buildOptionsSection(context, state),
                      ],
                    ),
                  ),
                ),

                // Submit button
                _buildSubmitButton(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStationInfo() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Iconsax.flash_1, size: 24.r, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviewing',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  widget.stationName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, ReviewEditorState state) {
    return Column(
      children: [
        Text(
          'How was your experience?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 16.h),
        RatingSelector(
          rating: state.rating,
          onRatingChanged: (rating) {
            context.read<ReviewEditorCubit>().updateRating(rating);
          },
          size: 44,
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '(optional)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _titleController,
          onChanged: (value) {
            context.read<ReviewEditorCubit>().updateTitle(value);
          },
          decoration: InputDecoration(
            hintText: 'Summarize your experience',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiaryLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.all(14.r),
          ),
        ),
      ],
    );
  }

  Widget _buildBodySection(BuildContext context, ReviewEditorState state) {
    final charCount = state.body.length;
    final isValid = charCount >= 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Review',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _bodyController,
          onChanged: (value) {
            context.read<ReviewEditorCubit>().updateBody(value);
          },
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Share details about your charging experience...',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiaryLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.all(14.r),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isValid ? 'Great detail!' : 'Minimum 20 characters',
              style: TextStyle(
                fontSize: 11.sp,
                color: isValid
                    ? AppColors.success
                    : AppColors.textTertiaryLight,
              ),
            ),
            Text(
              '$charCount/20',
              style: TextStyle(
                fontSize: 11.sp,
                color: isValid
                    ? AppColors.success
                    : AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosSection(BuildContext context, ReviewEditorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '(up to 6)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add photo button
              if (state.photos.length < 6)
                GestureDetector(
                  onTap: () => _pickPhoto(context),
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.outlineLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.camera,
                          size: 24.r,
                          color: AppColors.textSecondaryLight,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Photo previews
              ...state.photos.asMap().entries.map((entry) {
                return Container(
                  width: 80.w,
                  height: 80.h,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.outlineLight,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          'https://picsum.photos/200?random=${entry.key}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: GestureDetector(
                          onTap: () {
                            context.read<ReviewEditorCubit>().removePhoto(
                              entry.key,
                            );
                          },
                          child: Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.close_circle,
                              size: 14.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(BuildContext context, ReviewEditorState state) {
    return Column(
      children: [
        // Verified session toggle
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(Iconsax.verify5, size: 20.r, color: AppColors.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I charged at this station',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Verified reviews are weighted higher',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: state.isVerifiedSession,
                onChanged: (value) {
                  context.read<ReviewEditorCubit>().toggleVerifiedSession(
                    value: value,
                  );
                },
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Anonymous toggle
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.user_square,
                size: 20.r,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post anonymously',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Your name will not be shown publicly',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: state.isAnonymous,
                onChanged: (value) {
                  context.read<ReviewEditorCubit>().toggleAnonymous(
                    value: value,
                  );
                },
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, ReviewEditorState state) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: CommonButton(
        label: 'Submit Review',
        onPressed: state.isValid && !state.isSubmitting
            ? () async {
                final review = await context
                    .read<ReviewEditorCubit>()
                    .submitReview();
                if (review != null) {
                  widget.onReviewSubmitted?.call(review);
                }
              }
            : null,
        isLoading: state.isSubmitting,
        isDisabled: !state.isValid,
      ),
    );
  }

  Future<void> _pickPhoto(BuildContext context) async {
    // Simplified photo picker - in production use image_picker package
   await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                // Simulate adding a photo
                context.read<ReviewEditorCubit>().addPhoto(
                  'photo_${DateTime.now().millisecondsSinceEpoch}',
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                // Simulate adding a photo
                context.read<ReviewEditorCubit>().addPhoto(
                  'photo_${DateTime.now().millisecondsSinceEpoch}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleBack(BuildContext context, ReviewEditorState state) {
    if (state.rating > 0 || state.body.isNotEmpty) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Review?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Discard',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
