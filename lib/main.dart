/// File: lib/main.dart
/// Purpose: Application entry point
/// Belongs To: shared
/// Customization Guide:
///    - Modify theme mode or initial route
///    - Add additional providers or observers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bootstrap.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'routes/app_routes.dart';

void main() {
  bootstrap(() => const EVChargingApp());
}

/// Main application widget.
class EVChargingApp extends StatelessWidget {
  const EVChargingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: sl<ThemeManager>(),
          builder: (context, _) {
            return MaterialApp.router(
              title: 'EV Charging',
              debugShowCheckedModeBanner: false,

              // Theme configuration
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: sl<ThemeManager>().themeMode,

              // Router configuration
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
