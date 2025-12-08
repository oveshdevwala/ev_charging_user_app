/// File: lib/admin/core/widgets/no_transition_page.dart
/// Purpose: Custom page that prevents navigation transitions for stacked tab navigation
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Used to prevent screen transitions when switching tabs in IndexedStack
library;

import 'package:flutter/material.dart';

/// A custom page that prevents transitions when navigating.
/// Used for tab-based navigation where IndexedStack handles the switching.
class AdminNoTransitionPage<T> extends Page<T> {
  const AdminNoTransitionPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  }
}

