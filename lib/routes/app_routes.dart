/// File: lib/routes/app_routes.dart
/// Purpose: Application routing configuration using go_router
/// Belongs To: routes
/// Customization Guide:
///    - Add new routes by extending AppRoutes enum
///    - Configure route parameters and transitions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/activity/activity.dart';
import '../features/auth/auth.dart';
import '../features/bookings/bookings.dart';
import '../features/community/community.dart';
import '../features/main_shell/main_shell.dart';
import '../features/notifications/notifications.dart';
import '../features/onboarding/onboarding.dart';
import '../features/profile/profile.dart';
import '../features/splash/splash.dart';
import '../features/stations/stations.dart';
import '../features/trip_planner/trip_planner.dart';
import '../features/wallet/wallet.dart';

// ============================================================
// APP ROUTES ENUM
// ============================================================

/// Enum containing all application routes.
/// Use extensions to get path strings and navigation methods.
enum AppRoutes {
  // -------- Common Routes --------
  splash,
  onboarding,
  login,
  register,
  forgotPassword,

  // -------- User App Routes --------
  userHome,
  userSearch,
  userFavorites,
  userBookings,
  userProfile,
  stationDetails,
  booking,
  bookingDetails,
  userNotifications,
  userSettings,
  editProfile,
  activityDetails,
  tripPlanner,
  tripSummary,
  wallet,
  walletRecharge,
  stationCommunity,
  leaveReview,
  adminModeration,
}

// ============================================================
// ROUTE PATH EXTENSION
// ============================================================

/// Extension to get route paths and generate dynamic paths.
extension AppRoutePath on AppRoutes {
  /// Get the path string for this route.
  String get path {
    switch (this) {
      // Common
      case AppRoutes.splash:
        return '/';
      case AppRoutes.onboarding:
        return '/onboarding';
      case AppRoutes.login:
        return '/login';
      case AppRoutes.register:
        return '/register';
      case AppRoutes.forgotPassword:
        return '/forgotPassword';

      // User App
      case AppRoutes.userHome:
        return '/userHome';
      case AppRoutes.userSearch:
        return '/userSearch';
      case AppRoutes.userFavorites:
        return '/userFavorites';
      case AppRoutes.userBookings:
        return '/userBookings';
      case AppRoutes.userProfile:
        return '/userProfile';
      case AppRoutes.stationDetails:
        return '/stationDetails';
      case AppRoutes.booking:
        return '/booking';
      case AppRoutes.bookingDetails:
        return '/bookingDetails';
      case AppRoutes.userNotifications:
        return '/userNotifications';
      case AppRoutes.userSettings:
        return '/userSettings';
      case AppRoutes.editProfile:
        return '/editProfile';
      case AppRoutes.activityDetails:
        return '/activityDetails';
      case AppRoutes.tripPlanner:
        return '/tripPlanner';
      case AppRoutes.tripSummary:
        return '/tripSummary';
      case AppRoutes.wallet:
        return '/wallet';
      case AppRoutes.walletRecharge:
        return '/walletRecharge';
      case AppRoutes.stationCommunity:
        return '/stationCommunity';
      case AppRoutes.leaveReview:
        return '/leaveReview';
      case AppRoutes.adminModeration:
        return '/adminModeration';
    }
  }

  /// Generate path with dynamic ID parameter.
  String id(String value) => '$path/$value';
}

// ============================================================
// GO ROUTER CONFIGURATION
// ============================================================

/// Application router configuration.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.userHome.path,
    debugLogDiagnostics: true,
    routes: [
      // -------- Splash --------
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashPage(),
      ),

      // -------- Onboarding --------
      GoRoute(
        path: AppRoutes.onboarding.path,
        name: AppRoutes.onboarding.name,
        builder: (context, state) => const OnboardingPage(),
      ),

      // -------- Auth Routes --------
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword.path,
        name: AppRoutes.forgotPassword.name,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // -------- User App Shell (Main Tabs) --------
      // Single route for the main shell - tab navigation handled internally via IndexedStack
      GoRoute(
        path: AppRoutes.userHome.path,
        name: AppRoutes.userHome.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainShellPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.userSearch.path,
        name: AppRoutes.userSearch.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainShellPage(initialIndex: 1),
        ),
      ),
      GoRoute(
        path: AppRoutes.userFavorites.path,
        name: AppRoutes.userFavorites.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainShellPage(initialIndex: 2),
        ),
      ),
      GoRoute(
        path: AppRoutes.userBookings.path,
        name: AppRoutes.userBookings.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainShellPage(initialIndex: 3),
        ),
      ),
      GoRoute(
        path: AppRoutes.userProfile.path,
        name: AppRoutes.userProfile.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainShellPage(initialIndex: 4),
        ),
      ),

      // -------- Station Details --------
      GoRoute(
        path: '${AppRoutes.stationDetails.path}/:id',
        name: AppRoutes.stationDetails.name,
        builder: (context, state) {
          final stationId = state.pathParameters['id'] ?? '';
          return StationDetailsPage(stationId: stationId);
        },
      ),

      // -------- Booking --------
      GoRoute(
        path: '${AppRoutes.booking.path}/:stationId',
        name: AppRoutes.booking.name,
        builder: (context, state) {
          final stationId = state.pathParameters['stationId'] ?? '';
          return BookingPage(stationId: stationId);
        },
      ),

      // -------- Booking Details --------
      GoRoute(
        path: '${AppRoutes.bookingDetails.path}/:id',
        name: AppRoutes.bookingDetails.name,
        builder: (context, state) {
          final bookingId = state.pathParameters['id'] ?? '';
          return BookingDetailsPage(bookingId: bookingId);
        },
      ),

      // -------- Notifications --------
      GoRoute(
        path: AppRoutes.userNotifications.path,
        name: AppRoutes.userNotifications.name,
        builder: (context, state) => const NotificationsPage(),
      ),

      // -------- Settings --------
      GoRoute(
        path: AppRoutes.userSettings.path,
        name: AppRoutes.userSettings.name,
        builder: (context, state) => const SettingsPage(),
      ),

      // -------- Edit Profile --------
      GoRoute(
        path: AppRoutes.editProfile.path,
        name: AppRoutes.editProfile.name,
        builder: (context, state) => const EditProfilePage(),
      ),

      // -------- Activity Details --------
      GoRoute(
        path: AppRoutes.activityDetails.path,
        name: AppRoutes.activityDetails.name,
        builder: (context, state) => const ActivityDetailsPage(),
      ),

      // -------- Trip Planner --------
      GoRoute(
        path: AppRoutes.tripPlanner.path,
        name: AppRoutes.tripPlanner.name,
        builder: (context, state) => const TripPlannerPage(),
      ),

      // -------- Trip Summary (Standalone) --------
      GoRoute(
        path: '${AppRoutes.tripSummary.path}/:tripId',
        name: AppRoutes.tripSummary.name,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId'] ?? '';
          return StandaloneTripSummaryPage(tripId: tripId);
        },
      ),

      // -------- Wallet --------
      GoRoute(
        path: AppRoutes.wallet.path,
        name: AppRoutes.wallet.name,
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        path: AppRoutes.walletRecharge.path,
        name: AppRoutes.walletRecharge.name,
        builder: (context, state) => const RechargePage(),
      ),

      // -------- Community --------
      GoRoute(
        path: '${AppRoutes.stationCommunity.path}/:stationId',
        name: AppRoutes.stationCommunity.name,
        builder: (context, state) {
          final stationId = state.pathParameters['stationId'] ?? '';
          final stationName = state.uri.queryParameters['name'] ?? 'Station';
          return StationCommunityPage(
            stationId: stationId,
            stationName: stationName,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.leaveReview.path}/:stationId',
        name: AppRoutes.leaveReview.name,
        builder: (context, state) {
          final stationId = state.pathParameters['stationId'] ?? '';
          final stationName = state.uri.queryParameters['name'] ?? 'Station';
          return LeaveReviewPage(
            stationId: stationId,
            stationName: stationName,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminModeration.path,
        name: AppRoutes.adminModeration.name,
        builder: (context, state) => const ModerationConsolePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.path),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash.path),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
