/// File: lib/features/value_packs/presentation/cubits/value_pack_detail_state.dart
/// Purpose: State for value pack detail screen
/// Belongs To: value_packs feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

/// State for value pack detail screen.
class ValuePackDetailState extends Equatable {
  const ValuePackDetailState({
    this.status = ValuePackDetailStatus.initial,
    this.pack,
    this.relatedPacks = const [],
    this.isSaved = false,
    this.reviewSummary,
    this.error,
  });

  /// Initial state.
  factory ValuePackDetailState.initial() => const ValuePackDetailState();

  final ValuePackDetailStatus status;
  final ValuePack? pack;
  final List<ValuePack> relatedPacks;
  final bool isSaved;
  final ReviewSummary? reviewSummary;
  final String? error;

  /// Check if loading.
  bool get isLoading => status == ValuePackDetailStatus.loading;

  /// Check if loaded.
  bool get isLoaded => status == ValuePackDetailStatus.loaded;

  /// Check if has error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Copy with new values.
  ValuePackDetailState copyWith({
    ValuePackDetailStatus? status,
    ValuePack? pack,
    List<ValuePack>? relatedPacks,
    bool? isSaved,
    ReviewSummary? reviewSummary,
    String? error,
  }) {
    return ValuePackDetailState(
      status: status ?? this.status,
      pack: pack ?? this.pack,
      relatedPacks: relatedPacks ?? this.relatedPacks,
      isSaved: isSaved ?? this.isSaved,
      reviewSummary: reviewSummary ?? this.reviewSummary,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pack,
        relatedPacks,
        isSaved,
        reviewSummary,
        error,
      ];
}

/// Status enum for value pack detail.
enum ValuePackDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Review summary data.
class ReviewSummary extends Equatable {
  const ReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    this.ratingDistribution = const {},
  });

  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingDistribution];
}

