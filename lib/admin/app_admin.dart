/// File: lib/admin/app_admin.dart
/// Purpose: Admin panel application entry point
/// Belongs To: admin
/// Customization Guide:
///    - This is the main entry point for the admin panel
///    - Run with: flutter run -d chrome --target=lib/admin/app_admin.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/admin_theme.dart';
import 'routes/admin_routes.dart';

/// Main entry point for Admin Panel.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdminApp());
}

/// Admin application widget.
class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  final _themeService = AdminThemeService();

  @override
  void dispose() {
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size for web/desktop (optimized for admin panel)
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AdminThemeProvider(
          themeService: _themeService,
          child: ListenableBuilder(
            listenable: _themeService,
            builder: (context, _) {
              return MaterialApp.router(
                title: 'EV Charging Admin',
                debugShowCheckedModeBanner: false,
                theme: AdminTheme.light,
                darkTheme: AdminTheme.dark,
                themeMode: _themeService.themeMode,
                routerConfig: AdminRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}
