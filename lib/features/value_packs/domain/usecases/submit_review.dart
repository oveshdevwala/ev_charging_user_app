/// File: lib/features/value_packs/domain/usecases/submit_review.dart
/// Purpose: Use case for submitting a review
/// Belongs To: value_packs feature
library;

import '../entities/review.dart';
import '../repositories/value_packs_repository.dart';

/// Use case for submitting a review.
class SubmitReview {
  SubmitReview(this._repository);

  final ValuePacksRepository _repository;

  /// Execute the use case.
  Future<Review> call({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  }) async {
    return _repository.submitReview(
      packId: packId,
      rating: rating,
      title: title,
      message: message,
      images: images,
    );
  }
}

