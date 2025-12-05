/// File: lib/core/constants/app_strings.dart
/// Purpose: Centralized string constants for the entire application
/// Belongs To: shared
/// Customization Guide:
///    - Add new strings as static const
///    - Group strings by feature/screen
///    - Always add corresponding ARB entries for localization
library;

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
  static const String nearbyOffers = 'Nearby Offers';
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
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
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
  static const String categoryTrip = 'Trip';

  // ============ Bundles ============
  static const String bundleUnlimitedTitle = 'Unlimited';
  static const String bundleUnlimitedDesc =
      'Charge unlimited with priority access';
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
  static const String offerFlashSaleDesc =
      'Limited time only! Charge now and save.';
  static const String offerCashbackTitle = 'Cashback';
  static const String offerCashbackDesc =
      'Earn cashback on every charging session.';
  static const String offerPartnerTitle = 'Partner Deal';
  static const String offerPartnerDesc = 'Special rates at partner locations.';
  static const String offerSeasonalTitle = 'Seasonal Special';
  static const String offerSeasonalDesc = 'Celebrate the season with savings!';

  // ============ Trip Planner ============
  static const String tripPlannerPageTitle = 'Trip Planner';
  static const String tripPlannerPlanTrip = 'Plan Trip';
  static const String tripPlannerStartPlanning = 'Start Planning';
  static const String tripPlannerRecentTrips = 'Recent Trips';
  static const String tripPlannerFavoriteTrips = 'Favorite Trips';
  static const String tripPlannerSavedTrips = 'Saved Trips';
  static const String tripPlannerNoTrips = 'No trips planned yet';
  static const String tripPlannerPlanFirstTrip = 'Plan Your First Trip';
  static const String tripPlannerEnterOrigin = 'Enter origin';
  static const String tripPlannerEnterDestination = 'Enter destination';
  static const String tripPlannerAddWaypoint = 'Add waypoint';
  static const String tripPlannerSelectVehicle = 'Select Vehicle';
  static const String tripPlannerCurrentCharge = 'Current Charge';
  static const String tripPlannerTripPreferences = 'Trip Preferences';
  static const String tripPlannerPreferFastChargers =
      'Prefer Fast Chargers (150+ kW)';
  static const String tripPlannerAvoidTolls = 'Avoid Toll Roads';
  static const String tripPlannerMinimizeStops = 'Minimize Stops';
  static const String tripPlannerMinimizeCost = 'Minimize Charging Cost';
  static const String tripPlannerDepartureTime = 'Departure Time';
  static const String tripPlannerNow = 'Now';
  static const String tripPlannerSchedule = 'Schedule';
  static const String tripPlannerCalculateTrip = 'Calculate Trip';
  static const String tripPlannerCalculating = 'Calculating your trip...';
  static const String tripPlannerTripSummary = 'Trip Summary';
  static const String tripPlannerTotalDistance = 'Total Distance';
  static const String tripPlannerTotalTime = 'Total Time';
  static const String tripPlannerChargingStops = 'Charging Stops';
  static const String tripPlannerEstimatedCost = 'Estimated Cost';
  static const String tripPlannerArrivalTime = 'Arrival Time';
  static const String tripPlannerSaveTrip = 'Save Trip';
  static const String tripPlannerStartNavigation = 'Start Navigation';
  static const String tripPlannerTripInsights = 'Trip Insights';
  static const String tripPlannerBatteryLevel = 'Battery Level';
  static const String tripPlannerTimeDistribution = 'Time Distribution';
  static const String tripPlannerCostBreakdown = 'Cost Breakdown';
  static const String tripPlannerEnergyStatistics = 'Energy Statistics';
  static const String tripPlannerEnvironmentalImpact = 'Environmental Impact';
  static const String tripPlannerCo2Saved = 'CO₂ Saved';
  static const String tripPlannerTripItinerary = 'Trip Itinerary';
  static const String tripPlannerDepart = 'Depart';
  static const String tripPlannerArrive = 'Arrive';
  static const String tripPlannerChargeAt = 'Charge at';
  static const String tripPlannerNoChargingNeeded = 'No Charging Stops Needed';
  static const String tripPlannerEnoughRange =
      'Your vehicle has enough range to complete this trip without stopping.';
  static const String tripPlannerReserve = 'Reserve';
  static const String tripPlannerNavigate = 'Navigate';
  static const String tripPlannerStopDetails = 'Stop Details';
  static const String tripPlannerChargingTips = 'Charging Tips';
  static const String tripPlannerTip1 = 'Charging slows down above 80% SOC';
  static const String tripPlannerTip2 =
      'Arrive with 10-20% for fastest charging';
  static const String tripPlannerTip3 =
      'Check station availability before arriving';

  // ============ Wallet ============
  static const String walletTitle = 'Wallet';
  static const String walletBalance = 'Wallet Balance';
  static const String walletRecharge = 'Recharge Wallet';
  static const String walletTransactions = 'Transactions';
  static const String walletCredits = 'Credits';
  static const String walletHistory = 'History';
  static const String walletAvailable = 'Available';
  static const String walletPending = 'Pending';
  static const String walletRewards = 'Rewards';
  static const String walletSelectAmount = 'Select Amount';
  static const String walletCustomAmount = 'Or enter custom amount';
  static const String walletMinMax = r'Min: $10 • Max: $10,000';
  static const String walletPaymentMethod = 'Payment Method';
  static const String walletOrderSummary = 'Order Summary';
  static const String walletRechargeAmount = 'Recharge Amount';
  static const String walletDiscount = 'Discount';
  static const String walletTotal = 'Total';
  static const String walletPayNow = 'Pay Now';
  static const String walletProcessing = 'Processing Payment...';
  static const String walletSuccess = 'Payment Successful!';
  static const String walletAddedToWallet = 'added to your wallet';
  static const String walletTransactionId = 'Transaction ID';
  static const String walletNoTransactions = 'No transactions yet';
  static const String walletTransactionsWillAppear =
      'Your wallet transactions will appear here';
  static const String walletNoCredits = 'No credits yet';
  static const String walletStartCharging = 'Start charging to earn credits';

  // ============ Promo Codes ============
  static const String promoApply = 'Apply';
  static const String promoCode = 'Promo Code';
  static const String promoEnterCode = 'Enter promo code';
  static const String promoApplyCode = 'Apply Promo Code';
  static const String promoAvailableOffers = 'Available Offers';
  static const String promoApplied = 'Code Applied';
  static const String promoYouSave = 'You save';
  static const String promoInvalidCode = 'Invalid promo code';
  static const String promoExpired = 'This promo code has expired';
  static const String promoMinSpend = 'Minimum spend required';
  static const String promoLimitReached = 'Usage limit reached';

  // ============ Credits ============
  static const String creditsTitle = 'Charging Credits';
  static const String creditsAvailable = 'Available';
  static const String creditsWorth = 'Worth';
  static const String creditsEarned = 'Earned';
  static const String creditsUsed = 'Used';
  static const String creditsThisMonth = 'This Month';
  static const String creditsExpiring = 'credits expiring in';
  static const String creditsDays = 'days';
  static const String creditsHistory = 'Credits History';
  static const String creditsChargingSession = 'Charging Session';
  static const String creditsReferralBonus = 'Referral Bonus';
  static const String creditsPromoOffer = 'Promotional Offer';
  static const String creditsSignupBonus = 'Sign-up Bonus';
  static const String creditsLoyaltyReward = 'Loyalty Reward';

  // ============ Cashback ============
  static const String cashbackTitle = 'Cashback';
  static const String cashbackEarned = 'Cashback Earned';
  static const String cashbackPending = 'Pending';
  static const String cashbackCredited = 'Credited';
  static const String cashbackPartnerStation = 'Partner Station';
  static const String cashbackGoldPartner = 'Gold Partner';
  static const String cashbackSilverPartner = 'Silver Partner';
  static const String cashbackPlatinumPartner = 'Platinum Partner';

  // ============ Transaction Types ============
  static const String txWalletRecharge = 'Wallet Recharge';
  static const String txChargingSession = 'Charging Session';
  static const String txCashback = 'Cashback';
  static const String txRefund = 'Refund';
  static const String txPromoCredit = 'Promo Credit';
  static const String txReferralBonus = 'Referral Bonus';
  static const String txReward = 'Reward';
  static const String txWithdrawal = 'Withdrawal';
  static const String txSubscription = 'Subscription';

  // ============ Transaction Filters ============
  static const String filterAll = 'All';
  static const String filterMoneyIn = 'Money In';
  static const String filterMoneyOut = 'Money Out';
  static const String filterCashback = 'Cashback';
  static const String filterRecharge = 'Recharge';

  // ============ Community & Reviews ============
  static const String communityTitle = 'Community';
  static const String communityReviews = 'Reviews';
  static const String communityPhotos = 'Photos';
  static const String communityQA = 'Q&A';
  static const String communityIssues = 'Issues';
  static const String communityWriteReview = 'Write a Review';
  static const String communityShareExperience = 'Share your experience';
  static const String communityAskQuestion = 'Ask a Question';
  static const String communityReportIssue = 'Report Issue';
  static const String communityUploadPhoto = 'Upload Photo';
  static const String communityVerified = 'Verified';
  static const String communityVerifiedSession =
      'Verified session — you charged here';
  static const String communityHelpful = 'Helpful';
  static const String communityReport = 'Report';
  static const String communityAnonymous = 'Anonymous';
  static const String communityPostAnonymously = 'Post anonymously';
  static const String communityAnonymousHelper =
      'Your name will not be shown to the public. Moderators may see your account for verification.';
  static const String communityNoReviews = 'No reviews yet';
  static const String communityBeFirst =
      'Be the first to share your experience';
  static const String communityNoPhotos = 'No photos yet';
  static const String communityNoQuestions = 'No questions yet';
  static const String communityMinChars = 'Minimum 20 characters';
  static const String communitySubmitReview = 'Submit Review';
  static const String communityReviewSubmitted =
      'Review submitted successfully';
  static const String communityQuestionPosted = 'Question posted successfully';
  static const String communityAnswerPosted = 'Answer posted successfully';
  static const String communityReportSubmitted =
      'Report submitted successfully';
  static const String communityReportConfirmation =
      "Thanks — we'll review this and respond within 48 hours.";
  static const String communityTicketId = 'Ticket ID';
  static const String communityExcellent = 'Excellent';
  static const String communityGood = 'Good';
  static const String communityAverage = 'Average';
  static const String communityPoor = 'Poor';
  static const String communityVeryPoor = 'Very Poor';
  static const String communityTapToRate = 'Tap to rate';
  static const String communityYourReview = 'Your Review';
  static const String communityReviewTitle = 'Summarize your experience';
  static const String communityReviewBody =
      'Share details about your charging experience...';
  static const String communityIChargedHere = 'I charged at this station';
  static const String communityVerifiedWeighted =
      'Verified reviews are weighted higher';
  static const String communityAcceptedAnswer = 'Accepted Answer';
  static const String communityAcceptAnswer = 'Accept Answer';
  static const String communityUpvote = 'Upvote';
  static const String communityUpvotes = 'upvotes';
  static const String communityAnswers = 'answers';
  static const String communityAnswered = 'Answered';
  static const String communityLoadMore = 'Load More';
  static const String communityViewAll = 'View All';
  static const String communitySortBy = 'Sort by';
  static const String communitySortMostRecent = 'Most Recent';
  static const String communitySortMostHelpful = 'Most Helpful';
  static const String communitySortHighestRating = 'Highest Rating';
  static const String communitySortLowestRating = 'Lowest Rating';

  // ============ Report Categories ============
  static const String reportSocketBroken = 'Socket Broken';
  static const String reportSlowCharging = 'Slow Charging';
  static const String reportPaymentFailed = 'Payment Failed';
  static const String reportInaccurateInfo = 'Inaccurate Information';
  static const String reportSpam = 'Spam';
  static const String reportHarassment = 'Harassment';
  static const String reportInappropriate = 'Inappropriate Content';
  static const String reportOther = 'Other';
  static const String reportSelectCategory = 'Select Issue Category';
  static const String reportDescription = 'Description (optional)';
  static const String reportDescriptionHint =
      'Provide more details about the issue...';
  static const String reportAnonymously = 'Report anonymously';

  // ============ Moderation ============
  static const String moderationTitle = 'Moderation Console';
  static const String moderationReports = 'Reports';
  static const String moderationApprove = 'Approve';
  static const String moderationRemove = 'Remove';
  static const String moderationReject = 'Reject';
  static const String moderationEscalate = 'Escalate';
  static const String moderationBulkActions = 'Bulk Actions';
  static const String moderationFilterAll = 'All';
  static const String moderationFilterPending = 'Pending';
  static const String moderationFilterHighPriority = 'High Priority';
  static const String moderationFilterResolved = 'Resolved';

  // ============ Nearby Offers ============
  static const String nearbyOffersTitle = 'Nearby Offers';
  static const String partnerMarketplaceTitle = 'Partner Marketplace';
  static const String partnerDetailTitle = 'Partner Details';
  static const String offerRedeemTitle = 'Redeem Offer';
  static const String checkInSuccessTitle = 'Check-in Successful!';

  // Categories
  static const String partner_category_food = 'Food & Dining';
  static const String partner_category_shopping = 'Shopping';
  static const String partner_category_movies = 'Movies & Entertainment';
  static const String partner_category_services = 'Services';
  static const String partner_category_entertainment = 'Entertainment';
  static const String partner_category_wellness = 'Wellness';
  static const String partner_category_all = 'All';

  // Offer Types
  static const String offer_type_discount = 'Discount';
  static const String offer_type_cashback = 'Cashback';
  static const String offer_type_free_item = 'Free Item';
  static const String offer_type_bogo = 'Buy 1 Get 1';
  static const String offer_type_perk = 'Perk';
  static const String offer_type_voucher = 'Voucher';

  // Actions
  static const String checkInHere = 'Check In Here';
  static const String claimOffer = 'Claim Offer';
  static const String redeemNow = 'Redeem Now';
  static const String showQRCode = 'Show QR Code';
  static const String viewPartner = 'View Partner';
  static const String viewOffers = 'View Offers';

  // Messages
  static const String noOffersFound = 'No offers found nearby';
  static const String noPartnersFound = 'No partners found';
  static const String checkInSuccessMessage = 'You earned credits for visiting';
  static const String offerExpired = 'This offer has expired';
  static const String offerRedeemed = 'Offer successfully redeemed';
  static const String showToPartner = 'Show this QR code to the cashier';
  static const String expiresIn = 'Expires in';
  static const String validUntil = 'Valid until';
}
