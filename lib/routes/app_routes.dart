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
import '../features/nearby_offers/presentation/screens/screens.dart';
import '../features/notifications/notifications.dart';
import '../features/value_packs/presentation/screens/screens.dart';
import '../features/onboarding/onboarding.dart';
import '../features/profile/profile.dart';
import '../features/splash/splash.dart';
import '../features/stations/stations.dart';
import '../features/trip_history/trip_history.dart';
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
      chargingStops,
      tripInsights,
      wallet,
  walletRecharge,
  stationCommunity,
  leaveReview,
  adminModeration,
  allSessions,
  allTransactions,
  sessionDetail,
  transactionDetail,
  tripHistory,

  // -------- Profile Routes --------
  changePassword,
  paymentMethods,
  addCard,
  themeSettings,
  languageSettings,
  helpSupport,
  contactUs,
  privacyPolicy,
  termsOfService,
  deleteAccount,

  // -------- Nearby Offers Routes --------
  nearbyOffers,
  partnerMarketplace,
  partnerDetail,
  offerRedeem,
  checkInSuccess,

  // -------- Value Packs Routes --------
  valuePacksList,
  valuePackDetail,
  comparePacks,
  purchasePack,
  packReviews,
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
      case AppRoutes.chargingStops:
        return '/chargingStops';
      case AppRoutes.tripInsights:
        return '/tripInsights';
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
      case AppRoutes.allSessions:
        return '/allSessions';
      case AppRoutes.allTransactions:
        return '/allTransactions';
      case AppRoutes.sessionDetail:
        return '/sessionDetail';
      case AppRoutes.transactionDetail:
        return '/transactionDetail';
      case AppRoutes.tripHistory:
        return '/tripHistory';

      // Profile Routes
      case AppRoutes.changePassword:
        return '/changePassword';
      case AppRoutes.paymentMethods:
        return '/paymentMethods';
      case AppRoutes.addCard:
        return '/addCard';
      case AppRoutes.themeSettings:
        return '/themeSettings';
      case AppRoutes.languageSettings:
        return '/languageSettings';
      case AppRoutes.helpSupport:
        return '/helpSupport';
      case AppRoutes.contactUs:
        return '/contactUs';
      case AppRoutes.privacyPolicy:
        return '/privacyPolicy';
      case AppRoutes.termsOfService:
        return '/termsOfService';
      case AppRoutes.deleteAccount:
        return '/deleteAccount';

      // Nearby Offers
      case AppRoutes.nearbyOffers:
        return '/nearbyOffers';
      case AppRoutes.partnerMarketplace:
        return '/partnerMarketplace';
      case AppRoutes.partnerDetail:
        return '/partnerDetail';
      case AppRoutes.offerRedeem:
        return '/offerRedeem';
      case AppRoutes.checkInSuccess:
        return '/checkInSuccess';

      // Value Packs
      case AppRoutes.valuePacksList:
        return '/valuePacks';
      case AppRoutes.valuePackDetail:
        return '/valuePackDetail';
      case AppRoutes.comparePacks:
        return '/comparePacks';
      case AppRoutes.purchasePack:
        return '/purchasePack';
      case AppRoutes.packReviews:
        return '/packReviews';
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
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainShellPage()),
      ),
      GoRoute(
        path: AppRoutes.userSearch.path,
        name: AppRoutes.userSearch.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainShellPage(initialIndex: 1)),
      ),
      GoRoute(
        path: AppRoutes.userFavorites.path,
        name: AppRoutes.userFavorites.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainShellPage(initialIndex: 2)),
      ),
      GoRoute(
        path: AppRoutes.userBookings.path,
        name: AppRoutes.userBookings.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainShellPage(initialIndex: 3)),
      ),
      GoRoute(
        path: AppRoutes.userProfile.path,
        name: AppRoutes.userProfile.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainShellPage(initialIndex: 4)),
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

      // -------- Profile Routes --------
      GoRoute(
        path: AppRoutes.changePassword.path,
        name: AppRoutes.changePassword.name,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods.path,
        name: AppRoutes.paymentMethods.name,
        builder: (context, state) => const PaymentMethodsPage(),
      ),
      GoRoute(
        path: AppRoutes.addCard.path,
        name: AppRoutes.addCard.name,
        builder: (context, state) => const AddCardPage(),
      ),
      GoRoute(
        path: AppRoutes.themeSettings.path,
        name: AppRoutes.themeSettings.name,
        builder: (context, state) => const ThemeSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.languageSettings.path,
        name: AppRoutes.languageSettings.name,
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport.path,
        name: AppRoutes.helpSupport.name,
        builder: (context, state) => const HelpSupportPage(),
      ),
      GoRoute(
        path: AppRoutes.contactUs.path,
        name: AppRoutes.contactUs.name,
        builder: (context, state) => const ContactUsPage(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy.path,
        name: AppRoutes.privacyPolicy.name,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutes.termsOfService.path,
        name: AppRoutes.termsOfService.name,
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount.path,
        name: AppRoutes.deleteAccount.name,
        builder: (context, state) => const DeleteAccountPage(),
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

      // -------- Charging Stops (Standalone) --------
      GoRoute(
        path: '${AppRoutes.chargingStops.path}/:tripId',
        name: AppRoutes.chargingStops.name,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId'] ?? '';
          return StandaloneChargingStopsPage(tripId: tripId);
        },
      ),

      // -------- Trip Insights (Standalone) --------
      GoRoute(
        path: '${AppRoutes.tripInsights.path}/:tripId',
        name: AppRoutes.tripInsights.name,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId'] ?? '';
          return StandaloneInsightsPage(tripId: tripId);
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

      // -------- Activity Sub-pages --------
      GoRoute(
        path: AppRoutes.allSessions.path,
        name: AppRoutes.allSessions.name,
        builder: (context, state) => const AllSessionsPage(),
      ),
      GoRoute(
        path: AppRoutes.allTransactions.path,
        name: AppRoutes.allTransactions.name,
        builder: (context, state) => const AllTransactionsPage(),
      ),
      GoRoute(
        path: '${AppRoutes.sessionDetail.path}/:id',
        name: AppRoutes.sessionDetail.name,
        builder: (context, state) {
          final sessionId = state.pathParameters['id'] ?? '';
          return SessionDetailPage(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.transactionDetail.path}/:id',
        name: AppRoutes.transactionDetail.name,
        builder: (context, state) {
          final transactionId = state.pathParameters['id'] ?? '';
          return TransactionDetailPage(transactionId: transactionId);
        },
      ),

      // -------- Trip History --------
      GoRoute(
        path: AppRoutes.tripHistory.path,
        name: AppRoutes.tripHistory.name,
        builder: (context, state) => const TripHistoryScreen(),
      ),

      // -------- Nearby Offers --------
      GoRoute(
        path: AppRoutes.nearbyOffers.path,
        name: AppRoutes.nearbyOffers.name,
        builder: (context, state) => const NearbyOffersScreen(),
      ),
      GoRoute(
        path: AppRoutes.partnerMarketplace.path,
        name: AppRoutes.partnerMarketplace.name,
        builder: (context, state) => const PartnerMarketplaceScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.partnerDetail.path}/:id',
        name: AppRoutes.partnerDetail.name,
        builder: (context, state) {
          final partnerId = state.pathParameters['id'] ?? '';
          return PartnerDetailScreen(partnerId: partnerId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.offerRedeem.path}/:id',
        name: AppRoutes.offerRedeem.name,
        builder: (context, state) {
          final offerId = state.pathParameters['id'] ?? '';
          return OfferRedeemScreen(offerId: offerId);
        },
      ),

      // -------- Value Packs --------
      GoRoute(
        path: AppRoutes.valuePacksList.path,
        name: AppRoutes.valuePacksList.name,
        builder: (context, state) => const ValuePacksListScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.valuePackDetail.path}/:id',
        name: AppRoutes.valuePackDetail.name,
        builder: (context, state) {
          final packId = state.pathParameters['id'] ?? '';
          return ValuePackDetailScreen(packId: packId);
        },
      ),
      GoRoute(
        path: AppRoutes.comparePacks.path,
        name: AppRoutes.comparePacks.name,
        builder: (context, state) {
          final packIds = state.uri.queryParameters['ids']?.split(',') ?? [];
          return ComparePacksScreen(packIds: packIds);
        },
      ),
      GoRoute(
        path: '${AppRoutes.purchasePack.path}/:id',
        name: AppRoutes.purchasePack.name,
        builder: (context, state) {
          final packId = state.pathParameters['id'] ?? '';
          return PurchaseScreen(packId: packId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.packReviews.path}/:id',
        name: AppRoutes.packReviews.name,
        builder: (context, state) {
          final packId = state.pathParameters['id'] ?? '';
          return ReviewsScreen(packId: packId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
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
