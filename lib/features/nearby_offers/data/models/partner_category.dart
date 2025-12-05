/// File: lib/features/nearby_offers/data/models/partner_category.dart
/// Purpose: Partner category enum and model for categorization
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Add new categories to PartnerCategory enum
///    - Update iconData and colorValue mappings accordingly
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Partner business category types.
enum PartnerCategory {
  food,
  shopping,
  movies,
  services,
  entertainment,
  wellness,
  all,
}

/// Extension for PartnerCategory with UI properties.
extension PartnerCategoryExt on PartnerCategory {
  /// Get display name key for localization.
  String get displayKey {
    switch (this) {
      case PartnerCategory.food:
        return 'partner_category_food';
      case PartnerCategory.shopping:
        return 'partner_category_shopping';
      case PartnerCategory.movies:
        return 'partner_category_movies';
      case PartnerCategory.services:
        return 'partner_category_services';
      case PartnerCategory.entertainment:
        return 'partner_category_entertainment';
      case PartnerCategory.wellness:
        return 'partner_category_wellness';
      case PartnerCategory.all:
        return 'partner_category_all';
    }
  }

  /// Get icon for the category.
  IconData get iconData {
    switch (this) {
      case PartnerCategory.food:
        return Icons.restaurant_rounded;
      case PartnerCategory.shopping:
        return Icons.shopping_bag_rounded;
      case PartnerCategory.movies:
        return Icons.movie_rounded;
      case PartnerCategory.services:
        return Icons.build_rounded;
      case PartnerCategory.entertainment:
        return Icons.celebration_rounded;
      case PartnerCategory.wellness:
        return Icons.spa_rounded;
      case PartnerCategory.all:
        return Icons.grid_view_rounded;
    }
  }

  /// Get color for the category.
  Color get color {
    switch (this) {
      case PartnerCategory.food:
        return const Color(0xFFFF6B6B);
      case PartnerCategory.shopping:
        return const Color(0xFF4ECDC4);
      case PartnerCategory.movies:
        return const Color(0xFF9B59B6);
      case PartnerCategory.services:
        return const Color(0xFF3498DB);
      case PartnerCategory.entertainment:
        return const Color(0xFFF39C12);
      case PartnerCategory.wellness:
        return const Color(0xFF2ECC71);
      case PartnerCategory.all:
        return const Color(0xFF95A5A6);
    }
  }
}

/// Category filter model with selection state.
class CategoryFilter extends Equatable {
  const CategoryFilter({
    required this.category,
    this.isSelected = false,
    this.offerCount = 0,
  });

  final PartnerCategory category;
  final bool isSelected;
  final int offerCount;

  CategoryFilter copyWith({
    PartnerCategory? category,
    bool? isSelected,
    int? offerCount,
  }) {
    return CategoryFilter(
      category: category ?? this.category,
      isSelected: isSelected ?? this.isSelected,
      offerCount: offerCount ?? this.offerCount,
    );
  }

  @override
  List<Object?> get props => [category, isSelected, offerCount];
}
