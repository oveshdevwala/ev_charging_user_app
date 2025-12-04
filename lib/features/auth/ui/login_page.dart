/// File: lib/features/auth/ui/login_page.dart
/// Purpose: User login screen
/// Belongs To: auth feature
/// Route: /login
/// Customization Guide:
///    - Modify form fields and validation
///    - Add social login providers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../widgets/social_login_button.dart';

/// Login page for user authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate login delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        context.go(AppRoutes.userHome.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                _buildHeader(),
                SizedBox(height: 40.h),
                _buildEmailField(),
                SizedBox(height: 20.h),
                _buildPasswordField(),
                SizedBox(height: 16.h),
                _buildRememberForgotRow(),
                SizedBox(height: 32.h),
                _buildLoginButton(),
                SizedBox(height: 24.h),
                _buildDivider(),
                SizedBox(height: 24.h),
                _buildSocialButtons(),
                SizedBox(height: 32.h),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in to continue charging',
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CommonTextField(
      controller: _emailController,
      label: AppStrings.email,
      hint: 'Enter your email',
      prefixIcon: Iconsax.sms,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return AppStrings.emailRequired;
        if (!value.contains('@')) return AppStrings.invalidEmail;
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CommonTextField(
      controller: _passwordController,
      label: AppStrings.password,
      hint: 'Enter your password',
      prefixIcon: Iconsax.lock,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) return AppStrings.passwordRequired;
        if (value.length < 6) return AppStrings.passwordTooShort;
        return null;
      },
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              AppStrings.rememberMe,
              style:
                  TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
            ),
          ],
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.forgotPassword.path),
          child: Text(
            AppStrings.forgotPassword,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return CommonButton(
      label: AppStrings.signIn,
      onPressed: _onLogin,
      isLoading: _isLoading,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outlineLight)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            AppStrings.orContinueWith,
            style:
                TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outlineLight)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            onPressed: () {},
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SocialLoginButton(
            icon: Icons.apple,
            label: 'Apple',
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: TextButton(
        onPressed: () => context.push(AppRoutes.register.path),
        child: RichText(
          text: TextSpan(
            text: AppStrings.dontHaveAccount,
            style:
                TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
            children: [
              TextSpan(
                text: ' ${AppStrings.signUp}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

