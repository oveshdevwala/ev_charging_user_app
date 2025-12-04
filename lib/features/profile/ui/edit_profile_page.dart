/// File: lib/features/profile/ui/edit_profile_page.dart
/// Purpose: Edit profile screen
/// Belongs To: profile feature
/// Route: /editProfile
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../../../widgets/app_app_bar.dart';

/// Edit profile page for updating user information.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1234567890');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.profileUpdated)),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatar(),
              SizedBox(height: 32.h),
              CommonTextField(
                controller: _nameController,
                label: AppStrings.fullName,
                prefixIcon: Iconsax.user,
                validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                controller: _emailController,
                label: AppStrings.email,
                prefixIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                controller: _phoneController,
                label: AppStrings.phoneNumber,
                prefixIcon: Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 32.h),
              CommonButton(label: AppStrings.save, onPressed: _onSave, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100.r,
            height: 100.r,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Center(
              child: Text(
                'JD',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Iconsax.camera, size: 16.r, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

