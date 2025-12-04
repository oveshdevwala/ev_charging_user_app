/// File: lib/core/constants/app_strings.dart
/// Purpose: Centralized string constants for the entire application
/// Belongs To: shared
/// Customization Guide:
///    - Add new strings as static const
///    - Group strings by feature/screen
///    - Always add corresponding ARB entries for localization

/// Centralized string constants for the EV Charging app.
/// All user-visible strings should be defined here and in ARB files.
abstract final class AppStrings {
  // ============ App General ============
  static const String appName = 'EV Charging';
  static const String appTagline = 'Power Your Journey';
  
  // ============ Splash ============
  static const String splashAppTitle = 'splash_appTitle';
  static const String splashLoading = 'splash_loading';
  
  // ============ Onboarding ============
  static const String onbTitle1 = 'onb_title_1';
  static const String onbDesc1 = 'onb_desc_1';
  static const String onbTitle2 = 'onb_title_2';
  static const String onbDesc2 = 'onb_desc_2';
  static const String onbTitle3 = 'onb_title_3';
  static const String onbDesc3 = 'onb_desc_3';
  static const String onbCtaGetStarted = 'onb_cta_getStarted';
  static const String onbCtaNext = 'onb_cta_next';
  static const String onbCtaSkip = 'onb_cta_skip';
  
  // ============ Common Actions ============
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String retry = 'Retry';
  static const String submit = 'Submit';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  static const String seeAll = 'See All';
  static const String viewDetails = 'View Details';
  
  // ============ Auth ============
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String createAccount = 'Create Account';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String rememberMe = 'Remember Me';
  static const String orContinueWith = 'Or continue with';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String welcomeBack = 'Welcome Back!';
  static const String createYourAccount = 'Create your account';
  static const String enterEmailToReset = 'Enter your email to reset password';
  
  // ============ User App ============
  static const String home = 'Home';
  static const String nearbyStations = 'Nearby Stations';
  static const String findChargingStation = 'Find Charging Station';
  static const String searchForStations = 'Search for stations...';
  static const String favorites = 'Favorites';
  static const String myBookings = 'My Bookings';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String history = 'History';
  static const String wallet = 'Wallet';
  static const String helpSupport = 'Help & Support';
  static const String aboutUs = 'About Us';
  static const String termsConditions = 'Terms & Conditions';
  static const String privacyPolicy = 'Privacy Policy';
  
  // ============ Station Details ============
  static const String stationDetails = 'Station Details';
  static const String available = 'Available';
  static const String occupied = 'Occupied';
  static const String offline = 'Offline';
  static const String distance = 'Distance';
  static const String rating = 'Rating';
  static const String reviews = 'Reviews';
  static const String amenities = 'Amenities';
  static const String chargerTypes = 'Charger Types';
  static const String pricePerKwh = 'Price per kWh';
  static const String operatingHours = 'Operating Hours';
  static const String getDirections = 'Get Directions';
  static const String bookNow = 'Book Now';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';
  
  // ============ Booking ============
  static const String selectCharger = 'Select Charger';
  static const String selectTimeSlot = 'Select Time Slot';
  static const String bookingConfirmation = 'Booking Confirmation';
  static const String bookingDetails = 'Booking Details';
  static const String bookingSuccessful = 'Booking Successful!';
  static const String bookingFailed = 'Booking Failed';
  static const String upcomingBookings = 'Upcoming Bookings';
  static const String pastBookings = 'Past Bookings';
  static const String cancelBooking = 'Cancel Booking';
  static const String startCharging = 'Start Charging';
  static const String stopCharging = 'Stop Charging';
  static const String chargingInProgress = 'Charging in Progress';
  static const String chargingComplete = 'Charging Complete';
  static const String estimatedTime = 'Estimated Time';
  static const String totalCost = 'Total Cost';
  static const String payNow = 'Pay Now';
  
  // ============ Owner App ============
  static const String dashboard = 'Dashboard';
  static const String myStations = 'My Stations';
  static const String addStation = 'Add Station';
  static const String editStation = 'Edit Station';
  static const String manageChargers = 'Manage Chargers';
  static const String earnings = 'Earnings';
  static const String analytics = 'Analytics';
  static const String todayEarnings = "Today's Earnings";
  static const String totalEarnings = 'Total Earnings';
  static const String totalBookings = 'Total Bookings';
  static const String activeChargers = 'Active Chargers';
  static const String stationName = 'Station Name';
  static const String stationAddress = 'Station Address';
  static const String chargerCount = 'Number of Chargers';
  
  // ============ Admin App ============
  static const String adminDashboard = 'Admin Dashboard';
  static const String manageUsers = 'Manage Users';
  static const String manageOwners = 'Manage Owners';
  static const String manageStations = 'Manage Stations';
  static const String reports = 'Reports';
  static const String systemSettings = 'System Settings';
  static const String totalUsers = 'Total Users';
  static const String totalOwners = 'Total Owners';
  static const String totalStations = 'Total Stations';
  static const String pendingApprovals = 'Pending Approvals';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  
  // ============ Errors ============
  static const String errorOccurred = 'An error occurred';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String noDataFound = 'No data found';
  static const String noStationsFound = 'No stations found';
  static const String noBookingsFound = 'No bookings found';
  
  // ============ Empty States ============
  static const String noFavorites = 'No favorites yet';
  static const String noNotifications = 'No notifications';
  static const String noReviews = 'No reviews yet';
  static const String emptyCart = 'Your cart is empty';
  
  // ============ Success Messages ============
  static const String profileUpdated = 'Profile updated successfully';
  static const String passwordChanged = 'Password changed successfully';
  static const String bookingCancelled = 'Booking cancelled successfully';
  static const String paymentSuccessful = 'Payment successful';
  static const String stationAdded = 'Station added successfully';
  static const String stationUpdated = 'Station updated successfully';

  // ============ Home Screen Sections ============
  static const String tripPlannerTitle = 'Trip Planner';
  static const String tripPlannerCta = 'Plan a Trip';
  static const String bundlesTitle = 'Value Packs';
  static const String offersTitle = 'Offers & Rewards';
  static const String activityTitle = 'Your Activity';
  static const String categoriesTitle = 'Quick Actions';

  // ============ Activity Stats ============
  static const String activitySessionsToday = 'Sessions Today';
  static const String activityEnergy = 'Energy Used';
  static const String activitySpent = 'Spent Today';
  static const String activityCo2Saved = 'CO₂ Saved';

  // ============ Categories ============
  static const String categoryFind = 'Find Charger';
  static const String categoryBook = 'Book Slot';
  static const String categoryBookings = 'My Bookings';
  static const String categoryVehicles = 'My Vehicles';
  static const String categoryHistory = 'History';
  static const String categorySupport = 'Support';

  // ============ Bundles ============
  static const String bundleUnlimitedTitle = 'Unlimited';
  static const String bundleUnlimitedDesc = 'Charge unlimited with priority access';
  static const String bundleSaverTitle = 'Monthly Saver';
  static const String bundleSaverDesc = '200 kWh included monthly';
  static const String bundleHomeTitle = 'Home Setup';
  static const String bundleHomeDesc = 'Complete home charger setup';
  static const String bundleBusinessTitle = 'Business';
  static const String bundleBusinessDesc = 'Fleet management solution';
  static const String bundleBadgeBestValue = 'Best Value';
  static const String bundleBadgePopular = 'Popular';

  // ============ Offers ============
  static const String offerFlashSaleTitle = 'Flash Sale';
  static const String offerFlashSaleDesc = 'Limited time only! Charge now and save.';
  static const String offerCashbackTitle = 'Cashback';
  static const String offerCashbackDesc = 'Earn cashback on every charging session.';
  static const String offerPartnerTitle = 'Partner Deal';
  static const String offerPartnerDesc = 'Special rates at partner locations.';
  static const String offerSeasonalTitle = 'Seasonal Special';
  static const String offerSeasonalDesc = 'Celebrate the season with savings!';
}

