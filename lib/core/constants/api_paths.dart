/// File: lib/core/constants/api_paths.dart
/// Purpose: Centralized API endpoint paths for backend integration
/// Belongs To: shared
/// Customization Guide:
///    - Update baseUrl for different environments
///    - Add new endpoints as static const
///    - Use path parameters with String interpolation

/// Centralized API endpoint paths.
/// Ready for backend integration - currently using dummy data.
abstract final class ApiPaths {
  // ============ Base Configuration ============
  static const String baseUrl = 'https://api.evcharging.app/v1';
  static const String wsUrl = 'wss://api.evcharging.app/ws';
  
  // ============ Auth Endpoints ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String socialLogin = '/auth/social';
  
  // ============ User Endpoints ============
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/users/delete';
  static const String uploadAvatar = '/users/avatar';
  
  // ============ Station Endpoints ============
  static const String stations = '/stations';
  static String stationById(String id) => '/stations/$id';
  static String stationReviews(String id) => '/stations/$id/reviews';
  static String stationChargers(String id) => '/stations/$id/chargers';
  static const String nearbyStations = '/stations/nearby';
  static const String searchStations = '/stations/search';
  static const String favoriteStations = '/stations/favorites';
  static String toggleFavorite(String id) => '/stations/$id/favorite';
  
  // ============ Charger Endpoints ============
  static const String chargers = '/chargers';
  static String chargerById(String id) => '/chargers/$id';
  static String chargerStatus(String id) => '/chargers/$id/status';
  static String chargerAvailability(String id) => '/chargers/$id/availability';
  
  // ============ Booking Endpoints ============
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static const String upcomingBookings = '/bookings/upcoming';
  static const String pastBookings = '/bookings/past';
  static String startCharging(String id) => '/bookings/$id/start';
  static String stopCharging(String id) => '/bookings/$id/stop';
  
  // ============ Payment Endpoints ============
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';
  static const String paymentMethods = '/payments/methods';
  static const String addPaymentMethod = '/payments/methods';
  static String removePaymentMethod(String id) => '/payments/methods/$id';
  static const String wallet = '/payments/wallet';
  static const String addFunds = '/payments/wallet/add';
  static const String transactions = '/payments/transactions';
  
  // ============ Notification Endpoints ============
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static String markAsRead(String id) => '/notifications/$id/read';
  static const String markAllAsRead = '/notifications/read-all';
  static const String notificationSettings = '/notifications/settings';
  
  // ============ Review Endpoints ============
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  static const String myReviews = '/reviews/my';
  
  // ============ Owner Endpoints ============
  static const String ownerStations = '/owner/stations';
  static String ownerStationById(String id) => '/owner/stations/$id';
  static const String ownerEarnings = '/owner/earnings';
  static const String ownerAnalytics = '/owner/analytics';
  static const String ownerBookings = '/owner/bookings';
  
  // ============ Admin Endpoints ============
  static const String adminUsers = '/admin/users';
  static String adminUserById(String id) => '/admin/users/$id';
  static const String adminOwners = '/admin/owners';
  static String adminOwnerById(String id) => '/admin/owners/$id';
  static const String adminStations = '/admin/stations';
  static String adminStationById(String id) => '/admin/stations/$id';
  static const String adminReports = '/admin/reports';
  static const String adminDashboard = '/admin/dashboard';
  static String approveStation(String id) => '/admin/stations/$id/approve';
  static String rejectStation(String id) => '/admin/stations/$id/reject';
  
  // ============ Misc Endpoints ============
  static const String appConfig = '/config';
  static const String faq = '/faq';
  static const String contactSupport = '/support/contact';
  static const String reportIssue = '/support/report';
}

