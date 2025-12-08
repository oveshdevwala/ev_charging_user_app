/// File: lib/admin/core/config/admin_responsive.dart
/// Purpose: Responsive breakpoints and utilities for admin panel
/// Belongs To: admin/core/config
library;

import 'package:flutter/material.dart';

/// Responsive breakpoints.
abstract final class AdminBreakpoints {
  static const double mobile = 0;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
  static const double widescreen = 1920;
}

/// Responsive layout builder.
class AdminResponsiveBuilder extends StatelessWidget {
  const AdminResponsiveBuilder({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AdminBreakpoints.largeDesktop && largeDesktop != null) {
          return largeDesktop!;
        }
        if (constraints.maxWidth >= AdminBreakpoints.desktop && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= AdminBreakpoints.tablet && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}

/// Responsive value selector.
T adminResponsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  T? desktop,
  T? largeDesktop,
}) {
  final width = MediaQuery.of(context).size.width;
  
  if (width >= AdminBreakpoints.largeDesktop && largeDesktop != null) {
    return largeDesktop;
  }
  if (width >= AdminBreakpoints.desktop && desktop != null) {
    return desktop;
  }
  if (width >= AdminBreakpoints.tablet && tablet != null) {
    return tablet;
  }
  return mobile;
}

/// Check if screen is mobile.
bool isMobileScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < AdminBreakpoints.tablet;
}

/// Check if screen is tablet.
bool isTabletScreen(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= AdminBreakpoints.tablet && width < AdminBreakpoints.desktop;
}

/// Check if screen is desktop.
bool isDesktopScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= AdminBreakpoints.desktop;
}

/// Check if screen is large desktop.
bool isLargeDesktopScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= AdminBreakpoints.largeDesktop;
}

/// Get current breakpoint name.
String getCurrentBreakpoint(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= AdminBreakpoints.largeDesktop) return 'largeDesktop';
  if (width >= AdminBreakpoints.desktop) return 'desktop';
  if (width >= AdminBreakpoints.tablet) return 'tablet';
  return 'mobile';
}

/// Grid column count based on screen size.
int getGridColumnCount(BuildContext context) {
  return adminResponsiveValue<int>(
    context,
    mobile: 1,
    tablet: 2,
    desktop: 3,
    largeDesktop: 4,
  );
}

/// Content padding based on screen size.
EdgeInsets getContentPadding(BuildContext context) {
  return adminResponsiveValue<EdgeInsets>(
    context,
    mobile: const EdgeInsets.all(16),
    tablet: const EdgeInsets.all(20),
    desktop: const EdgeInsets.all(24),
    largeDesktop: const EdgeInsets.all(32),
  );
}

