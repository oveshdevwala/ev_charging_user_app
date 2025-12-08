/// File: lib/admin/core/extensions/admin_context_ext.dart
/// Purpose: BuildContext extensions for admin panel theme, navigation, and sizing
/// Belongs To: admin/core/extensions
/// Customization Guide:
///    - Use these extensions instead of direct calls
///    - context.adminColors, context.adminText, context.goToAdmin, etc.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/admin_routes.dart';
import '../theme/admin_theme_extensions.dart';
import '../widgets/admin_modal_sheet.dart';

// ============================================================
// Theme & Color Extensions
// ============================================================

/// Extension for easy theme access in admin panel.
extension AdminContextThemeExt on BuildContext {
  /// Current ThemeData.
  ThemeData get theme => Theme.of(this);

  /// Current ColorScheme.
  ColorScheme get colors => theme.colorScheme;

  /// Current TextTheme.
  TextTheme get text => theme.textTheme;

  /// Primary color.
  Color get primaryColor => colors.primary;

  /// Surface color.
  Color get surfaceColor => colors.surface;

  /// Background color (scaffold).
  Color get backgroundColor => theme.scaffoldBackgroundColor;

  /// Error color.
  Color get errorColor => colors.error;
}

/// Extension for AdminAppColors ThemeExtension access.
extension AdminAppColorContextExt on BuildContext {
  /// Access to AdminAppColors ThemeExtension.
  AdminAppColors get adminColors {
    final adminColors = theme.extension<AdminAppColors>();
    if (adminColors == null) {
      throw StateError(
        'AdminAppColors extension not found in theme. '
        'Ensure admin_light_theme.dart and admin_dark_theme.dart include the extension.',
      );
    }
    return adminColors;
  }
}

// ============================================================
// Dark Mode Check Extension
// ============================================================

/// Extension for theme mode checks.
extension AdminContextDarkModeExt on BuildContext {
  /// Whether dark mode is active.
  bool get isDark => theme.brightness == Brightness.dark;

  /// Whether light mode is active.
  bool get isLight => !isDark;

  /// Platform brightness.
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;
}

// ============================================================
// Navigation Extensions
// ============================================================

/// Extension for navigation using AdminRoutes.
extension AdminContextNavExt on BuildContext {
  /// Navigate to a route (replace current).
  void goToAdmin(AdminRoutes route) => go(route.path);

  /// Navigate to a route with ID parameter.
  void goToAdminWithId(AdminRoutes route, String id) => go(route.id(id));

  /// Push a route onto the stack.
  void pushToAdmin(AdminRoutes route) => push(route.path);

  /// Push a route with ID parameter.
  void pushToAdminWithId(AdminRoutes route, String id) => push(route.id(id));

  /// Pop the current route.
  void popAdminRoute() => pop();

  /// Check if can pop.
  bool get canPopAdminRoute => canPop();

  /// Replace current route.
  void replaceToAdmin(AdminRoutes route) => pushReplacement(route.path);
}

// ============================================================
// ScreenUtil Size Extensions
// ============================================================

/// Extension for responsive sizing shortcuts.
extension AdminContextScreenExt on BuildContext {
  /// Screen width.
  double get sw => MediaQuery.of(this).size.width;

  /// Screen height.
  double get sh => MediaQuery.of(this).size.height;

  /// Width percentage (0-1).
  double widthPercent(double percent) => sw * percent;

  /// Height percentage (0-1).
  double heightPercent(double percent) => sh * percent;

  /// Responsive width.
  double w(double value) => value.w;

  /// Responsive height.
  double h(double value) => value.h;

  /// Responsive font size.
  double sp(double value) => value.sp;

  /// Responsive radius.
  double r(double value) => value.r;

  /// Horizontal padding.
  EdgeInsets padH(double value) => EdgeInsets.symmetric(horizontal: value.w);

  /// Vertical padding.
  EdgeInsets padV(double value) => EdgeInsets.symmetric(vertical: value.h);

  /// All-side padding.
  EdgeInsets padAll(double value) => EdgeInsets.all(value.r);

  /// Custom padding.
  EdgeInsets padOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );
}

// ============================================================
// Media Query Extensions
// ============================================================

/// Extension for media query shortcuts.
extension AdminContextMediaQueryExt on BuildContext {
  /// MediaQueryData.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen padding (safe area).
  EdgeInsets get safePadding => mediaQuery.padding;

  /// View insets (keyboard).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Device pixel ratio.
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Text scale factor.
  TextScaler get textScaler => mediaQuery.textScaler;

  /// Whether keyboard is visible.
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Device orientation.
  Orientation get orientation => mediaQuery.orientation;

  /// Whether portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Whether landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;
}

// ============================================================
// Responsive Breakpoint Extensions
// ============================================================

/// Extension for responsive breakpoints (web-first approach).
extension AdminContextBreakpointExt on BuildContext {
  /// Mobile breakpoint (< 768).
  bool get isMobile => sw < 768;

  /// Tablet breakpoint (768 - 1024).
  bool get isTablet => sw >= 768 && sw < 1024;

  /// Desktop breakpoint (>= 1024).
  bool get isDesktop => sw >= 1024;

  /// Large desktop breakpoint (>= 1440).
  bool get isLargeDesktop => sw >= 1440;

  /// Sidebar should be collapsed on mobile/tablet.
  bool get shouldCollapseSidebar => sw < 1024;

  /// Responsive value based on breakpoint.
  T responsive<T>({required T mobile, T? tablet, T? desktop, T? largeDesktop}) {
    if (isLargeDesktop && largeDesktop != null) {
      return largeDesktop;
    }
    if (isDesktop && desktop != null) {
      return desktop;
    }
    if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}

// ============================================================
// Modal Sheet Extensions
// ============================================================

/// Extension for showing admin modal sheets.
extension AdminContextModalExt on BuildContext {
  /// Show an adaptive admin modal sheet (full-screen on mobile, centered on desktop).
  Future<T?> showAdminModal<T>({
    required Widget child,
    String? title,
    bool showCloseButton = true,
    double? width,
    double? height,
    double maxWidth = 800,
    double maxHeight = 900,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return AdminModalSheet.show<T>(
      context: this,
      child: child,
      title: title,
      showCloseButton: showCloseButton,
      width: width,
      height: height,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }
}

// ============================================================
// Snackbar & Dialog Extensions
// ============================================================

/// Extension for showing snackbars and dialogs.
extension AdminContextMessengerExt on BuildContext {
  /// Show a snackbar.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Show an error snackbar.
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: adminColors.error,
      ),
    );
  }

  /// Show a success snackbar.
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: adminColors.success,
      ),
    );
  }

  /// Show a warning snackbar.
  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: adminColors.warning,
      ),
    );
  }

  /// Show an info snackbar.
  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: adminColors.info,
      ),
    );
  }

  /// Hide current snackbar.
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  /// Show a loading dialog.
  Future<void> showLoadingDialog({String? message}) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(width: 16.w),
              Flexible(child: Text(message ?? 'Loading...')),
            ],
          ),
        ),
      ),
    );
  }

  /// Hide the loading dialog.
  void hideLoadingDialog() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  /// Show a confirmation dialog.
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDanger
                ? ElevatedButton.styleFrom(
                    backgroundColor: adminColors.error,
                    foregroundColor: adminColors.onError,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Focus Extensions
// ============================================================

/// Extension for focus management.
extension AdminContextFocusExt on BuildContext {
  /// Unfocus current focus.
  void unfocus() => FocusScope.of(this).unfocus();

  /// Request focus on a node.
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  /// Whether any field has focus.
  bool get hasFocus => FocusScope.of(this).hasFocus;
}

