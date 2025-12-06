/// File: lib/features/community/ui/community_panel.dart
/// Purpose: Community panel widget for station details
/// Belongs To: community feature
/// Route: Embedded in StationDetailsPage
/// Customization Guide:
///    - Adjust tabs and layout as needed
///    - Customize summary card appearance
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../repositories/community_repository.dart';
import '../widgets/widgets.dart';

/// Community panel for station details page.
class CommunityPanel extends StatelessWidget {
  const CommunityPanel({
    required this.stationId,
    super.key,
    this.isExpanded = true,
    this.onWriteReview,
    this.onAskQuestion,
    this.onReportIssue,
    this.onViewAllReviews,
    this.onViewAllPhotos,
    this.onViewAllQuestions,
  });

  final String stationId;
  final bool isExpanded;
  final VoidCallback? onWriteReview;
  final VoidCallback? onAskQuestion;
  final VoidCallback? onReportIssue;
  final VoidCallback? onViewAllReviews;
  final VoidCallback? onViewAllPhotos;
  final VoidCallback? onViewAllQuestions;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit(
        repository: DummyCommunityRepository(),
        stationId: stationId,
      )..loadCommunityData(),
      child: _CommunityPanelContent(
        isExpanded: isExpanded,
        onWriteReview: onWriteReview,
        onAskQuestion: onAskQuestion,
        onReportIssue: onReportIssue,
        onViewAllReviews: onViewAllReviews,
        onViewAllPhotos: onViewAllPhotos,
        onViewAllQuestions: onViewAllQuestions,
      ),
    );
  }
}

class _CommunityPanelContent extends StatelessWidget {
  const _CommunityPanelContent({
    required this.isExpanded,
    this.onWriteReview,
    this.onAskQuestion,
    this.onReportIssue,
    this.onViewAllReviews,
    this.onViewAllPhotos,
    this.onViewAllQuestions,
  });

  final bool isExpanded;
  final VoidCallback? onWriteReview;
  final VoidCallback? onAskQuestion;
  final VoidCallback? onReportIssue;
  final VoidCallback? onViewAllReviews;
  final VoidCallback? onViewAllPhotos;
  final VoidCallback? onViewAllQuestions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoading(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            if (state.summary != null)
              _buildSummaryCard(context, state.summary!),
            SizedBox(height: 16.h),

            // Quick actions
            _buildQuickActions(context),
            SizedBox(height: 20.h),

            // Tab selector
            _buildTabSelector(context, state),
            SizedBox(height: 16.h),

            // Content based on tab
            _buildTabContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(40.r),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Loading community...',
              style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    StationCommunitySummary summary,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.1),
            colors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Rating display
          Column(
            children: [
              Text(
                summary.avgRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              StarRatingCompact(rating: summary.avgRating, showCount: false),
              SizedBox(height: 4.h),
              Text(
                '${summary.ratingCount} reviews',
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Container(width: 1, height: 60.h, color: colors.outline),
          SizedBox(width: 20.w),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  context,
                  Iconsax.verify5,
                  '${(summary.verifiedRatio * 100).toInt()}% verified reviews',
                  colors.primary,
                ),
                SizedBox(height: 8.h),
                _buildStatRow(
                  context,
                  Iconsax.gallery,
                  '${summary.photosCount} photos',
                  colors.secondary,
                ),
                SizedBox(height: 8.h),
                _buildStatRow(
                  context,
                  Iconsax.message_question,
                  '${summary.questionsCount} questions',
                  colors.textTertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final colors = context.appColors;

    return Row(
      children: [
        Icon(icon, size: 16.r, color: color),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Iconsax.star,
            label: 'Review',
            onTap: onWriteReview,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _QuickActionButton(
            icon: Iconsax.message_question,
            label: 'Ask',
            onTap: onAskQuestion,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _QuickActionButton(
            icon: Iconsax.flag,
            label: 'Report',
            onTap: onReportIssue,
            color: colors.danger,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _QuickActionButton(
            icon: Iconsax.camera,
            label: 'Photo',
            onTap: () {
              // TODO: Implement photo upload
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabSelector(BuildContext context, CommunityState state) {
    final colors = context.appColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CommunityTab.values.map((tab) {
          final isSelected = state.selectedTab == tab;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                context.read<CommunityCubit>().selectTab(tab);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _getTabLabel(tab, state),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? colors.surface : colors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getTabLabel(CommunityTab tab, CommunityState state) {
    switch (tab) {
      case CommunityTab.reviews:
        return 'Reviews (${state.reviews.length})';
      case CommunityTab.photos:
        return 'Photos (${state.photos.length})';
      case CommunityTab.qa:
        return 'Q&A (${state.questions.length})';
      case CommunityTab.issues:
        return 'Issues';
    }
  }

  Widget _buildTabContent(BuildContext context, CommunityState state) {
    switch (state.selectedTab) {
      case CommunityTab.reviews:
        return _buildReviewsTab(context, state);
      case CommunityTab.photos:
        return _buildPhotosTab(context, state);
      case CommunityTab.qa:
        return _buildQATab(context, state);
      case CommunityTab.issues:
        return _buildIssuesTab(context);
    }
  }

  Widget _buildReviewsTab(BuildContext context, CommunityState state) {
    if (state.reviews.isEmpty) {
      return EmptyReviewsWidget(onWriteReview: onWriteReview);
    }

    return Column(
      children: [
        // Sort options
        _buildSortRow(context, state),
        SizedBox(height: 12.h),

        // Reviews list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.reviews.take(3).length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final review = state.reviews[index];
            return ReviewCard(
              review: review,
              onHelpfulTap: () {
                context.read<CommunityCubit>().toggleReviewHelpful(review.id);
              },
              onFlagTap: () => _showFlagDialog(context, review.id),
            );
          },
        ),

        if (state.reviews.length > 3) ...[
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: onViewAllReviews,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text('View All ${state.reviews.length} Reviews'),
          ),
        ],
      ],
    );
  }

  Widget _buildSortRow(BuildContext context, CommunityState state) {
    final colors = context.appColors;

    return Row(
      children: [
        Text(
          'Sort by:',
          style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
        ),
        SizedBox(width: 8.w),
        PopupMenuButton<ReviewSortOption>(
          initialValue: state.reviewSort,
          onSelected: (option) {
            context.read<CommunityCubit>().changeReviewSort(option);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getSortLabel(state.reviewSort),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Iconsax.arrow_down_1,
                  size: 16.r,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
          itemBuilder: (context) => ReviewSortOption.values.map((option) {
            return PopupMenuItem(
              value: option,
              child: Text(_getSortLabel(option)),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getSortLabel(ReviewSortOption option) {
    switch (option) {
      case ReviewSortOption.mostRecent:
        return 'Most Recent';
      case ReviewSortOption.mostHelpful:
        return 'Most Helpful';
      case ReviewSortOption.highestRating:
        return 'Highest Rating';
      case ReviewSortOption.lowestRating:
        return 'Lowest Rating';
    }
  }

  Widget _buildPhotosTab(BuildContext context, CommunityState state) {
    if (state.photos.isEmpty) {
      return const EmptyPhotosWidget();
    }

    return Column(
      children: [
        PhotoGrid(
          photos: state.photos.take(9).toList(),
          onPhotoTap: (index) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    PhotoViewer(photos: state.photos, initialIndex: index),
              ),
            );
          },
        ),
        if (state.photos.length > 9) ...[
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: onViewAllPhotos,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text('View All ${state.photos.length} Photos'),
          ),
        ],
      ],
    );
  }

  Widget _buildQATab(BuildContext context, CommunityState state) {
    if (state.questions.isEmpty) {
      return EmptyQAWidget(onAskQuestion: onAskQuestion);
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.questions.take(3).length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final question = state.questions[index];
            return QuestionCard(
              question: question,
              showAnswers: true,
              onUpvoteTap: () {
                context.read<CommunityCubit>().toggleQuestionUpvote(
                  question.id,
                );
              },
              onTap: () {
                // Navigate to question detail
              },
            );
          },
        ),
        if (state.questions.length > 3) ...[
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: onViewAllQuestions,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text('View All ${state.questions.length} Questions'),
          ),
        ],
      ],
    );
  }

  Widget _buildIssuesTab(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Icon(Iconsax.flag, size: 48.r, color: colors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            'Report an Issue',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Help improve this station by reporting problems',
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: onReportIssue,
            icon: Icon(Iconsax.flag, size: 18.r),
            label: const Text('Report Issue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: colors.surface,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFlagDialog(BuildContext context, String reviewId) {
    final colors = context.appColors;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'Report Review',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to report this review?',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CommunityCubit>().flagReview(
                reviewId,
                'User reported',
              );
            },
            child: Text('Report', style: TextStyle(color: colors.danger)),
          ),
        ],
      ),
    );
  }
}

/// Quick action button.
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final buttonColor = color ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: buttonColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.r, color: buttonColor),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
