/// File: lib/features/community/widgets/question_card.dart
/// Purpose: Question and answer card widgets for Q&A
/// Belongs To: community feature
/// Customization Guide:
///    - Customize layout via parameters
///    - Supports accepted answers, upvotes
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Question card widget.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.question, super.key,
    this.onTap,
    this.onUpvoteTap,
    this.showAnswers = false,
    this.maxAnswersPreview = 1,
  });

  final QuestionModel question;
  final VoidCallback? onTap;
  final VoidCallback? onUpvoteTap;
  final bool showAnswers;
  final int maxAnswersPreview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.outlineLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            SizedBox(height: 12.h),

            // Question text
            Text(
              question.text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
                height: 1.4,
              ),
            ),

            // Photo if any
            if (question.photoUrl != null) ...[
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: question.photoUrl!,
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            SizedBox(height: 12.h),

            // Stats and actions
            _buildStats(context),

            // Accepted answer preview
            if (showAnswers && question.hasAcceptedAnswer) ...[
              SizedBox(height: 12.h),
              _buildAcceptedAnswerPreview(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: AppColors.outlineLight,
          backgroundImage: question.userAvatar != null
              ? CachedNetworkImageProvider(question.userAvatar!)
              : null,
          child: question.userAvatar == null
              ? Icon(Iconsax.user, size: 16.r, color: AppColors.textSecondaryLight)
              : null,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.displayName,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Text(
                question.createdAt != null
                    ? timeago.format(question.createdAt!)
                    : 'Recently',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
        if (question.hasAcceptedAnswer)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.tick_circle, size: 12.r, color: AppColors.success),
                SizedBox(width: 4.w),
                Text(
                  'Answered',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        // Upvote button
        GestureDetector(
          onTap: onUpvoteTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                question.isUpvotedByMe ? Iconsax.arrow_up_25 : Iconsax.arrow_up_2,
                size: 18.r,
                color: question.isUpvotedByMe
                    ? AppColors.primary
                    : AppColors.textSecondaryLight,
              ),
              SizedBox(width: 4.w),
              Text(
                '${question.upvotesCount}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: question.isUpvotedByMe
                      ? AppColors.primary
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.w),

        // Answers count
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.message,
              size: 16.r,
              color: AppColors.textSecondaryLight,
            ),
            SizedBox(width: 4.w),
            Text(
              '${question.answersCount} ${question.answersCount == 1 ? 'answer' : 'answers'}',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),

        const Spacer(),

        // View answers arrow
        if (onTap != null)
          Icon(
            Iconsax.arrow_right_3,
            size: 18.r,
            color: AppColors.textTertiaryLight,
          ),
      ],
    );
  }

  Widget _buildAcceptedAnswerPreview(BuildContext context) {
    final acceptedAnswer = question.acceptedAnswer;
    if (acceptedAnswer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.tick_circle, size: 14.r, color: AppColors.success),
              SizedBox(width: 6.w),
              Text(
                'Accepted Answer',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
              const Spacer(),
              Text(
                acceptedAnswer.displayName,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            acceptedAnswer.text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimaryLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Answer card widget.
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    required this.answer, super.key,
    this.isQuestionOwner = false,
    this.onHelpfulTap,
    this.onAcceptTap,
  });

  final AnswerModel answer;
  final bool isQuestionOwner;
  final VoidCallback? onHelpfulTap;
  final VoidCallback? onAcceptTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: answer.isAccepted
            ? AppColors.success.withValues(alpha: 0.05)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: answer.isAccepted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.outlineLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.outlineLight,
                backgroundImage: answer.userAvatar != null
                    ? CachedNetworkImageProvider(answer.userAvatar!)
                    : null,
                child: answer.userAvatar == null
                    ? Icon(Iconsax.user, size: 14.r, color: AppColors.textSecondaryLight)
                    : null,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          answer.displayName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        if (answer.isAccepted) ...[
                          SizedBox(width: 6.w),
                          Icon(
                            Iconsax.tick_circle,
                            size: 14.r,
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      answer.createdAt != null
                          ? timeago.format(answer.createdAt!)
                          : 'Recently',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Answer text
          Text(
            answer.text,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimaryLight,
              height: 1.4,
            ),
          ),

          // Photo if any
          if (answer.photoUrl != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: CachedNetworkImage(
                imageUrl: answer.photoUrl!,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],

          SizedBox(height: 10.h),

          // Actions
          Row(
            children: [
              // Helpful button
              GestureDetector(
                onTap: onHelpfulTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      answer.isHelpfulByMe ? Iconsax.like_15 : Iconsax.like_1,
                      size: 16.r,
                      color: answer.isHelpfulByMe
                          ? AppColors.primary
                          : AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Helpful (${answer.helpfulCount})',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: answer.isHelpfulByMe
                            ? AppColors.primary
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Accept answer button (for question owner)
              if (isQuestionOwner && !answer.isAccepted)
                GestureDetector(
                  onTap: onAcceptTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'Accept Answer',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Empty Q&A placeholder.
class EmptyQAWidget extends StatelessWidget {
  const EmptyQAWidget({
    super.key,
    this.onAskQuestion,
  });

  final VoidCallback? onAskQuestion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.message_question,
              size: 64.r,
              color: AppColors.outlineLight,
            ),
            SizedBox(height: 16.h),
            Text(
              'No questions yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ask a question about this station',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAskQuestion != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onAskQuestion,
                icon: Icon(Iconsax.message_add, size: 18.r),
                label: const Text('Ask a Question'),
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

