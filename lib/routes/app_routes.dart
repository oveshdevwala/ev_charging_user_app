/// File: lib/routes/app_routes.dart
/// Purpose: Application routing configuration using go_router
/// Belongs To: routes
/// Customization Guide:
///    - Add new routes by extending AppRoutes enum
///    - Configure route parameters and transitions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/splash.dart';
import '../features/onboarding/onboarding.dart';
import '../features/auth/auth.dart';
import '../features/home/home.dart';
import '../features/search/search.dart';
import '../features/favorites/favorites.dart';
import '../features/bookings/bookings.dart';
import '../features/profile/profile.dart';
import '../features/stations/stations.dart';
import '../features/notifications/notifications.dart';
import '../features/main_shell/main_shell.dart';

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

      // -------- User App Shell --------
      ShellRoute(
        builder: (context, state, child) => MainShellPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.userHome.path,
            name: AppRoutes.userHome.name,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.userSearch.path,
            name: AppRoutes.userSearch.name,
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.userFavorites.path,
            name: AppRoutes.userFavorites.name,
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: AppRoutes.userBookings.path,
            name: AppRoutes.userBookings.name,
            builder: (context, state) => const BookingsPage(),
          ),
          GoRoute(
            path: AppRoutes.userProfile.path,
            name: AppRoutes.userProfile.name,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
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
