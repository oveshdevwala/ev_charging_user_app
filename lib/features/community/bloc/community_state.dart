/// File: lib/features/community/bloc/community_state.dart
/// Purpose: Community page state for BLoC
/// Belongs To: community feature
/// Customization Guide:
///    - Add new fields for additional community sections
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';
import '../repositories/community_repository.dart';

/// Tabs in community panel.
enum CommunityTab {
  reviews,
  photos,
  qa,
  issues,
}

/// Community page state.
class CommunityState extends Equatable {
  const CommunityState({
    this.stationId = '',
    this.isLoading = false,
    this.isRefreshing = false,
    this.selectedTab = CommunityTab.reviews,
    this.summary,
    this.reviews = const [],
    this.photos = const [],
    this.questions = const [],
    this.reviewSort = ReviewSortOption.mostRecent,
    this.questionSort = QuestionSortOption.mostRecent,
    this.hasMoreReviews = true,
    this.hasMorePhotos = true,
    this.hasMoreQuestions = true,
    this.currentReviewPage = 1,
    this.currentPhotoPage = 1,
    this.currentQuestionPage = 1,
    this.error,
    this.successMessage,
  });

  /// Initial state.
  factory CommunityState.initial({String stationId = ''}) =>
      CommunityState(stationId: stationId, isLoading: true);

  /// Station ID for community data.
  final String stationId;

  /// Loading state.
  final bool isLoading;

  /// Refreshing state.
  final bool isRefreshing;

  /// Currently selected tab.
  final CommunityTab selectedTab;

  /// Station community summary.
  final StationCommunitySummary? summary;

  /// Reviews list.
  final List<CommunityReviewModel> reviews;

  /// Photos list.
  final List<CommunityPhotoModel> photos;

  /// Questions list.
  final List<QuestionModel> questions;

  /// Review sort option.
  final ReviewSortOption reviewSort;

  /// Question sort option.
  final QuestionSortOption questionSort;

  /// Pagination flags.
  final bool hasMoreReviews;
  final bool hasMorePhotos;
  final bool hasMoreQuestions;
  final int currentReviewPage;
  final int currentPhotoPage;
  final int currentQuestionPage;

  /// Error message.
  final String? error;

  /// Success message for feedback.
  final String? successMessage;

  /// Check if has data.
  bool get hasData => summary != null || reviews.isNotEmpty;

  /// Check for error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Copy with new values.
  CommunityState copyWith({
    String? stationId,
    bool? isLoading,
    bool? isRefreshing,
    CommunityTab? selectedTab,
    StationCommunitySummary? summary,
    List<CommunityReviewModel>? reviews,
    List<CommunityPhotoModel>? photos,
    List<QuestionModel>? questions,
    ReviewSortOption? reviewSort,
    QuestionSortOption? questionSort,
    bool? hasMoreReviews,
    bool? hasMorePhotos,
    bool? hasMoreQuestions,
    int? currentReviewPage,
    int? currentPhotoPage,
    int? currentQuestionPage,
    String? error,
    String? successMessage,
  }) {
    return CommunityState(
      stationId: stationId ?? this.stationId,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedTab: selectedTab ?? this.selectedTab,
      summary: summary ?? this.summary,
      reviews: reviews ?? this.reviews,
      photos: photos ?? this.photos,
      questions: questions ?? this.questions,
      reviewSort: reviewSort ?? this.reviewSort,
      questionSort: questionSort ?? this.questionSort,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      hasMorePhotos: hasMorePhotos ?? this.hasMorePhotos,
      hasMoreQuestions: hasMoreQuestions ?? this.hasMoreQuestions,
      currentReviewPage: currentReviewPage ?? this.currentReviewPage,
      currentPhotoPage: currentPhotoPage ?? this.currentPhotoPage,
      currentQuestionPage: currentQuestionPage ?? this.currentQuestionPage,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        stationId,
        isLoading,
        isRefreshing,
        selectedTab,
        summary,
        reviews,
        photos,
        questions,
        reviewSort,
        questionSort,
        hasMoreReviews,
        hasMorePhotos,
        hasMoreQuestions,
        currentReviewPage,
        currentPhotoPage,
        currentQuestionPage,
        error,
        successMessage,
      ];
}

/// State for creating/editing a review.
class ReviewEditorState extends Equatable {
  const ReviewEditorState({
    this.stationId = '',
    this.reviewId,
    this.rating = 0,
    this.title = '',
    this.body = '',
    this.photos = const [],
    this.isVerifiedSession = false,
    this.isAnonymous = false,
    this.isSubmitting = false,
    this.isDraft = false,
    this.error,
    this.submitSuccess = false,
  });

  final String stationId;
  final String? reviewId;
  final double rating;
  final String title;
  final String body;
  final List<String> photos;
  final bool isVerifiedSession;
  final bool isAnonymous;
  final bool isSubmitting;
  final bool isDraft;
  final String? error;
  final bool submitSuccess;

  /// Check if form is valid.
  bool get isValid => rating > 0 && body.length >= 20;

  /// Check if editing existing review.
  bool get isEditing => reviewId != null;

  /// Copy with new values.
  ReviewEditorState copyWith({
    String? stationId,
    String? reviewId,
    double? rating,
    String? title,
    String? body,
    List<String>? photos,
    bool? isVerifiedSession,
    bool? isAnonymous,
    bool? isSubmitting,
    bool? isDraft,
    String? error,
    bool? submitSuccess,
  }) {
    return ReviewEditorState(
      stationId: stationId ?? this.stationId,
      reviewId: reviewId ?? this.reviewId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      body: body ?? this.body,
      photos: photos ?? this.photos,
      isVerifiedSession: isVerifiedSession ?? this.isVerifiedSession,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDraft: isDraft ?? this.isDraft,
      error: error,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }

  @override
  List<Object?> get props => [
        stationId,
        reviewId,
        rating,
        title,
        body,
        photos,
        isVerifiedSession,
        isAnonymous,
        isSubmitting,
        isDraft,
        error,
        submitSuccess,
      ];
}

/// State for Q&A.
class QAState extends Equatable {
  const QAState({
    this.selectedQuestion,
    this.isLoadingQuestion = false,
    this.isSubmittingAnswer = false,
    this.answerText = '',
    this.isAnonymousAnswer = false,
    this.error,
  });

  final QuestionModel? selectedQuestion;
  final bool isLoadingQuestion;
  final bool isSubmittingAnswer;
  final String answerText;
  final bool isAnonymousAnswer;
  final String? error;

  /// Copy with new values.
  QAState copyWith({
    QuestionModel? selectedQuestion,
    bool? isLoadingQuestion,
    bool? isSubmittingAnswer,
    String? answerText,
    bool? isAnonymousAnswer,
    String? error,
  }) {
    return QAState(
      selectedQuestion: selectedQuestion ?? this.selectedQuestion,
      isLoadingQuestion: isLoadingQuestion ?? this.isLoadingQuestion,
      isSubmittingAnswer: isSubmittingAnswer ?? this.isSubmittingAnswer,
      answerText: answerText ?? this.answerText,
      isAnonymousAnswer: isAnonymousAnswer ?? this.isAnonymousAnswer,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        selectedQuestion,
        isLoadingQuestion,
        isSubmittingAnswer,
        answerText,
        isAnonymousAnswer,
        error,
      ];
}

/// State for reporting.
class ReportState extends Equatable {
  const ReportState({
    this.targetType = ReportTargetType.station,
    this.targetId = '',
    this.category,
    this.description = '',
    this.photoPath,
    this.isAnonymous = false,
    this.isSubmitting = false,
    this.submittedReport,
    this.error,
  });

  final ReportTargetType targetType;
  final String targetId;
  final ReportCategory? category;
  final String description;
  final String? photoPath;
  final bool isAnonymous;
  final bool isSubmitting;
  final ReportModel? submittedReport;
  final String? error;

  /// Check if form is valid.
  bool get isValid => category != null;

  /// Check if submitted successfully.
  bool get isSubmitted => submittedReport != null;

  /// Copy with new values.
  ReportState copyWith({
    ReportTargetType? targetType,
    String? targetId,
    ReportCategory? category,
    String? description,
    String? photoPath,
    bool? isAnonymous,
    bool? isSubmitting,
    ReportModel? submittedReport,
    String? error,
  }) {
    return ReportState(
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      category: category ?? this.category,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submittedReport: submittedReport ?? this.submittedReport,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        targetType,
        targetId,
        category,
        description,
        photoPath,
        isAnonymous,
        isSubmitting,
        submittedReport,
        error,
      ];
}

