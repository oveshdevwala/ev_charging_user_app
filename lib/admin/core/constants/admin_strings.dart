/// File: lib/admin/core/constants/admin_strings.dart
/// Purpose: All admin panel string constants for localization
/// Belongs To: admin/core/constants
/// Customization Guide:
///    - Add all UI strings here
///    - Use these via AdminStrings.xxx
library;

abstract final class AdminStrings {
  // ============ App ============
  static const String appTitle = 'EV Charging Admin';
  static const String appSubtitle = 'Management Dashboard';

  // ============ Navigation ============
  static const String navDashboard = 'Dashboard';
  static const String navStations = 'Stations';
  static const String navManagers = 'Managers';
  static const String navUsers = 'Users';
  static const String navSessions = 'Sessions';
  static const String navPayments = 'Payments';
  static const String navWallets = 'Wallets';
  static const String navOffers = 'Offers';
  static const String navPartners = 'Partners';
  static const String navReviews = 'Reviews';
  static const String navReports = 'Reports';
  static const String navContent = 'Content';
  static const String navLogs = 'Logs';
  static const String navSettings = 'Settings';
  static const String navMedia = 'Media';
  static const String navNotifications = 'Notifications';

  // ============ Common Actions ============
  static const String actionCreate = 'Create';
  static const String actionEdit = 'Edit';
  static const String actionDelete = 'Delete';
  static const String actionSave = 'Save';
  static const String actionCancel = 'Cancel';
  static const String actionSearch = 'Search';
  static const String actionFilter = 'Filter';
  static const String actionExport = 'Export CSV';
  static const String actionImport = 'Import';
  static const String actionRefresh = 'Refresh';
  static const String actionViewAll = 'View All';
  static const String actionViewDetails = 'View Details';
  static const String actionAssign = 'Assign';
  static const String actionUnassign = 'Unassign';
  static const String actionActivate = 'Activate';
  static const String actionDeactivate = 'Deactivate';
  static const String actionApprove = 'Approve';
  static const String actionReject = 'Reject';
  static const String actionClose = 'Close';
  static const String actionBack = 'Back';
  static const String actionNext = 'Next';
  static const String actionPrevious = 'Previous';

  // ============ Common Labels ============
  static const String labelId = 'ID';
  static const String labelName = 'Name';
  static const String labelEmail = 'Email';
  static const String labelPhone = 'Phone';
  static const String labelAddress = 'Address';
  static const String labelStatus = 'Status';
  static const String labelCreatedAt = 'Created At';
  static const String labelUpdatedAt = 'Updated At';
  static const String labelActions = 'Actions';
  static const String labelDescription = 'Description';
  static const String labelType = 'Type';
  static const String labelCategory = 'Category';
  static const String labelAmount = 'Amount';
  static const String labelDate = 'Date';
  static const String labelTime = 'Time';
  static const String labelDuration = 'Duration';
  static const String labelLocation = 'Location';
  static const String labelImage = 'Image';
  static const String labelRating = 'Rating';
  static const String labelReviews = 'Reviews';
  static const String labelTotal = 'Total';
  static const String labelSubtotal = 'Subtotal';
  static const String labelDiscount = 'Discount';
  static const String labelTax = 'Tax';

  // ============ Status Labels ============
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';
  static const String statusPending = 'Pending';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';
  static const String statusOnline = 'Online';
  static const String statusOffline = 'Offline';
  static const String statusMaintenance = 'Maintenance';

  // ============ Dashboard ============
  static const String dashboardTitle = 'Dashboard Overview';
  static const String dashboardWelcome = 'Welcome back, Admin!';
  static const String dashboardTotalStations = 'Total Stations';
  static const String dashboardActiveUsers = 'Active Users';
  static const String dashboardTodaySessions = "Today's Sessions";
  static const String dashboardRevenue = 'Revenue';
  static const String dashboardRecentActivity = 'Recent Activity';
  static const String dashboardQuickActions = 'Quick Actions';

  // ============ Stations ============
  static const String stationsTitle = 'Station Management';
  static const String stationsListTitle = 'All Stations';
  static const String stationsAddTitle = 'Add New Station';
  static const String stationsEditTitle = 'Edit Station';
  static const String stationsDetailTitle = 'Station Details';
  static const String stationsEmptyState = 'No stations found';
  static const String stationsTotalChargers = 'Total Chargers';
  static const String stationsAvailableChargers = 'Available Chargers';
  static const String stationsPowerOutput = 'Power Output';
  static const String stationsAssignManager = 'Assign Manager';
  static const String stationsChargerTypes = 'Charger Types';
  static const String stationsAmenities = 'Amenities';
  static const String stationsOperatingHours = 'Operating Hours';
  static const String stationsContactInfo = 'Contact Information';

  // ============ Managers ============
  static const String managersTitle = 'Station Managers';
  static const String managersListTitle = 'All Managers';
  static const String managersAddTitle = 'Add New Manager';
  static const String managersEditTitle = 'Edit Manager';
  static const String managersDetailTitle = 'Manager Details';
  static const String managersEmptyState = 'No managers found';
  static const String managersAssignedStations = 'Assigned Stations';

  // ============ Users ============
  static const String usersTitle = 'User Management';
  static const String usersListTitle = 'All Users';
  static const String usersAddTitle = 'Add New User';
  static const String usersEditTitle = 'Edit User';
  static const String usersDetailTitle = 'User Details';
  static const String usersEmptyState = 'No users found';
  static const String usersVehicles = 'Vehicles';
  static const String usersMembership = 'Membership';

  // ============ Sessions ============
  static const String sessionsTitle = 'Charging Sessions';
  static const String sessionsListTitle = 'All Sessions';
  static const String sessionsDetailTitle = 'Session Details';
  static const String sessionsEmptyState = 'No sessions found';
  static const String sessionsEnergyDelivered = 'Energy Delivered';
  static const String sessionsCost = 'Cost';
  static const String sessionsStartTime = 'Start Time';
  static const String sessionsEndTime = 'End Time';

  // ============ Payments ============
  static const String paymentsTitle = 'Payment Management';
  static const String paymentsListTitle = 'All Payments';
  static const String paymentsDetailTitle = 'Payment Details';
  static const String paymentsEmptyState = 'No payments found';

  // ============ Wallets ============
  static const String walletsTitle = 'Wallet Management';
  static const String walletsListTitle = 'All Wallets';
  static const String walletsDetailTitle = 'Wallet Details';
  static const String walletsEmptyState = 'No wallets found';
  static const String walletsBalance = 'Balance';
  static const String walletsTransactions = 'Transactions';

  // ============ Offers ============
  static const String offersTitle = 'Offers Management';
  static const String offersListTitle = 'All Offers';
  static const String offersAddTitle = 'Create New Offer';
  static const String offersEditTitle = 'Edit Offer';
  static const String offersDetailTitle = 'Offer Details';
  static const String offersEmptyState = 'No offers found';
  static const String offersValidFrom = 'Valid From';
  static const String offersValidUntil = 'Valid Until';
  static const String offersDiscountType = 'Discount Type';
  static const String offersDiscountValue = 'Discount Value';

  // ============ Partners ============
  static const String partnersTitle = 'Partner Management';
  static const String partnersListTitle = 'All Partners';
  static const String partnersAddTitle = 'Add New Partner';
  static const String partnersEditTitle = 'Edit Partner';
  static const String partnersDetailTitle = 'Partner Details';
  static const String partnersEmptyState = 'No partners found';

  // ============ Reviews ============
  static const String reviewsTitle = 'Review Management';
  static const String reviewsListTitle = 'All Reviews';
  static const String reviewsDetailTitle = 'Review Details';
  static const String reviewsEmptyState = 'No reviews found';
  static const String reviewsModerate = 'Moderate Review';

  // ============ Reports ============
  static const String reportsTitle = 'Reports & Analytics';
  static const String reportsRevenue = 'Revenue Report';
  static const String reportsUsage = 'Usage Report';
  static const String reportsStations = 'Station Performance';
  static const String reportsUsers = 'User Analytics';

  // ============ Content ============
  static const String contentTitle = 'Content Management';
  static const String contentPages = 'Pages';
  static const String contentFAQ = 'FAQ';
  static const String contentBanners = 'Banners';

  // ============ Logs ============
  static const String logsTitle = 'System Logs';
  static const String logsActivity = 'Activity Logs';
  static const String logsError = 'Error Logs';
  static const String logsAudit = 'Audit Logs';

  // ============ Settings ============
  static const String settingsTitle = 'Settings';
  static const String settingsGeneral = 'General Settings';
  static const String settingsPayment = 'Payment Settings';
  static const String settingsNotification = 'Notification Settings';
  static const String settingsSecurity = 'Security Settings';
  static const String settingsRBAC = 'Roles & Permissions';

  // ============ Messages ============
  static const String msgLoading = 'Loading...';
  static const String msgSuccess = 'Operation successful';
  static const String msgError = 'An error occurred';
  static const String msgNoData = 'No data available';
  static const String msgConfirmDelete = 'Are you sure you want to delete?';
  static const String msgConfirmDeactivate = 'Are you sure you want to deactivate?';
  static const String msgSaveChanges = 'Save changes?';
  static const String msgUnsavedChanges = 'You have unsaved changes';
  static const String msgExportSuccess = 'Export completed successfully';
  static const String msgImportSuccess = 'Import completed successfully';

  // ============ Table ============
  static const String tableNoResults = 'No results found';
  static const String tableShowingEntries = 'Showing {start} to {end} of {total} entries';
  static const String tableItemsPerPage = 'Items per page';
  static const String tableSelectAll = 'Select All';
  static const String tableSelected = '{count} selected';

  // ============ Filter ============
  static const String filterTitle = 'Filters';
  static const String filterApply = 'Apply Filters';
  static const String filterClear = 'Clear All';
  static const String filterDateRange = 'Date Range';
  static const String filterStatus = 'Status';
  static const String filterType = 'Type';
  static const String filterCategory = 'Category';

  // ============ Form Validation ============
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email';
  static const String validationPhone = 'Please enter a valid phone number';
  static const String validationMinLength = 'Minimum {min} characters required';
  static const String validationMaxLength = 'Maximum {max} characters allowed';
  static const String validationNumber = 'Please enter a valid number';
  static const String validationPositive = 'Please enter a positive number';
}

