/// File: lib/features/profile/ui/change_password_page.dart
/// Purpose: Change password screen
/// Belongs To: profile feature
/// Route: /changePassword
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Change password page.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthSecurityBloc(
        repository: sl<ProfileRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
        ),
        body: BlocListener<AuthSecurityBloc, AuthSecurityState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!)),
              );
              context.pop();
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter your current password and choose a new one',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                  ),
                  SizedBox(height: 24.h),
                  CommonTextField(
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    hint: 'Enter current password',
                    obscureText: _obscureCurrentPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20.r,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    validator: Validators.required,
                  ),
                  SizedBox(height: 16.h),
                  CommonTextField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    hint: 'Enter new password',
                    obscureText: _obscureNewPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20.r,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    validator: Validators.password,
                  ),
                  SizedBox(height: 16.h),
                  CommonTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    hint: 'Re-enter new password',
                    obscureText: _obscureConfirmPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20.r,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<AuthSecurityBloc, AuthSecurityState>(
                    builder: (context, state) {
                      return CommonButton(
                        label: 'Change Password',
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthSecurityBloc>().add(
                                        ChangePassword(
                                          currentPassword: _currentPasswordController.text,
                                          newPassword: _newPasswordController.text,
                                        ),
                                      );
                                }
                              },
                        isLoading: state.isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

