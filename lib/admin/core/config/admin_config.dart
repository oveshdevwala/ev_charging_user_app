/// File: lib/admin/core/config/admin_config.dart
/// Purpose: Admin panel configuration values
/// Belongs To: admin/core/config
library;

/// Admin panel configuration.
abstract final class AdminConfig {
  // ============ App Info ============
  static const String appName = 'EV Charging Admin';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ============ Pagination ============
  static const int defaultPageSize = 10;
  static const List<int> pageSizeOptions = [10, 25, 50, 100];
  static const int maxPageSize = 100;

  // ============ Table ============
  static const double tableRowHeight = 52.0;
  static const double tableHeaderHeight = 48.0;
  static const double tableCellPadding = 16.0;

  // ============ Sidebar ============
  static const double sidebarWidth = 280.0;
  static const double sidebarCollapsedWidth = 72.0;
  static const double sidebarBreakpoint = 1024.0;

  // ============ Topbar ============
  static const double topbarHeight = 64.0;

  // ============ Cards ============
  static const double cardBorderRadius = 12.0;
  static const double cardPadding = 20.0;

  // ============ Buttons ============
  static const double buttonHeight = 44.0;
  static const double buttonBorderRadius = 8.0;
  static const double iconButtonSize = 40.0;

  // ============ Inputs ============
  static const double inputHeight = 44.0;
  static const double inputBorderRadius = 8.0;

  // ============ Spacing ============
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ============ Content ============
  static const double contentMaxWidth = 1400.0;
  static const double contentPadding = 24.0;

  // ============ Animation ============
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============ Debounce ============
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration autoSaveDebounce = Duration(milliseconds: 1000);

  // ============ Cache ============
  static const Duration cacheExpiration = Duration(minutes: 5);
  static const int maxCacheItems = 100;

  // ============ Validation ============
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxAddressLength = 200;

  // ============ File Upload ============
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedDocTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];

  // ============ Export ============
  static const int maxExportRows = 10000;
  static const String csvDelimiter = ',';
  static const String csvNewLine = '\n';
}

