/// File: lib/features/main_shell/ui/main_shell_page.dart
/// Purpose: Main navigation shell for user app with bottom navigation
/// Belongs To: main_shell feature
/// Route: ShellRoute wrapper
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../widgets/bottom_nav_bar.dart';

/// Main shell page with bottom navigation for user app.
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentPath: GoRouterState.of(context).uri.path,
      ),
    );
  }
}

