/// File: lib/core/constants/app_assets.dart
/// Purpose: Centralized asset path constants for images, icons, and animations
/// Belongs To: shared
/// Customization Guide:
///    - Add new asset paths as static const
///    - Organize by asset type (images, icons, lottie)
///    - Ensure paths match actual asset folder structure
library;

/// Centralized asset paths for the EV Charging app.
/// All asset references should use these constants.
abstract final class AppAssets {
  // ============ Base Paths ============
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _lottiePath = 'assets/lottie';

  // ============ App Logo & Branding ============
  static const String appLogo = '$_imagesPath/app_logo.png';
  static const String appLogoWhite = '$_imagesPath/app_logo_white.png';
  static const String appLogoColored = '$_imagesPath/app_logo_colored.png';
  static const String splashBg = '$_imagesPath/splash_bg.png';
  static const String splashLogo = '$_imagesPath/splash_logo.png';

  // ============ Onboarding ============
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  // ============ Auth ============
  static const String authBg = '$_imagesPath/auth_bg.png';
  static const String googleIcon = '$_iconsPath/google.svg';
  static const String appleIcon = '$_iconsPath/apple.svg';
  static const String facebookIcon = '$_iconsPath/facebook.svg';

  // ============ Placeholder ============
  static const String userPlaceholder = '$_imagesPath/user_placeholder.png';
  static const String stationPlaceholder =
      '$_imagesPath/station_placeholder.png';
  static const String imagePlaceholder = '$_imagesPath/image_placeholder.png';

  // ============ Empty States ============
  static const String emptyBookings = '$_imagesPath/empty_bookings.png';
  static const String emptyFavorites = '$_imagesPath/empty_favorites.png';
  static const String emptyNotifications =
      '$_imagesPath/empty_notifications.png';
  static const String emptySearch = '$_imagesPath/empty_search.png';
  static const String noInternet = '$_imagesPath/no_internet.png';
  static const String errorImage = '$_imagesPath/error.png';

  // ============ Icons - Navigation ============
  static const String icHome = '$_iconsPath/ic_home.svg';
  static const String icHomeActive = '$_iconsPath/ic_home_active.svg';
  static const String icSearch = '$_iconsPath/ic_search.svg';
  static const String icBookings = '$_iconsPath/ic_bookings.svg';
  static const String icBookingsActive = '$_iconsPath/ic_bookings_active.svg';
  static const String icFavorites = '$_iconsPath/ic_favorites.svg';
  static const String icFavoritesActive = '$_iconsPath/ic_favorites_active.svg';
  static const String icProfile = '$_iconsPath/ic_profile.svg';
  static const String icProfileActive = '$_iconsPath/ic_profile_active.svg';

  // ============ Icons - Charger Types ============
  static const String icType1 = '$_iconsPath/charger_type1.svg';
  static const String icType2 = '$_iconsPath/charger_type2.svg';
  static const String icCcs = '$_iconsPath/charger_ccs.svg';
  static const String icChademo = '$_iconsPath/charger_chademo.svg';
  static const String icTesla = '$_iconsPath/charger_tesla.svg';

  // ============ Icons - Amenities ============
  static const String icWifi = '$_iconsPath/ic_wifi.svg';
  static const String icRestroom = '$_iconsPath/ic_restroom.svg';
  static const String icCafe = '$_iconsPath/ic_cafe.svg';
  static const String icParking = '$_iconsPath/ic_parking.svg';
  static const String icShopping = '$_iconsPath/ic_shopping.svg';
  static const String icRestaurant = '$_iconsPath/ic_restaurant.svg';

  // ============ Icons - General ============
  static const String icLocation = '$_iconsPath/ic_location.svg';
  static const String icDirection = '$_iconsPath/ic_direction.svg';
  static const String icStar = '$_iconsPath/ic_star.svg';
  static const String icClock = '$_iconsPath/ic_clock.svg';
  static const String icCharger = '$_iconsPath/ic_charger.svg';
  static const String icBattery = '$_iconsPath/ic_battery.svg';
  static const String icPayment = '$_iconsPath/ic_payment.svg';
  static const String icWallet = '$_iconsPath/ic_wallet.svg';
  static const String icNotification = '$_iconsPath/ic_notification.svg';
  static const String icSettings = '$_iconsPath/ic_settings.svg';
  static const String icHelp = '$_iconsPath/ic_help.svg';
  static const String icLogout = '$_iconsPath/ic_logout.svg';
  static const String icEdit = '$_iconsPath/ic_edit.svg';
  static const String icDelete = '$_iconsPath/ic_delete.svg';
  static const String icFilter = '$_iconsPath/ic_filter.svg';
  static const String icSort = '$_iconsPath/ic_sort.svg';

  // ============ Lottie Animations ============
  static const String lottieLoading = '$_lottiePath/loading.json';
  static const String lottieSuccess = '$_lottiePath/success.json';
  static const String lottieError = '$_lottiePath/error.json';
  static const String lottieEmpty = '$_lottiePath/empty.json';
  static const String lottieCharging = '$_lottiePath/charging.json';
  static const String lottieNoInternet = '$_lottiePath/no_internet.json';

  // ============ Maps ============
  static const String mapMarkerStation = '$_iconsPath/map_marker_station.png';
  static const String mapMarkerUser = '$_iconsPath/map_marker_user.png';
  static const String mapStyle = '$_imagesPath/map_style.json';
}
