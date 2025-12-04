/// File: lib/features/onboarding/models/onboarding_item.dart
/// Purpose: Onboarding item data model
/// Belongs To: onboarding feature
library;

import 'package:flutter/widgets.dart';

/// Model for onboarding page content.
class OnboardingItem {
  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
