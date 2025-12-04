/// File: lib/features/community/ui/station_community_page.dart
/// Purpose: Full station community page with all tabs
/// Belongs To: community feature
/// Route: /stationCommunity/:id
/// Customization Guide:
///    - Adjust tab layout and content
///    - Customize pull-to-refresh behavior
// ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../repositories/community_repository.dart';
import '../widgets/widgets.dart';
import 'leave_review_page.dart';

/// Full station community page.
class StationCommunityPage extends StatelessWidget {
  const StationCommunityPage({
    required this.stationId,
    required this.stationName,
    super.key,
    this.initialTab = CommunityTab.reviews,
  });

  final String stationId;
  final String stationName;
  final CommunityTab initialTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit(
        repository: DummyCommunityRepository(),
        stationId: stationId,
      )..loadCommunityData(),
      child: _StationCommunityContent(
        stationId: stationId,
        stationName: stationName,
        initialTab: initialTab,
      ),
    );
  }
}

class _StationCommunityContent extends StatefulWidget {
  const _StationCommunityContent({
    required this.stationId,
    required this.stationName,
    required this.initialTab,
  });

  final String stationId;
  final String stationName;
  final CommunityTab initialTab;

  @override
  State<_StationCommunityContent> createState() =>
      _StationCommunityContentState();
}

class _StationCommunityContentState extends State<_StationCommunityContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab.index,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<CommunityCubit>().selectTab(
        CommunityTab.values[_tabController.index],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityCubit, CommunityState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<CommunityCubit>().clearMessages();
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<CommunityCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.stationName),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryLight,
              indicatorColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: 'Reviews (${state.reviews.length})'),
                Tab(text: 'Photos (${state.photos.length})'),
                Tab(text: 'Q&A (${state.questions.length})'),
                const Tab(text: 'Report'),
              ],
            ),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () =>
                      context.read<CommunityCubit>().refreshCommunityData(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildReviewsTab(context, state),
                      _buildPhotosTab(context, state),
                      _buildQATab(context, state),
                      _buildReportTab(context),
                    ],
                  ),
                ),
          floatingActionButton: _buildFAB(context, state),
        );
      },
    );
  }

  Widget? _buildFAB(BuildContext context, CommunityState state) {
    switch (state.selectedTab) {
      case CommunityTab.reviews:
        return FloatingActionButton.extended(
          onPressed: () => _navigateToReview(context),
          backgroundColor: AppColors.primary,
          icon: Icon(Iconsax.edit, size: 20.r),
          label: const Text('Write Review'),
        );
      case CommunityTab.qa:
        return FloatingActionButton.extended(
          onPressed: () => _showAskQuestionSheet(context),
          backgroundColor: AppColors.primary,
          icon: Icon(Iconsax.message_add, size: 20.r),
          label: const Text('Ask Question'),
        );
      case CommunityTab.photos:
        return FloatingActionButton(
          onPressed: () {
            // TODO: Implement photo upload
          },
          backgroundColor: AppColors.primary,
          child: Icon(Iconsax.camera, size: 24.r),
        );
      default:
        return null;
    }
  }

  Widget _buildReviewsTab(BuildContext context, CommunityState state) {
    if (state.reviews.isEmpty) {
      return EmptyReviewsWidget(
        onWriteReview: () => _navigateToReview(context),
      );
    }

    return CustomScrollView(
      slivers: [
        // Summary header
        SliverToBoxAdapter(child: _buildSummaryHeader(state)),

        // Sort options
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: _buildSortRow(context, state),
          ),
        ),

        // Reviews list
        SliverPadding(
          padding: EdgeInsets.all(16.r),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= state.reviews.length) {
                  return state.hasMoreReviews
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                context
                                    .read<CommunityCubit>()
                                    .loadMoreReviews();
                              },
                              child: const Text('Load More'),
                            ),
                          ),
                        )
                      : null;
                }

                final review = state.reviews[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ReviewCard(
                    review: review,
                    onHelpfulTap: () {
                      context.read<CommunityCubit>().toggleReviewHelpful(
                        review.id,
                      );
                    },
                    onFlagTap: () => _showFlagDialog(context, review.id),
                    onPhotoTap: (photoIndex) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => PhotoViewer(
                            photos: review.photos,
                            initialIndex: photoIndex,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: state.reviews.length + (state.hasMoreReviews ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryHeader(CommunityState state) {
    final summary = state.summary;
    if (summary == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                summary.avgRating.toStringAsFixed(1),
                style: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.w700),
              ),
              StarRatingCompact(
                rating: summary.avgRating,
                size: 16,
                showCount: false,
              ),
              SizedBox(height: 4.h),
              Text(
                '${summary.ratingCount} reviews',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingBar('5', 0.7, AppColors.success),
                _buildRatingBar('4', 0.5, AppColors.success),
                _buildRatingBar('3', 0.2, AppColors.warning),
                _buildRatingBar('2', 0.1, AppColors.warning),
                _buildRatingBar('1', 0.05, AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double ratio, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortRow(BuildContext context, CommunityState state) {
    return Row(
      children: [
        Text(
          'Sort by:',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondaryLight,
          ),
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
              color: AppColors.surfaceVariantLight,
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
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Iconsax.arrow_down_1, size: 16.r),
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

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: PhotoGrid(
        photos: state.photos,
        hasMore: state.hasMorePhotos,
        onPhotoTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) =>
                  PhotoViewer(photos: state.photos, initialIndex: index),
            ),
          );
        },
        onLoadMore: () => context.read<CommunityCubit>().loadMorePhotos(),
      ),
    );
  }

  Widget _buildQATab(BuildContext context, CommunityState state) {
    if (state.questions.isEmpty) {
      return EmptyQAWidget(onAskQuestion: () => _showAskQuestionSheet(context));
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: state.questions.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final question = state.questions[index];
        return QuestionCard(
          question: question,
          showAnswers: true,
          onUpvoteTap: () {
            context.read<CommunityCubit>().toggleQuestionUpvote(question.id);
          },
          onTap: () {
            // Navigate to question detail
          },
        );
      },
    );
  }

  Widget _buildReportTab(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.flag, size: 64.r, color: AppColors.outlineLight),
            SizedBox(height: 20.h),
            Text(
              'Report an Issue',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              'Help improve this station by reporting problems like broken sockets, slow charging, or payment issues.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => _showReportModal(context),
              icon: Icon(Iconsax.flag, size: 20.r),
              label: const Text('Report Issue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LeaveReviewPage(
          stationId: widget.stationId,
          stationName: widget.stationName,
          onReviewSubmitted: (review) {
            context.read<CommunityCubit>().addReview(review);
          },
        ),
      ),
    );
  }

  Future<void> _showAskQuestionSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AskQuestionSheet(
        onSubmit: ({required String text, required bool isAnonymous}) async {
          final question = await context
              .read<CommunityCubit>()
              ._repository
              .createQuestion(
                stationId: widget.stationId,
                text: text,
                anonymous: isAnonymous,
              );
          if (mounted) {
            context.read<CommunityCubit>().addQuestion(question);
            Navigator.pop(ctx);
          }
        },
      ),
    );
  }

  void _showReportModal(BuildContext context) {
    ReportModal.show(
      context: context,
      targetType: ReportTargetType.station,
      targetId: widget.stationId,
      onSubmit: (category, description, isAnonymous) async {
        final repo = DummyCommunityRepository();
        return repo.createReport(
          targetType: ReportTargetType.station,
          targetId: widget.stationId,
          category: category,
          description: description,
          anonymous: isAnonymous,
        );
      },
    );
  }

  void _showFlagDialog(BuildContext context, String reviewId) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Review'),
        content: const Text('Are you sure you want to report this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CommunityCubit>().flagReview(
                reviewId,
                'User reported',
              );
            },
            child: const Text(
              'Report',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ask question bottom sheet.
class _AskQuestionSheet extends StatefulWidget {
  const _AskQuestionSheet({required this.onSubmit});

  final Future<void> Function({required String text, required bool isAnonymous})
  onSubmit;

  @override
  State<_AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<_AskQuestionSheet> {
  final _controller = TextEditingController();
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Ask a Question',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What would you like to know about this station?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isAnonymous = !_isAnonymous),
                child: Row(
                  children: [
                    Icon(
                      _isAnonymous ? Iconsax.tick_square : Iconsax.square,
                      size: 20.r,
                      color: _isAnonymous
                          ? AppColors.primary
                          : AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Ask anonymously',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.text.trim().isEmpty || _isSubmitting
                  ? null
                  : () async {
                      setState(() => _isSubmitting = true);
                      await widget.onSubmit(
                        text: _controller.text.trim(),
                        isAnonymous: _isAnonymous,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Post Question'),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to access private repository for question creation
extension on CommunityCubit {
  CommunityRepository get _repository => DummyCommunityRepository();
}
