/// File: lib/features/auth/ui/forgot_password_page.dart
/// Purpose: Password recovery screen
/// Belongs To: auth feature
/// Route: /forgotPassword
/// Customization Guide:
///    - Modify email validation
///    - Adjust success message and flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';

/// Forgot password page for password recovery.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
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
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: _emailSent
              ? _buildSuccessView(context)
              : _buildFormView(context),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context) {
    final colors = context.appColors;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.forgotPassword,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.enterEmailToReset,
            style: TextStyle(fontSize: 16.sp, color: colors.textSecondary),
          ),
          SizedBox(height: 40.h),
          CommonTextField(
            controller: _emailController,
            label: AppStrings.email,
            hint: 'Enter your email',
            prefixIcon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.emailRequired;
              }
              if (!value.contains('@')) {
                return AppStrings.invalidEmail;
              }
              return null;
            },
          ),
          SizedBox(height: 32.h),
          CommonButton(
            label: 'Send Reset Link',
            onPressed: _onSubmit,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            color: colors.successContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.tick_circle, size: 48.r, color: colors.success),
        ),
        SizedBox(height: 24.h),
        Text(
          'Email Sent!',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'We have sent a password reset link to\n${_emailController.text}',
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        CommonButton(
          label: 'Back to Login',
          onPressed: () => Navigator.of(context).pop(),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: Text(
            'Resend Email',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
