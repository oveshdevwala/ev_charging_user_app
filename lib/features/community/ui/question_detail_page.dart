/// File: lib/features/community/ui/question_detail_page.dart
/// Purpose: Question detail page with answers
/// Belongs To: community feature
/// Route: /stationCommunity/:stationId/qa/:questionId
/// Customization Guide:
///    - Adjust answer submission flow
///    - Customize accepted answer display
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

/// Question detail page.
class QuestionDetailPage extends StatelessWidget {
  const QuestionDetailPage({
    required this.questionId,
    super.key,
    this.isQuestionOwner = false,
  });

  final String questionId;
  final bool isQuestionOwner;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QACubit(repository: DummyCommunityRepository())
            ..loadQuestion(questionId),
      child: _QuestionDetailContent(isQuestionOwner: isQuestionOwner),
    );
  }
}

class _QuestionDetailContent extends StatefulWidget {
  const _QuestionDetailContent({required this.isQuestionOwner});

  final bool isQuestionOwner;

  @override
  State<_QuestionDetailContent> createState() => _QuestionDetailContentState();
}

class _QuestionDetailContentState extends State<_QuestionDetailContent> {
  final _answerController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QACubit, QAState>(
      builder: (context, state) {
        if (state.isLoadingQuestion) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = state.selectedQuestion;
        if (question == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Question not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Question'), centerTitle: true),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question card
                      _buildQuestionSection(question),
                      SizedBox(height: 24.h),

                      // Answers section
                      _buildAnswersSection(question, state),
                    ],
                  ),
                ),
              ),

              // Answer input
              _buildAnswerInput(context, state, question.id),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionSection(QuestionModel question) {
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
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.outlineLight,
                backgroundImage: question.userAvatar != null
                    ? NetworkImage(question.userAvatar!)
                    : null,
                child: question.userAvatar == null
                    ? Icon(Iconsax.user, size: 18.r)
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Asked ${_formatTime(question.createdAt)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Question text
          Text(
            question.text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),

          // Photo if any
          if (question.photoUrl != null) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                question.photoUrl!,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],

          SizedBox(height: 14.h),

          // Stats
          Row(
            children: [
              Icon(
                question.isUpvotedByMe
                    ? Iconsax.arrow_up_25
                    : Iconsax.arrow_up_2,
                size: 18.r,
                color: question.isUpvotedByMe
                    ? AppColors.primary
                    : AppColors.textSecondaryLight,
              ),
              SizedBox(width: 4.w),
              Text(
                '${question.upvotesCount} upvotes',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                Iconsax.message,
                size: 16.r,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 4.w),
              Text(
                '${question.answersCount} answers',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersSection(QuestionModel question, QAState state) {
    if (question.answers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            children: [
              Icon(
                Iconsax.message_text,
                size: 48.r,
                color: AppColors.outlineLight,
              ),
              SizedBox(height: 12.h),
              Text(
                'No answers yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Be the first to answer this question',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sort with accepted answer first
    final sortedAnswers = List<AnswerModel>.from(question.answers)
    ..sort((a, b) {
      if (a.isAccepted && !b.isAccepted) {
        return -1;
      }
      if (!a.isAccepted && b.isAccepted) {
        return 1;
      }
      return b.helpfulCount.compareTo(a.helpfulCount);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${question.answersCount} ${question.answersCount == 1 ? 'Answer' : 'Answers'}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedAnswers.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final answer = sortedAnswers[index];
            return AnswerCard(
              answer: answer,
              isQuestionOwner: widget.isQuestionOwner,
              onHelpfulTap: () {
                context.read<QACubit>().toggleAnswerHelpful(answer.id);
              },
              onAcceptTap: () {
                context.read<QACubit>().acceptAnswer(answer.id);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnswerInput(
    BuildContext context,
    QAState state,
    String questionId,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _answerController,
                  onChanged: (value) {
                    context.read<QACubit>().updateAnswerText(value);
                  },
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Write your answer...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.outlineLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.outlineLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: EdgeInsets.all(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap:
                    state.answerText.trim().isNotEmpty &&
                        !state.isSubmittingAnswer
                    ? () async {
                        final answer = await context
                            .read<QACubit>()
                            .submitAnswer(questionId);
                        if (answer != null) {
                          _answerController.clear();
                        }
                      }
                    : null,
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: state.answerText.trim().isNotEmpty
                        ? AppColors.primary
                        : AppColors.outlineLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: state.isSubmittingAnswer
                      ? Padding(
                          padding: EdgeInsets.all(14.r),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          Iconsax.send_1,
                          size: 22.r,
                          color: state.answerText.trim().isNotEmpty
                              ? Colors.white
                              : AppColors.textTertiaryLight,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isAnonymous = !_isAnonymous),
                child: Row(
                  children: [
                    Icon(
                      _isAnonymous ? Iconsax.tick_square : Iconsax.square,
                      size: 18.r,
                      color: _isAnonymous
                          ? AppColors.primary
                          : AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Answer anonymously',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'recently';
    }
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    return 'just now';
  }
}
