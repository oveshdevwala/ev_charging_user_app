/// File: lib/features/value_packs/domain/usecases/get_reviews.dart
/// Purpose: Use case for fetching reviews
/// Belongs To: value_packs feature
library;

import '../entities/review.dart';
import '../repositories/value_packs_repository.dart';

/// Use case for getting reviews.
class GetReviews {
  GetReviews(this._repository);

  final ValuePacksRepository _repository;

  /// Execute the use case.
  Future<List<Review>> call(String packId, {int page = 1, int limit = 20}) async {
    return _repository.getReviews(packId, page: page, limit: limit);
  }
}

