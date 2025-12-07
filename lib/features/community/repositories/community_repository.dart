/// File: lib/features/community/repositories/community_repository.dart
/// Purpose: Community repository interface and dummy implementation
/// Belongs To: community feature
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyCommunityRepository with real implementation
library;

import '../models/models.dart';

/// Sort options for reviews.
enum ReviewSortOption { mostRecent, mostHelpful, highestRating, lowestRating }

/// Sort options for questions.
enum QuestionSortOption { mostRecent, mostUpvoted, unanswered, answered }

/// Community repository interface.
abstract class CommunityRepository {
  // ============ Reviews ============

  /// Get reviews for a station.
  Future<List<CommunityReviewModel>> getReviews({
    required String stationId,
    int page = 1,
    int limit = 20,
    ReviewSortOption sort = ReviewSortOption.mostRecent,
  });

  /// Get a single review by ID.
  Future<CommunityReviewModel?> getReviewById(String reviewId);

  /// Create a new review.
  Future<CommunityReviewModel> createReview({
    required String stationId,
    required double rating,
    String? title,
    String? body,
    List<String>? photoUploadIds,
    bool verifiedSession = false,
    bool anonymous = false,
  });

  /// Update an existing review.
  Future<CommunityReviewModel> updateReview({
    required String reviewId,
    double? rating,
    String? title,
    String? body,
    List<String>? photoUploadIds,
  });

  /// Delete a review.
  Future<bool> deleteReview(String reviewId);

  /// Mark review as helpful.
  Future<bool> toggleHelpful(String reviewId);

  /// Flag a review.
  Future<bool> flagReview(String reviewId, String reason);

  // ============ Photos ============

  /// Get photos for a station.
  Future<List<CommunityPhotoModel>> getPhotos({
    required String stationId,
    int page = 1,
    int limit = 20,
    bool verifiedOnly = false,
  });

  /// Upload a photo.
  Future<CommunityPhotoModel> uploadPhoto({
    required String stationId,
    required String localPath,
    String? reviewId,
    String? caption,
  });

  /// Delete a photo.
  Future<bool> deletePhoto(String photoId);

  // ============ Questions ============

  /// Get questions for a station.
  Future<List<QuestionModel>> getQuestions({
    required String stationId,
    int page = 1,
    int limit = 20,
    QuestionSortOption sort = QuestionSortOption.mostRecent,
  });

  /// Get a single question with answers.
  Future<QuestionModel?> getQuestionById(String questionId);

  /// Create a new question.
  Future<QuestionModel> createQuestion({
    required String stationId,
    required String text,
    String? photoUrl,
    bool anonymous = false,
  });

  /// Upvote a question.
  Future<bool> toggleQuestionUpvote(String questionId);

  // ============ Answers ============

  /// Create an answer.
  Future<AnswerModel> createAnswer({
    required String questionId,
    required String text,
    String? photoUrl,
    bool anonymous = false,
  });

  /// Mark answer as accepted.
  Future<bool> acceptAnswer(String answerId);

  /// Mark answer as helpful.
  Future<bool> toggleAnswerHelpful(String answerId);

  /// Delete an answer.
  Future<bool> deleteAnswer(String answerId);

  // ============ Reports ============

  /// Create a report.
  Future<ReportModel> createReport({
    required ReportTargetType targetType,
    required String targetId,
    required ReportCategory category,
    String? description,
    String? photoUploadId,
    bool anonymous = false,
  });

  /// Get user's reports.
  Future<List<ReportModel>> getMyReports({int page = 1, int limit = 20});

  // ============ Summary ============

  /// Get community summary for a station.
  Future<StationCommunitySummary> getCommunitySummary(String stationId);

  /// Get user community profile.
  Future<CommunityUserProfile> getUserProfile(String userId);

  /// Get current user's community profile.
  Future<CommunityUserProfile> getMyProfile();
}

/// Dummy community repository for development/testing.
class DummyCommunityRepository implements CommunityRepository {
  final List<CommunityReviewModel> _reviews = _generateDummyReviews();
  final List<QuestionModel> _questions = _generateDummyQuestions();
  final List<ReportModel> _reports = [];
  final Set<String> _helpfulReviews = {};
  final Set<String> _upvotedQuestions = {};
  final Set<String> _helpfulAnswers = {};

  static List<CommunityReviewModel> _generateDummyReviews() {
    return [
      CommunityReviewModel(
        id: 'review_1',
        stationId: 'station_1',
        userId: 'user_1',
        rating: 5,
        title: 'Excellent charging experience!',
        body:
            'Fast and reliable charging. The connectors were in great condition and I charged from 20% to 80% in just 22 minutes. Will definitely come back!',
        photos: [
          CommunityPhotoModel(
            id: 'photo_1',
            reviewId: 'review_1',
            stationId: 'station_1',
            url: 'https://images.pexels.com/photos/1103970/pexels-photo-1103970.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop',
            thumbnailUrl:
                'https://images.pexels.com/photos/1103970/pexels-photo-1103970.jpeg?auto=compress&cs=tinysrgb&w=200&h=200&fit=crop',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
        isVerifiedSession: true,
        helpfulCount: 24,
        userName: 'Sarah M.',
        userAvatar: 'https://i.pravatar.cc/150?u=sarah',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CommunityReviewModel(
        id: 'review_2',
        stationId: 'station_1',
        userId: 'user_2',
        rating: 4,
        title: 'Good station, bit crowded',
        body:
            'The charging speed is great and the location is convenient. However, it can get quite busy during peak hours. I recommend coming early in the morning.',
        isVerifiedSession: true,
        helpfulCount: 15,
        userName: 'Mike R.',
        userAvatar: 'https://i.pravatar.cc/150?u=mike',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CommunityReviewModel(
        id: 'review_3',
        stationId: 'station_1',
        userId: 'user_3',
        rating: 4.5,
        title: 'Clean and well-maintained',
        body:
            'One of the cleanest charging stations I have visited. The cafe nearby is a nice bonus while waiting.',
        photos: [
          CommunityPhotoModel(
            id: 'photo_2',
            reviewId: 'review_3',
            stationId: 'station_1',
            url: 'https://images.pexels.com/photos/3802508/pexels-photo-3802508.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop',
            thumbnailUrl:
                'https://images.pexels.com/photos/3802508/pexels-photo-3802508.jpeg?auto=compress&cs=tinysrgb&w=200&h=200&fit=crop',
            createdAt: DateTime.now().subtract(const Duration(days: 8)),
          ),
          CommunityPhotoModel(
            id: 'photo_3',
            reviewId: 'review_3',
            stationId: 'station_1',
            url: 'https://images.pexels.com/photos/3844788/pexels-photo-3844788.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop',
            thumbnailUrl:
                'https://images.pexels.com/photos/3844788/pexels-photo-3844788.jpeg?auto=compress&cs=tinysrgb&w=200&h=200&fit=crop',
            createdAt: DateTime.now().subtract(const Duration(days: 8)),
          ),
        ],
        helpfulCount: 8,
        userName: 'Emily K.',
        userAvatar: 'https://i.pravatar.cc/150?u=emily',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      CommunityReviewModel(
        id: 'review_4',
        stationId: 'station_1',
        userId: 'user_4',
        rating: 3,
        title: 'Average experience',
        body:
            'Charging worked fine but one of the chargers was out of order. Staff was helpful though.',
        isAnonymous: true,
        helpfulCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      CommunityReviewModel(
        id: 'review_5',
        stationId: 'station_1',
        userId: 'user_5',
        rating: 5,
        title: 'Best station in the area',
        body:
            'I have tried all charging stations nearby and this is by far the best one. Fast charging, great amenities, and reasonable prices.',
        isVerifiedSession: true,
        helpfulCount: 32,
        userName: 'David L.',
        userAvatar: 'https://i.pravatar.cc/150?u=david',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static List<QuestionModel> _generateDummyQuestions() {
    return [
      QuestionModel(
        id: 'question_1',
        stationId: 'station_1',
        userId: 'user_6',
        text: 'Does this station support CCS2 connectors for European EVs?',
        upvotesCount: 12,
        answersCount: 2,
        hasAcceptedAnswer: true,
        userName: 'Tom B.',
        userAvatar: 'https://i.pravatar.cc/150?u=tom',
        answers: [
          AnswerModel(
            id: 'answer_1',
            questionId: 'question_1',
            userId: 'user_7',
            text:
                'Yes! This station has both CCS1 and CCS2 connectors. I charged my European import car here without any issues.',
            isAccepted: true,
            helpfulCount: 8,
            userName: 'Lisa H.',
            userAvatar: 'https://i.pravatar.cc/150?u=lisa',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          AnswerModel(
            id: 'answer_2',
            questionId: 'question_1',
            userId: 'user_8',
            text:
                'Confirmed! They have universal connectors including CCS2, CHAdeMO, and Type 2.',
            helpfulCount: 4,
            userName: 'James W.',
            userAvatar: 'https://i.pravatar.cc/150?u=james',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      QuestionModel(
        id: 'question_2',
        stationId: 'station_1',
        userId: 'user_9',
        text: 'What is the typical wait time during weekday mornings?',
        upvotesCount: 8,
        answersCount: 1,
        userName: 'Maria G.',
        userAvatar: 'https://i.pravatar.cc/150?u=maria',
        answers: [
          AnswerModel(
            id: 'answer_3',
            questionId: 'question_2',
            userId: 'user_10',
            text:
                'I usually visit around 8-9 AM and there is rarely any wait. The station has 4 fast chargers so turnover is quick.',
            helpfulCount: 6,
            userName: 'Robert P.',
            userAvatar: 'https://i.pravatar.cc/150?u=robert',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      QuestionModel(
        id: 'question_3',
        stationId: 'station_1',
        userId: 'user_11',
        text: 'Is there covered parking available?',
        upvotesCount: 5,
        userName: 'Alex T.',
        userAvatar: 'https://i.pravatar.cc/150?u=alex',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  // ============ Reviews Implementation ============

  @override
  Future<List<CommunityReviewModel>> getReviews({
    required String stationId,
    int page = 1,
    int limit = 20,
    ReviewSortOption sort = ReviewSortOption.mostRecent,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    var reviews = _reviews.where((r) => r.stationId == stationId).toList();

    // Apply sorting
    switch (sort) {
      case ReviewSortOption.mostRecent:
        reviews.sort(
          (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
            a.createdAt ?? DateTime.now(),
          ),
        );
        break;
      case ReviewSortOption.mostHelpful:
        reviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
      case ReviewSortOption.highestRating:
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSortOption.lowestRating:
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    // Apply helpful status
    reviews = reviews.map((r) {
      return r.copyWith(isHelpfulByMe: _helpfulReviews.contains(r.id));
    }).toList();

    // Pagination
    final start = (page - 1) * limit;
    if (start >= reviews.length) {
      return [];
    }
    final end = (start + limit) > reviews.length
        ? reviews.length
        : start + limit;

    return reviews.sublist(start, end);
  }

  @override
  Future<CommunityReviewModel?> getReviewById(String reviewId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    try {
      final review = _reviews.firstWhere((r) => r.id == reviewId);
      return review.copyWith(isHelpfulByMe: _helpfulReviews.contains(reviewId));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CommunityReviewModel> createReview({
    required String stationId,
    required double rating,
    String? title,
    String? body,
    List<String>? photoUploadIds,
    bool verifiedSession = false,
    bool anonymous = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final review = CommunityReviewModel(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      stationId: stationId,
      userId: 'current_user',
      rating: rating,
      title: title,
      body: body,
      photos:
          photoUploadIds
              ?.map(
                (id) => CommunityPhotoModel(
                  id: id,
                  stationId: stationId,
                  url: 'https://picsum.photos/400/300?random=$id',
                  createdAt: DateTime.now(),
                ),
              )
              .toList() ??
          [],
      isVerifiedSession: verifiedSession,
      isAnonymous: anonymous,
      userName: anonymous ? null : 'Current User',
      userAvatar: anonymous ? null : 'https://i.pravatar.cc/150?u=current',
      createdAt: DateTime.now(),
    );

    _reviews.insert(0, review);
    return review;
  }

  @override
  Future<CommunityReviewModel> updateReview({
    required String reviewId,
    double? rating,
    String? title,
    String? body,
    List<String>? photoUploadIds,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) {
      throw Exception('Review not found');
    }

    final updated = _reviews[index].copyWith(
      rating: rating,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
    );

    _reviews[index] = updated;
    return updated;
  }

  @override
  Future<bool> deleteReview(String reviewId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _reviews.removeWhere((r) => r.id == reviewId);
    return true;
  }

  @override
  Future<bool> toggleHelpful(String reviewId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) {
      return false;
    }

    if (_helpfulReviews.contains(reviewId)) {
      _helpfulReviews.remove(reviewId);
      _reviews[index] = _reviews[index].copyWith(
        helpfulCount: _reviews[index].helpfulCount - 1,
        isHelpfulByMe: false,
      );
    } else {
      _helpfulReviews.add(reviewId);
      _reviews[index] = _reviews[index].copyWith(
        helpfulCount: _reviews[index].helpfulCount + 1,
        isHelpfulByMe: true,
      );
    }

    return _helpfulReviews.contains(reviewId);
  }

  @override
  Future<bool> flagReview(String reviewId, String reason) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) {
      return false;
    }

    _reviews[index] = _reviews[index].copyWith(
      flagsCount: _reviews[index].flagsCount + 1,
      isFlaggedByMe: true,
    );

    return true;
  }

  // ============ Photos Implementation ============

  @override
  Future<List<CommunityPhotoModel>> getPhotos({
    required String stationId,
    int page = 1,
    int limit = 20,
    bool verifiedOnly = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final allPhotos = _reviews
        .where((r) => r.stationId == stationId)
        .expand((r) => r.photos)
        .toList()

    ..sort(
      (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
        a.createdAt ?? DateTime.now(),
      ),
    );

    final start = (page - 1) * limit;
    if (start >= allPhotos.length) {
      return [];
    }
    final end = (start + limit) > allPhotos.length
        ? allPhotos.length
        : start + limit;

    return allPhotos.sublist(start, end);
  }

  @override
  Future<CommunityPhotoModel> uploadPhoto({
    required String stationId,
    required String localPath,
    String? reviewId,
    String? caption,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    return CommunityPhotoModel(
      id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      stationId: stationId,
      reviewId: reviewId,
      userId: 'current_user',
      url:
          'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}',
      thumbnailUrl:
          'https://picsum.photos/200/150?random=${DateTime.now().millisecondsSinceEpoch}',
      caption: caption,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> deletePhoto(String photoId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return true;
  }

  // ============ Questions Implementation ============

  @override
  Future<List<QuestionModel>> getQuestions({
    required String stationId,
    int page = 1,
    int limit = 20,
    QuestionSortOption sort = QuestionSortOption.mostRecent,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    var questions = _questions.where((q) => q.stationId == stationId).toList();

    // Apply sorting
    switch (sort) {
      case QuestionSortOption.mostRecent:
        questions.sort(
          (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
            a.createdAt ?? DateTime.now(),
          ),
        );
        break;
      case QuestionSortOption.mostUpvoted:
        questions.sort((a, b) => b.upvotesCount.compareTo(a.upvotesCount));
        break;
      case QuestionSortOption.unanswered:
        questions = questions.where((q) => q.answersCount == 0).toList();
        break;
      case QuestionSortOption.answered:
        questions = questions.where((q) => q.hasAcceptedAnswer).toList();
        break;
    }

    // Apply upvote status
    questions = questions.map((q) {
      return q.copyWith(isUpvotedByMe: _upvotedQuestions.contains(q.id));
    }).toList();

    final start = (page - 1) * limit;
    if (start >= questions.length) {
      return [];
    }
    final end = (start + limit) > questions.length
        ? questions.length
        : start + limit;

    return questions.sublist(start, end);
  }

  @override
  Future<QuestionModel?> getQuestionById(String questionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    try {
      final question = _questions.firstWhere((q) => q.id == questionId);
      return question.copyWith(
        isUpvotedByMe: _upvotedQuestions.contains(questionId),
        answers: question.answers.map((a) {
          return a.copyWith(isHelpfulByMe: _helpfulAnswers.contains(a.id));
        }).toList(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<QuestionModel> createQuestion({
    required String stationId,
    required String text,
    String? photoUrl,
    bool anonymous = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final question = QuestionModel(
      id: 'question_${DateTime.now().millisecondsSinceEpoch}',
      stationId: stationId,
      userId: 'current_user',
      text: text,
      photoUrl: photoUrl,
      isAnonymous: anonymous,
      userName: anonymous ? null : 'Current User',
      userAvatar: anonymous ? null : 'https://i.pravatar.cc/150?u=current',
      createdAt: DateTime.now(),
    );

    _questions.insert(0, question);
    return question;
  }

  @override
  Future<bool> toggleQuestionUpvote(String questionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _questions.indexWhere((q) => q.id == questionId);
    if (index == -1) {
      return false;
    }

    if (_upvotedQuestions.contains(questionId)) {
      _upvotedQuestions.remove(questionId);
      _questions[index] = _questions[index].copyWith(
        upvotesCount: _questions[index].upvotesCount - 1,
        isUpvotedByMe: false,
      );
    } else {
      _upvotedQuestions.add(questionId);
      _questions[index] = _questions[index].copyWith(
        upvotesCount: _questions[index].upvotesCount + 1,
        isUpvotedByMe: true,
      );
    }

    return _upvotedQuestions.contains(questionId);
  }

  // ============ Answers Implementation ============

  @override
  Future<AnswerModel> createAnswer({
    required String questionId,
    required String text,
    String? photoUrl,
    bool anonymous = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final answer = AnswerModel(
      id: 'answer_${DateTime.now().millisecondsSinceEpoch}',
      questionId: questionId,
      userId: 'current_user',
      text: text,
      photoUrl: photoUrl,
      isAnonymous: anonymous,
      userName: anonymous ? null : 'Current User',
      userAvatar: anonymous ? null : 'https://i.pravatar.cc/150?u=current',
      createdAt: DateTime.now(),
    );

    final qIndex = _questions.indexWhere((q) => q.id == questionId);
    if (qIndex != -1) {
      final updatedAnswers = [..._questions[qIndex].answers, answer];
      _questions[qIndex] = _questions[qIndex].copyWith(
        answers: updatedAnswers,
        answersCount: updatedAnswers.length,
      );
    }

    return answer;
  }

  @override
  Future<bool> acceptAnswer(String answerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    for (var i = 0; i < _questions.length; i++) {
      final answerIndex = _questions[i].answers.indexWhere(
        (a) => a.id == answerId,
      );
      if (answerIndex != -1) {
        final updatedAnswers = _questions[i].answers.map((a) {
          if (a.id == answerId) {
            return a.copyWith(isAccepted: true);
          }
          return a.copyWith(isAccepted: false);
        }).toList();

        _questions[i] = _questions[i].copyWith(
          answers: updatedAnswers,
          hasAcceptedAnswer: true,
        );
        return true;
      }
    }

    return false;
  }

  @override
  Future<bool> toggleAnswerHelpful(String answerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (_helpfulAnswers.contains(answerId)) {
      _helpfulAnswers.remove(answerId);
    } else {
      _helpfulAnswers.add(answerId);
    }

    for (var i = 0; i < _questions.length; i++) {
      final answerIndex = _questions[i].answers.indexWhere(
        (a) => a.id == answerId,
      );
      if (answerIndex != -1) {
        final updatedAnswers = _questions[i].answers.map((a) {
          if (a.id == answerId) {
            final newCount = _helpfulAnswers.contains(answerId)
                ? a.helpfulCount + 1
                : a.helpfulCount - 1;
            return a.copyWith(
              helpfulCount: newCount,
              isHelpfulByMe: _helpfulAnswers.contains(answerId),
            );
          }
          return a;
        }).toList();

        _questions[i] = _questions[i].copyWith(answers: updatedAnswers);
        return _helpfulAnswers.contains(answerId);
      }
    }

    return false;
  }

  @override
  Future<bool> deleteAnswer(String answerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    for (var i = 0; i < _questions.length; i++) {
      final answerIndex = _questions[i].answers.indexWhere(
        (a) => a.id == answerId,
      );
      if (answerIndex != -1) {
        final updatedAnswers = _questions[i].answers
            .where((a) => a.id != answerId)
            .toList();
        _questions[i] = _questions[i].copyWith(
          answers: updatedAnswers,
          answersCount: updatedAnswers.length,
        );
        return true;
      }
    }

    return false;
  }

  // ============ Reports Implementation ============

  @override
  Future<ReportModel> createReport({
    required ReportTargetType targetType,
    required String targetId,
    required ReportCategory category,
    String? description,
    String? photoUploadId,
    bool anonymous = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final report = ReportModel(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      targetType: targetType,
      targetId: targetId,
      reporterId: anonymous ? null : 'current_user',
      category: category,
      description: description,
      photoUrl: photoUploadId != null
          ? 'https://picsum.photos/400/300?random=$photoUploadId'
          : null,
      isAnonymous: anonymous,
      ticketId:
          'TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      createdAt: DateTime.now(),
    );

    _reports.insert(0, report);
    return report;
  }

  @override
  Future<List<ReportModel>> getMyReports({int page = 1, int limit = 20}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final start = (page - 1) * limit;
    if (start >= _reports.length) {
      return [];
    }
    final end = (start + limit) > _reports.length
        ? _reports.length
        : start + limit;

    return _reports.sublist(start, end);
  }

  // ============ Summary Implementation ============

  @override
  Future<StationCommunitySummary> getCommunitySummary(String stationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final stationReviews = _reviews
        .where((r) => r.stationId == stationId)
        .toList();
    final stationQuestions = _questions
        .where((q) => q.stationId == stationId)
        .toList();

    final avgRating = stationReviews.isEmpty
        ? 0.0
        : stationReviews.map((r) => r.rating).reduce((a, b) => a + b) /
              stationReviews.length;

    final verifiedCount = stationReviews
        .where((r) => r.isVerifiedSession)
        .length;

    final photosCount = stationReviews.expand((r) => r.photos).length;

    // Calculate trust score (simplified)
    final trustScore = _calculateTrustScore(
      avgRating: avgRating,
      verifiedRatio: stationReviews.isEmpty
          ? 0
          : verifiedCount / stationReviews.length,
      reviewCount: stationReviews.length,
    );

    return StationCommunitySummary(
      stationId: stationId,
      avgRating: avgRating,
      ratingCount: stationReviews.length,
      verifiedRatingCount: verifiedCount,
      trustScore: trustScore,
      photosCount: photosCount,
      questionsCount: stationQuestions.length,
      lastReviewAt: stationReviews.isNotEmpty
          ? stationReviews.first.createdAt
          : null,
    );
  }

  double _calculateTrustScore({
    required double avgRating,
    required double verifiedRatio,
    required int reviewCount,
  }) {
    // Weights for trust score calculation
    const w1 = 0.4; // Average rating weight
    const w2 = 0.3; // Verified ratio weight
    const w3 = 0.3; // Review count weight (normalized)

    final normalizedRating = avgRating / 5.0;
    final normalizedReviewCount = reviewCount > 50 ? 1.0 : reviewCount / 50.0;

    return (w1 * normalizedRating) +
        (w2 * verifiedRatio) +
        (w3 * normalizedReviewCount);
  }

  @override
  Future<CommunityUserProfile> getUserProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return CommunityUserProfile(
      userId: userId,
      displayName: 'User $userId',
      avatarUrl: 'https://i.pravatar.cc/150?u=$userId',
      reputationScore: 156,
      verifiedChargesCount: 24,
      reviewsCount: 8,
      photosCount: 12,
      questionsCount: 3,
      answersCount: 15,
      helpfulVotesReceived: 42,
      badges: const [ReputationBadge.verified, ReputationBadge.contributor],
      joinedAt: DateTime.now().subtract(const Duration(days: 180)),
    );
  }

  @override
  Future<CommunityUserProfile> getMyProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const CommunityUserProfile(
      userId: 'current_user',
      displayName: 'Current User',
      avatarUrl: 'https://i.pravatar.cc/150?u=current',
      reputationScore: 256,
      verifiedChargesCount: 48,
      reviewsCount: 15,
      photosCount: 28,
      questionsCount: 5,
      answersCount: 32,
      helpfulVotesReceived: 86,
      badges: [
        ReputationBadge.verified,
        ReputationBadge.contributor,
        ReputationBadge.trusted,
      ],
    );
  }
}
