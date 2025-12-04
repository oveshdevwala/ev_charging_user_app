/// File: lib/features/community/bloc/community_cubit.dart
/// Purpose: Community page Cubit for managing reviews, photos, Q&A
/// Belongs To: community feature
/// Customization Guide:
///    - Add new methods for additional community interactions
///    - All async operations should handle errors properly
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../repositories/community_repository.dart';
import 'community_state.dart';

/// Community Cubit managing reviews, photos, and Q&A.
class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit({
    required CommunityRepository repository,
    required String stationId,
  }) : _repository = repository,
       super(CommunityState.initial(stationId: stationId));

  final CommunityRepository _repository;
  static const int _pageSize = 20;

  /// Load initial community data.
  Future<void> loadCommunityData() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Fetch all data in parallel
      final summaryFuture = _repository.getCommunitySummary(state.stationId);
      final reviewsFuture = _repository.getReviews(
        stationId: state.stationId,
        sort: state.reviewSort,
      );
      final photosFuture = _repository.getPhotos(stationId: state.stationId);
      final questionsFuture = _repository.getQuestions(
        stationId: state.stationId,
        sort: state.questionSort,
      );

      final summary = await summaryFuture;
      final reviews = await reviewsFuture;
      final photos = await photosFuture;
      final questions = await questionsFuture;

      emit(
        state.copyWith(
          isLoading: false,
          summary: summary,
          reviews: reviews,
          photos: photos,
          questions: questions,
          hasMoreReviews: reviews.length >= _pageSize,
          hasMorePhotos: photos.length >= _pageSize,
          hasMoreQuestions: questions.length >= _pageSize,
          currentReviewPage: 1,
          currentPhotoPage: 1,
          currentQuestionPage: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Refresh community data.
  Future<void> refreshCommunityData() async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final summaryFuture = _repository.getCommunitySummary(state.stationId);
      final reviewsFuture = _repository.getReviews(
        stationId: state.stationId,
        sort: state.reviewSort,
      );
      final photosFuture = _repository.getPhotos(stationId: state.stationId);
      final questionsFuture = _repository.getQuestions(
        stationId: state.stationId,
        sort: state.questionSort,
      );

      final summary = await summaryFuture;
      final reviews = await reviewsFuture;
      final photos = await photosFuture;
      final questions = await questionsFuture;

      emit(
        state.copyWith(
          isRefreshing: false,
          summary: summary,
          reviews: reviews,
          photos: photos,
          questions: questions,
          hasMoreReviews: reviews.length >= _pageSize,
          hasMorePhotos: photos.length >= _pageSize,
          hasMoreQuestions: questions.length >= _pageSize,
          currentReviewPage: 1,
          currentPhotoPage: 1,
          currentQuestionPage: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, error: e.toString()));
    }
  }

  /// Change selected tab.
  void selectTab(CommunityTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  // ============ Reviews ============

  /// Load more reviews.
  Future<void> loadMoreReviews() async {
    if (!state.hasMoreReviews) {
      return;
    }

    try {
      final nextPage = state.currentReviewPage + 1;
      final newReviews = await _repository.getReviews(
        stationId: state.stationId,
        page: nextPage,
        sort: state.reviewSort,
      );

      emit(
        state.copyWith(
          reviews: [...state.reviews, ...newReviews],
          hasMoreReviews: newReviews.length >= _pageSize,
          currentReviewPage: nextPage,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Change review sort option.
  Future<void> changeReviewSort(ReviewSortOption sort) async {
    if (state.reviewSort == sort) {
      return;
    }

    emit(state.copyWith(reviewSort: sort, isLoading: true));

    try {
      final reviews = await _repository.getReviews(
        stationId: state.stationId,
        sort: sort,
      );

      emit(
        state.copyWith(
          isLoading: false,
          reviews: reviews,
          hasMoreReviews: reviews.length >= _pageSize,
          currentReviewPage: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Toggle helpful on a review (optimistic update).
  Future<void> toggleReviewHelpful(String reviewId) async {
    // Optimistic update
    final updatedReviews = state.reviews.map((r) {
      if (r.id == reviewId) {
        final newCount = r.isHelpfulByMe
            ? r.helpfulCount - 1
            : r.helpfulCount + 1;
        return r.copyWith(
          helpfulCount: newCount,
          isHelpfulByMe: !r.isHelpfulByMe,
        );
      }
      return r;
    }).toList();

    emit(state.copyWith(reviews: updatedReviews));

    try {
      await _repository.toggleHelpful(reviewId);
    } catch (e) {
      // Revert on error
      emit(state.copyWith(reviews: state.reviews, error: e.toString()));
    }
  }

  /// Flag a review.
  Future<void> flagReview(String reviewId, String reason) async {
    try {
      await _repository.flagReview(reviewId, reason);
      emit(state.copyWith(successMessage: 'Review reported successfully'));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Add a new review to the list (after creation).
  void addReview(CommunityReviewModel review) {
    final updatedReviews = [review, ...state.reviews];
    final updatedSummary = state.summary?.copyWith(
      ratingCount: (state.summary?.ratingCount ?? 0) + 1,
    );
    emit(
      state.copyWith(
        reviews: updatedReviews,
        summary: updatedSummary,
        successMessage: 'Review submitted successfully',
      ),
    );
  }

  // ============ Photos ============

  /// Load more photos.
  Future<void> loadMorePhotos() async {
    if (!state.hasMorePhotos) {
      return;
    }

    try {
      final nextPage = state.currentPhotoPage + 1;
      final newPhotos = await _repository.getPhotos(
        stationId: state.stationId,
        page: nextPage,
      );

      emit(
        state.copyWith(
          photos: [...state.photos, ...newPhotos],
          hasMorePhotos: newPhotos.length >= _pageSize,
          currentPhotoPage: nextPage,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // ============ Questions ============

  /// Load more questions.
  Future<void> loadMoreQuestions() async {
    if (!state.hasMoreQuestions) {
      return;
    }

    try {
      final nextPage = state.currentQuestionPage + 1;
      final newQuestions = await _repository.getQuestions(
        stationId: state.stationId,
        page: nextPage,
        sort: state.questionSort,
      );

      emit(
        state.copyWith(
          questions: [...state.questions, ...newQuestions],
          hasMoreQuestions: newQuestions.length >= _pageSize,
          currentQuestionPage: nextPage,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Change question sort option.
  Future<void> changeQuestionSort(QuestionSortOption sort) async {
    if (state.questionSort == sort) {
      return;
    }

    emit(state.copyWith(questionSort: sort, isLoading: true));

    try {
      final questions = await _repository.getQuestions(
        stationId: state.stationId,
        sort: sort,
      );

      emit(
        state.copyWith(
          isLoading: false,
          questions: questions,
          hasMoreQuestions: questions.length >= _pageSize,
          currentQuestionPage: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Toggle upvote on a question (optimistic update).
  Future<void> toggleQuestionUpvote(String questionId) async {
    // Optimistic update
    final updatedQuestions = state.questions.map((q) {
      if (q.id == questionId) {
        final newCount = q.isUpvotedByMe
            ? q.upvotesCount - 1
            : q.upvotesCount + 1;
        return q.copyWith(
          upvotesCount: newCount,
          isUpvotedByMe: !q.isUpvotedByMe,
        );
      }
      return q;
    }).toList();

    emit(state.copyWith(questions: updatedQuestions));

    try {
      await _repository.toggleQuestionUpvote(questionId);
    } catch (e) {
      // Revert on error
      emit(state.copyWith(questions: state.questions, error: e.toString()));
    }
  }

  /// Add a new question to the list.
  void addQuestion(QuestionModel question) {
    final updatedQuestions = [question, ...state.questions];
    final updatedSummary = state.summary?.copyWith(
      questionsCount: (state.summary?.questionsCount ?? 0) + 1,
    );
    emit(
      state.copyWith(
        questions: updatedQuestions,
        summary: updatedSummary,
        successMessage: 'Question posted successfully',
      ),
    );
  }

  /// Clear messages.
  void clearMessages() {
    emit(state.copyWith());
  }
}

/// Review Editor Cubit for creating/editing reviews.
class ReviewEditorCubit extends Cubit<ReviewEditorState> {
  ReviewEditorCubit({
    required CommunityRepository repository,
    required String stationId,
    String? reviewId,
  }) : _repository = repository,
       super(ReviewEditorState(stationId: stationId, reviewId: reviewId));

  final CommunityRepository _repository;

  /// Update rating.
  void updateRating(double rating) {
    emit(state.copyWith(rating: rating));
  }

  /// Update title.
  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  /// Update body.
  void updateBody(String body) {
    emit(state.copyWith(body: body));
  }

  /// Add photo.
  void addPhoto(String photoPath) {
    emit(state.copyWith(photos: [...state.photos, photoPath]));
  }

  /// Remove photo.
  void removePhoto(int index) {
    final photos = [...state.photos]..removeAt(index);
    emit(state.copyWith(photos: photos));
  }

  /// Toggle verified session.
  void toggleVerifiedSession({required bool value}) {
    emit(state.copyWith(isVerifiedSession: value));
  }

  /// Toggle anonymous.
  void toggleAnonymous({required bool value}) {
    emit(state.copyWith(isAnonymous: value));
  }

  /// Save as draft.
  void saveDraft() {
    emit(state.copyWith(isDraft: true));
    // In real implementation, save to local storage
  }

  /// Submit review.
  Future<CommunityReviewModel?> submitReview() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          error: 'Please provide a rating and at least 20 characters',
        ),
      );
      return null;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final review = await _repository.createReview(
        stationId: state.stationId,
        rating: state.rating,
        title: state.title.isNotEmpty ? state.title : null,
        body: state.body,
        photoUploadIds: state.photos.isNotEmpty ? state.photos : null,
        verifiedSession: state.isVerifiedSession,
        anonymous: state.isAnonymous,
      );

      emit(state.copyWith(isSubmitting: false, submitSuccess: true));

      return review;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
      return null;
    }
  }

  /// Clear error.
  void clearError() {
    emit(state.copyWith());
  }
}

/// Q&A Cubit for managing questions and answers.
class QACubit extends Cubit<QAState> {
  QACubit({required CommunityRepository repository})
    : _repository = repository,
      super(const QAState());

  final CommunityRepository _repository;

  /// Load question with answers.
  Future<void> loadQuestion(String questionId) async {
    emit(state.copyWith(isLoadingQuestion: true));

    try {
      final question = await _repository.getQuestionById(questionId);
      emit(
        state.copyWith(isLoadingQuestion: false, selectedQuestion: question),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingQuestion: false, error: e.toString()));
    }
  }

  /// Update answer text.
  void updateAnswerText(String text) {
    emit(state.copyWith(answerText: text));
  }

  /// Toggle anonymous answer.
  void toggleAnonymousAnswer({required bool value}) {
    emit(state.copyWith(isAnonymousAnswer: value));
  }

  /// Submit answer.
  Future<AnswerModel?> submitAnswer(String questionId) async {
    if (state.answerText.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter an answer'));
      return null;
    }

    emit(state.copyWith(isSubmittingAnswer: true));

    try {
      final answer = await _repository.createAnswer(
        questionId: questionId,
        text: state.answerText,
        anonymous: state.isAnonymousAnswer,
      );

      // Update selected question with new answer
      if (state.selectedQuestion != null) {
        final updatedAnswers = [...state.selectedQuestion!.answers, answer];
        emit(
          state.copyWith(
            isSubmittingAnswer: false,
            selectedQuestion: state.selectedQuestion!.copyWith(
              answers: updatedAnswers,
              answersCount: updatedAnswers.length,
            ),
            answerText: '',
          ),
        );
      }

      return answer;
    } catch (e) {
      emit(state.copyWith(isSubmittingAnswer: false, error: e.toString()));
      return null;
    }
  }

  /// Accept answer.
  Future<void> acceptAnswer(String answerId) async {
    try {
      await _repository.acceptAnswer(answerId);

      if (state.selectedQuestion != null) {
        final updatedAnswers = state.selectedQuestion!.answers.map((a) {
          if (a.id == answerId) {
            return a.copyWith(isAccepted: true);
          }
          return a.copyWith(isAccepted: false);
        }).toList();

        emit(
          state.copyWith(
            selectedQuestion: state.selectedQuestion!.copyWith(
              answers: updatedAnswers,
              hasAcceptedAnswer: true,
            ),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Toggle answer helpful.
  Future<void> toggleAnswerHelpful(String answerId) async {
    if (state.selectedQuestion == null) {
      return;
    }

    // Optimistic update
    final updatedAnswers = state.selectedQuestion!.answers.map((a) {
      if (a.id == answerId) {
        final newCount = a.isHelpfulByMe
            ? a.helpfulCount - 1
            : a.helpfulCount + 1;
        return a.copyWith(
          helpfulCount: newCount,
          isHelpfulByMe: !a.isHelpfulByMe,
        );
      }
      return a;
    }).toList();

    emit(
      state.copyWith(
        selectedQuestion: state.selectedQuestion!.copyWith(
          answers: updatedAnswers,
        ),
      ),
    );

    try {
      await _repository.toggleAnswerHelpful(answerId);
    } catch (e) {
      // Revert on error
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Clear selection.
  void clearSelection() {
    emit(const QAState());
  }
}

/// Report Cubit for creating reports.
class ReportCubit extends Cubit<ReportState> {
  ReportCubit({
    required CommunityRepository repository,
    required ReportTargetType targetType,
    required String targetId,
  }) : _repository = repository,
       super(ReportState(targetType: targetType, targetId: targetId));

  final CommunityRepository _repository;

  /// Select category.
  void selectCategory(ReportCategory category) {
    emit(state.copyWith(category: category));
  }

  /// Update description.
  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  /// Set photo.
  void setPhoto(String? path) {
    emit(state.copyWith(photoPath: path));
  }

  /// Toggle anonymous.
  void toggleAnonymous({required bool value}) {
    emit(state.copyWith(isAnonymous: value));
  }

  /// Submit report.
  Future<bool> submitReport() async {
    if (!state.isValid) {
      emit(state.copyWith(error: 'Please select a category'));
      return false;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final report = await _repository.createReport(
        targetType: state.targetType,
        targetId: state.targetId,
        category: state.category!,
        description: state.description.isNotEmpty ? state.description : null,
        photoUploadId: state.photoPath,
        anonymous: state.isAnonymous,
      );

      emit(state.copyWith(isSubmitting: false, submittedReport: report));

      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
      return false;
    }
  }

  /// Clear error.
  void clearError() {
    emit(state.copyWith());
  }
}
