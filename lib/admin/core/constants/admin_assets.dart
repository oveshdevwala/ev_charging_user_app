/// File: lib/admin/core/constants/admin_assets.dart
/// Purpose: All admin panel asset paths
/// Belongs To: admin/core/constants
/// Customization Guide:
///    - Add all asset paths here
///    - Use these via AdminAssets.xxx
library;

abstract final class AdminAssets {
  // ============ Base Paths ============
  static const String _basePath = 'assets';
  static const String _iconsPath = '$_basePath/icons';
  static const String _imagesPath = '$_basePath/images';
  static const String _dummyDataPath = '$_basePath/dummy_data/admin';

  // ============ Icons ============
  static const String iconDashboard = '$_iconsPath/dashboard.svg';
  static const String iconStations = '$_iconsPath/stations.svg';
  static const String iconUsers = '$_iconsPath/users.svg';
  static const String iconSettings = '$_iconsPath/settings.svg';
  static const String iconNotification = '$_iconsPath/notification.svg';

  // ============ Images ============
  static const String imgLogo = '$_imagesPath/logo.png';
  static const String imgAvatar = '$_imagesPath/avatar.png';
  static const String imgEmptyState = '$_imagesPath/empty_state.png';

  // ============ Dummy Data JSON ============
  static const String jsonStations = '$_dummyDataPath/stations.json';
  static const String jsonUsers = '$_dummyDataPath/users.json';
  static const String jsonSessions = '$_dummyDataPath/sessions.json';
  static const String jsonPayments = '$_dummyDataPath/payments.json';
  static const String jsonTransactions = '$_dummyDataPath/transactions.json';
  static const String jsonOffers = '$_dummyDataPath/offers.json';
  static const String jsonReviews = '$_dummyDataPath/reviews.json';
  static const String jsonLogs = '$_dummyDataPath/logs.json';
  static const String jsonManagers = '$_dummyDataPath/managers.json';
  static const String jsonPartners = '$_dummyDataPath/partners.json';
  static const String jsonWallets = '$_dummyDataPath/wallets.json';

  // ============ Pexels Placeholder Images ============
  static const String placeholderStation =
      'https://images.pexels.com/photos/9799995/pexels-photo-9799995.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderStation2 =
      'https://images.pexels.com/photos/9800009/pexels-photo-9800009.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderStation3 =
      'https://images.pexels.com/photos/9799970/pexels-photo-9799970.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderUser =
      'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderUser2 =
      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderUser3 =
      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderManager =
      'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderOffer =
      'https://images.pexels.com/photos/1435752/pexels-photo-1435752.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const String placeholderPartner =
      'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=800';
}
