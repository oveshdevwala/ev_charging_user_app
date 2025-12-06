/// File: lib/features/auth/ui/register_page.dart
/// Purpose: User registration screen
/// Belongs To: auth feature
/// Route: /register
/// Customization Guide:
///    - Modify form fields and validation
///    - Adjust registration flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';

/// Registration page for new users.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms and conditions')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        context.go(AppRoutes.userHome.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppAppBar(title: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 32.h),
                _buildNameField(),
                SizedBox(height: 16.h),
                _buildEmailField(),
                SizedBox(height: 16.h),
                _buildPhoneField(),
                SizedBox(height: 16.h),
                _buildPasswordField(),
                SizedBox(height: 16.h),
                _buildConfirmPasswordField(),
                SizedBox(height: 20.h),
                _buildTermsCheckbox(context),
                SizedBox(height: 32.h),
                _buildRegisterButton(),
                SizedBox(height: 24.h),
                _buildSignInLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createYourAccount,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Start your EV charging journey',
          style: TextStyle(
            fontSize: 16.sp,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return CommonTextField(
      controller: _nameController,
      label: AppStrings.fullName,
      hint: 'Enter your full name',
      prefixIcon: Iconsax.user,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name is required';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return CommonTextField(
      controller: _emailController,
      label: AppStrings.email,
      hint: 'Enter your email',
      prefixIcon: Iconsax.sms,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.emailRequired;
        }
        if (!value.contains('@')) {
          return AppStrings.invalidEmail;
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CommonTextField(
      controller: _phoneController,
      label: AppStrings.phoneNumber,
      hint: 'Enter your phone number',
      prefixIcon: Iconsax.call,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordField() {
    return CommonTextField(
      controller: _passwordController,
      label: AppStrings.password,
      hint: 'Create a password',
      prefixIcon: Iconsax.lock,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.passwordRequired;
        }
        if (value.length < 8) {
          return AppStrings.passwordTooShort;
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return CommonTextField(
      controller: _confirmPasswordController,
      label: AppStrings.confirmPassword,
      hint: 'Confirm your password',
      prefixIcon: Iconsax.lock,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) =>
                setState(() => _agreeToTerms = value ?? false),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
            child: RichText(
              text: TextSpan(
                text: 'I agree to the ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: AppStrings.termsConditions,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: AppStrings.privacyPolicy,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CommonButton(
      label: AppStrings.signUp,
      onPressed: _onRegister,
      isLoading: _isLoading,
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: TextButton(
        onPressed: () => context.pop(),
        child: RichText(
          text: TextSpan(
            text: AppStrings.alreadyHaveAccount,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
            children: [
              TextSpan(
                text: ' ${AppStrings.signIn}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
