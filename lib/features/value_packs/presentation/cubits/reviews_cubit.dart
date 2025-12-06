/// File: lib/features/value_packs/presentation/cubits/reviews_cubit.dart
/// Purpose: Cubit for managing reviews
/// Belongs To: value_packs feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_reviews.dart';
import '../../domain/usecases/submit_review.dart';
import 'reviews_state.dart';

/// Cubit for reviews screen.
class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(
    this._getReviews,
    this._submitReview,
  ) : super(ReviewsState.initial());

  final GetReviews _getReviews;
  final SubmitReview _submitReview;

  /// Load reviews.
  Future<void> loadReviews(String packId, {int page = 1}) async {
    try {
      final reviews = await _getReviews(packId, page: page, limit: 20);
      emit(state.copyWith(reviews: reviews, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Submit review.
  Future<void> submitReview({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  }) async {
    emit(state.copyWith(submitting: true, error: null));

    try {
      final review = await _submitReview(
        packId: packId,
        rating: rating,
        title: title,
        message: message,
        images: images,
      );

      emit(state.copyWith(
        reviews: [review, ...state.reviews],
        submitting: false,
        submitted: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        submitting: false,
        error: e.toString(),
      ));
    }
  }

  /// Upload image.
  Future<String?> uploadImage(String filePath) async {
    // TODO: Implement image upload
    return null;
  }
}

