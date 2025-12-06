/// File: lib/features/onboarding/ui/onboarding_page.dart
/// Purpose: Onboarding screens for first-time users
/// Belongs To: onboarding feature
/// Route: /onboarding
/// Customization Guide:
///    - Modify onboarding content and images
///    - Adjust page count and animations
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../models/onboarding_item.dart';

/// Onboarding page for first-time users.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      icon: Iconsax.location,
      title: 'Find Nearby Stations',
      description:
          'Discover charging stations near you with real-time availability and pricing information.',
    ),
    OnboardingItem(
      icon: Iconsax.calendar_tick,
      title: 'Easy Booking',
      description:
          'Book your charging slot in advance and never wait in line again.',
    ),
    OnboardingItem(
      icon: Iconsax.flash_1,
      title: 'Fast Charging',
      description:
          'Access a network of fast chargers to get back on the road quickly.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    context.go(AppRoutes.login.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSkipButton(),
            _buildPageView(),
            _buildIndicators(),
            SizedBox(height: 32.h),
            _buildButtons(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    final colors = context.appColors;
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToLogin,
        child: Text(
          AppStrings.skip,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) => _buildPage(_items[index]),
      ),
    );
  }

  Widget _buildIndicators() {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_items.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : colors.outline,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  Widget _buildButtons() {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          CommonButton(
            label: _currentPage == _items.length - 1
                ? 'Get Started'
                : AppStrings.next,
            onPressed: _onNextPressed,
          ),
          SizedBox(height: 16.h),
          if (_currentPage == _items.length - 1)
            TextButton(
              onPressed: _navigateToLogin,
              child: RichText(
                text: TextSpan(
                  text: AppStrings.alreadyHaveAccount,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textSecondary,
                  ),
                  children: const [
                    TextSpan(
                      text: ' ${AppStrings.signIn}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160.r,
            height: 160.r,
            decoration:  BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 72.r, color: AppColors.primary),
          ),
          SizedBox(height: 48.h),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
