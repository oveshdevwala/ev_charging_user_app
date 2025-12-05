/// File: lib/features/profile/ui/delete_account_page.dart
/// Purpose: Delete account screen
/// Belongs To: profile feature
/// Route: /deleteAccount
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Delete account page.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmTextController = TextEditingController();
  bool _isReauthenticated = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthSecurityBloc(
            repository: sl<ProfileRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Account'),
        ),
        body: BlocListener<AuthSecurityBloc, AuthSecurityState>(
          listener: (context, state) {
            if (state.isReauthenticated) {
              setState(() {
                _isReauthenticated = true;
              });
            }
            if (state.isAccountDeleted) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<AuthSecurityBloc>(),
                  child: AlertDialog(
                    title: const Text('Account Deleted'),
                    content: const Text('Your account has been permanently deleted.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.go(AppRoutes.login.path);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
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
                  Icon(
                    Iconsax.warning_2,
                    size: 64.r,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'This action cannot be undone. All your data will be permanently deleted.',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  if (!_isReauthenticated) ...[
                    CommonTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password to confirm',
                      obscureText: true,
                      validator: Validators.required,
                    ),
                    SizedBox(height: 16.h),
                    BlocBuilder<AuthSecurityBloc, AuthSecurityState>(
                      builder: (context, state) {
                      return CommonButton(
                        label: 'Verify Password',
                          onPressed: state.isReauthenticating
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthSecurityBloc>().add(
                                          Reauthenticate(_passwordController.text),
                                        );
                                  }
                                },
                          isLoading: state.isReauthenticating,
                        );
                      },
                    ),
                  ] else ...[
                    CommonTextField(
                      controller: _confirmTextController,
                      label: 'Type "DELETE" to confirm',
                      hint: 'DELETE',
                      validator: (value) {
                        if (value != 'DELETE') {
                          return 'Please type DELETE to confirm';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    BlocBuilder<AuthSecurityBloc, AuthSecurityState>(
                      builder: (context, state) {
                      return CommonButton(
                        label: 'Delete Account',
                          onPressed: state.isDeleting
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthSecurityBloc>().add(
                                          DeleteAccount(_confirmTextController.text),
                                        );
                                  }
                                },
                          isLoading: state.isDeleting,
                          backgroundColor: AppColors.error,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

