/// File: lib/features/splash/ui/splash_page.dart
/// Purpose: Splash screen shown at app launch
/// Belongs To: splash feature
/// Route: /splash
/// Customization Guide:
///    - Modify logo and branding
///    - Adjust navigation logic after splash
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';

/// Splash page displayed at app launch.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateAfterDelay();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationSlow,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) {
        // TODO: Check if user is logged in and navigate accordingly
        context.go(AppRoutes.onboarding.path);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(scale: _scaleAnimation, child: child),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 24.h),
                _buildAppName(),
                SizedBox(height: 8.h),
                _buildTagline(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.ev_station_rounded, size: 56.r, color: AppColors.primary),
    );
  }

  Widget _buildAppName() {
    return Text(
      AppStrings.appName,
      style: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      AppStrings.appTagline,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.8),
        letterSpacing: 0.5,
      ),
    );
  }
}
