/// File: lib/core/extensions/context_ext.dart
/// Purpose: BuildContext extensions for theme, navigation, and sizing
/// Belongs To: shared
/// Customization Guide:
///    - Use these extensions instead of direct calls
///    - context.colors, context.text, context.goTo, etc.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';

// ============================================================
// Theme & Color Extensions
// ============================================================

/// Extension for easy theme access.
extension ContextThemeExt on BuildContext {
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

// ============================================================
// Dark Mode Check Extension
// ============================================================

/// Extension for theme mode checks.
extension ContextDarkModeExt on BuildContext {
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

/// Extension for navigation using AppRoutes.
extension ContextNavExt on BuildContext {
  /// Navigate to a route (replace current).
  void goTo(AppRoutes route) => go(route.path);
  
  /// Navigate to a route with ID parameter.
  void goToWithId(AppRoutes route, String id) => go(route.id(id));
  
  /// Push a route onto the stack.
  void pushTo(AppRoutes route) => push(route.path);
  
  /// Push a route with ID parameter.
  void pushToWithId(AppRoutes route, String id) => push(route.id(id));
  
  /// Pop the current route.
  void popRoute() => pop();
  
  /// Pop until the given route.
  void popUntilRoute(AppRoutes route) {
    while (canPop()) {
      pop();
    }
    go(route.path);
  }
  
  /// Check if can pop.
  bool get canPopRoute => canPop();
  
  /// Replace current route.
  void replaceTo(AppRoutes route) => pushReplacement(route.path);
}

// ============================================================
// ScreenUtil Size Extensions
// ============================================================

/// Extension for responsive sizing shortcuts.
extension ContextScreenExt on BuildContext {
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
extension ContextMediaQueryExt on BuildContext {
  /// MediaQueryData.
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Screen padding (safe area).
  EdgeInsets get padding => mediaQuery.padding;
  
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

/// Extension for responsive breakpoints.
extension ContextBreakpointExt on BuildContext {
  /// Mobile breakpoint (< 600).
  bool get isMobile => sw < 600;
  
  /// Tablet breakpoint (600 - 900).
  bool get isTablet => sw >= 600 && sw < 900;
  
  /// Desktop breakpoint (>= 900).
  bool get isDesktop => sw >= 900;
  
  /// Responsive value based on breakpoint.
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

// ============================================================
// Snackbar & Dialog Extensions
// ============================================================

/// Extension for showing snackbars and dialogs.
extension ContextMessengerExt on BuildContext {
  /// Show a snackbar.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }
  
  /// Show an error snackbar.
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
      ),
    );
  }
  
  /// Show a success snackbar.
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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
            children: [
              const CircularProgressIndicator(),
              SizedBox(width: 16.w),
              Text(message ?? 'Loading...'),
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
}

// ============================================================
// Focus Extensions
// ============================================================

/// Extension for focus management.
extension ContextFocusExt on BuildContext {
  /// Unfocus current focus.
  void unfocus() => FocusScope.of(this).unfocus();
  
  /// Request focus on a node.
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);
  
  /// Whether any field has focus.
  bool get hasFocus => FocusScope.of(this).hasFocus;
}

