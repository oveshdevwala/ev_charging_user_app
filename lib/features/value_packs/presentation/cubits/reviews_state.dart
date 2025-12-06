/// File: lib/features/value_packs/presentation/cubits/reviews_state.dart
/// Purpose: State for reviews screen
/// Belongs To: value_packs feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/review.dart';

/// State for reviews screen.
class ReviewsState extends Equatable {
  const ReviewsState({
    this.reviews = const [],
    this.submitting = false,
    this.submitted = false,
    this.error,
  });

  /// Initial state.
  factory ReviewsState.initial() => const ReviewsState();

  final List<Review> reviews;
  final bool submitting;
  final bool submitted;
  final String? error;

  /// Check if has error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Copy with new values.
  ReviewsState copyWith({
    List<Review>? reviews,
    bool? submitting,
    bool? submitted,
    String? error,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
      error: error,
    );
  }

  @override
  List<Object?> get props => [reviews, submitting, submitted, error];
}

