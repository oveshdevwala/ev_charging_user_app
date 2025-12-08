/// File: lib/admin/core/constants/admin_api_paths.dart
/// Purpose: All admin panel API endpoint paths (for future backend integration)
/// Belongs To: admin/core/constants
/// Customization Guide:
///    - Add all API endpoints here
///    - Use these via AdminApiPaths.xxx
library;

abstract final class AdminApiPaths {
  // ============ Base URL ============
  static const String baseUrl = 'https://api.evcharging.com/admin/v1';

  // ============ Auth ============
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  // ============ Dashboard ============
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardActivity = '/dashboard/activity';
  static const String dashboardCharts = '/dashboard/charts';

  // ============ Stations ============
  static const String stations = '/stations';
  static String stationById(String id) => '/stations/$id';
  static String stationChargers(String id) => '/stations/$id/chargers';
  static String stationSessions(String id) => '/stations/$id/sessions';
  static String stationReviews(String id) => '/stations/$id/reviews';
  static String stationAssignManager(String id) => '/stations/$id/assign-manager';

  // ============ Managers ============
  static const String managers = '/managers';
  static String managerById(String id) => '/managers/$id';
  static String managerStations(String id) => '/managers/$id/stations';

  // ============ Users ============
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String userSessions(String id) => '/users/$id/sessions';
  static String userWallet(String id) => '/users/$id/wallet';
  static String userVehicles(String id) => '/users/$id/vehicles';

  // ============ Sessions ============
  static const String sessions = '/sessions';
  static String sessionById(String id) => '/sessions/$id';

  // ============ Payments ============
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';
  static const String paymentRefund = '/payments/refund';

  // ============ Wallets ============
  static const String wallets = '/wallets';
  static String walletById(String id) => '/wallets/$id';
  static String walletTransactions(String id) => '/wallets/$id/transactions';
  static const String walletAdjust = '/wallets/adjust';

  // ============ Offers ============
  static const String offers = '/offers';
  static String offerById(String id) => '/offers/$id';

  // ============ Partners ============
  static const String partners = '/partners';
  static String partnerById(String id) => '/partners/$id';

  // ============ Reviews ============
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  static String reviewModerate(String id) => '/reviews/$id/moderate';

  // ============ Reports ============
  static const String reportsRevenue = '/reports/revenue';
  static const String reportsUsage = '/reports/usage';
  static const String reportsStations = '/reports/stations';
  static const String reportsUsers = '/reports/users';
  static const String reportsExport = '/reports/export';

  // ============ Content ============
  static const String contentPages = '/content/pages';
  static const String contentFaq = '/content/faq';
  static const String contentBanners = '/content/banners';

  // ============ Logs ============
  static const String logs = '/logs';
  static const String logsActivity = '/logs/activity';
  static const String logsError = '/logs/error';
  static const String logsAudit = '/logs/audit';

  // ============ Settings ============
  static const String settings = '/settings';
  static const String settingsGeneral = '/settings/general';
  static const String settingsPayment = '/settings/payment';
  static const String settingsNotification = '/settings/notification';
  static const String settingsSecurity = '/settings/security';

  // ============ RBAC ============
  static const String roles = '/rbac/roles';
  static const String permissions = '/rbac/permissions';
  static String roleById(String id) => '/rbac/roles/$id';

  // ============ Media ============
  static const String mediaUpload = '/media/upload';
  static const String mediaList = '/media/list';
  static String mediaById(String id) => '/media/$id';

  // ============ Notifications ============
  static const String notifications = '/notifications';
  static const String notificationsSend = '/notifications/send';
  static String notificationById(String id) => '/notifications/$id';
}

