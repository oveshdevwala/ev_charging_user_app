/// File: lib/admin/features/users/view/user_edit_view.dart
/// Purpose: User create/edit form for admin panel
/// Belongs To: admin/features/users
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/admin_user.dart';

/// User form view for create/edit.
class UserEditView extends StatefulWidget {
  const UserEditView({
    required this.onSaved,
    this.user,
    super.key,
  });

  final AdminUser? user;
  final void Function(AdminUser) onSaved;

  @override
  State<UserEditView> createState() => _UserEditViewState();
}

class _UserEditViewState extends State<UserEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;
  late String _status;
  late String _role;
  String? _accountType;
  String? _signupSource;
  String? _kycStatus;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _notesController = TextEditingController(text: user?.notes ?? '');
    _tagsController = TextEditingController(
      text: user?.tags?.join(', ') ?? '',
    );
    _status = user?.status ?? 'active';
    _role = user?.role ?? 'user';
    _accountType = user?.accountType;
    _signupSource = user?.signupSource;
    _kycStatus = user?.kycStatus;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final user = AdminUser(
      id: widget.user?.id ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      status: _status,
      role: _role,
      accountType: _accountType,
      signupSource: _signupSource,
      kycStatus: _kycStatus,
      walletBalance: widget.user?.walletBalance ?? 0.0,
      totalSessions: widget.user?.totalSessions ?? 0,
      totalSpent: widget.user?.totalSpent ?? 0.0,
      vehicleCount: widget.user?.vehicleCount ?? 0,
      tags: tags.isEmpty ? null : tags,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.user?.createdAt ?? DateTime.now(),
      lastLoginAt: widget.user?.lastLoginAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      lastChargeSessionAt: widget.user?.lastChargeSessionAt,
      avatarUrl: widget.user?.avatarUrl,
    );

    widget.onSaved(user);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isEdit = widget.user != null;

    return AdminPageContent(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  if (widget.user?.avatarUrl != null)
                    AdminAvatar(
                      imageUrl: widget.user!.avatarUrl,
                      name: widget.user!.name,
                      size: 64,
                    )
                  else
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.profile_2user,
                        size: 32.r,
                        color: colors.primary,
                      ),
                    ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit User' : 'Create New User',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        if (isEdit)
                          Text(
                            widget.user!.id,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Basic Information Section
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              // Name
              AdminTextField(
                controller: _nameController,
                label: AdminStrings.labelName,
                hint: 'Enter user name',
                prefixIcon: Iconsax.user,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AdminStrings.validationRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Email
              AdminTextField(
                controller: _emailController,
                label: AdminStrings.labelEmail,
                hint: 'Enter email address',
                prefixIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                enabled: !isEdit, // Email cannot be changed
                validator: AdminValidators.email,
              ),
              SizedBox(height: 16.h),

              // Phone
              AdminTextField(
                controller: _phoneController,
                label: AdminStrings.labelPhone,
                hint: 'Enter phone number (optional)',
                prefixIcon: Iconsax.call,
                keyboardType: TextInputType.phone,
                validator: AdminValidators.optional(AdminValidators.phone),
              ),
              SizedBox(height: 24.h),

              // Account Settings Section
              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              // Status
              AdminDropdownField<String>(
                value: _status,
                label: AdminStrings.labelStatus,
                items: const [
                  'active',
                  'inactive',
                  'suspended',
                  'blocked',
                ],
                itemBuilder: (value) => Row(
                  children: [
                    Icon(
                      _getStatusIcon(value),
                      size: 18.r,
                      color: _getStatusColor(value, colors),
                    ),
                    SizedBox(width: 8.w),
                    Text(value.toUpperCase()),
                  ],
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              SizedBox(height: 16.h),

              // Role
              AdminDropdownField<String>(
                value: _role,
                label: 'Role',
                items: const [
                  'user',
                  'premium',
                  'vip',
                ],
                itemBuilder: (value) => Row(
                  children: [
                    Icon(
                      _getRoleIcon(value),
                      size: 18.r,
                      color: _getRoleColor(value, colors),
                    ),
                    SizedBox(width: 8.w),
                    Text(value.toUpperCase()),
                  ],
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _role = value);
                  }
                },
              ),
              SizedBox(height: 16.h),

              // Account Type
              AdminDropdownField<String?>(
                value: _accountType,
                label: 'Account Type (Optional)',
                items: const [
                  null,
                  'personal',
                  'business',
                ],
                itemBuilder: (value) => Text(
                  value?.toUpperCase() ?? 'Not Set',
                ),
                onChanged: (value) {
                  setState(() => _accountType = value);
                },
              ),
              SizedBox(height: 16.h),

              // Signup Source
              AdminDropdownField<String?>(
                value: _signupSource,
                label: 'Signup Source (Optional)',
                items: const [
                  null,
                  'email',
                  'google',
                  'apple',
                  'facebook',
                ],
                itemBuilder: (value) => Text(
                  value?.toUpperCase() ?? 'Not Set',
                ),
                onChanged: (value) {
                  setState(() => _signupSource = value);
                },
              ),
              SizedBox(height: 16.h),

              // KYC Status
              AdminDropdownField<String?>(
                value: _kycStatus,
                label: 'KYC Status (Optional)',
                items: const [
                  null,
                  'pending',
                  'verified',
                  'rejected',
                ],
                itemBuilder: (value) => Text(
                  value?.toUpperCase() ?? 'Not Set',
                ),
                onChanged: (value) {
                  setState(() => _kycStatus = value);
                },
              ),
              SizedBox(height: 24.h),

              // Additional Information Section
              Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              // Tags
              AdminTextField(
                controller: _tagsController,
                label: 'Tags',
                hint: 'Enter tags separated by commas (e.g., Frequent User, EV Enthusiast)',
                prefixIcon: Iconsax.tag,
                helperText: 'Separate multiple tags with commas',
              ),
              SizedBox(height: 16.h),

              // Notes
              AdminTextField(
                controller: _notesController,
                label: 'Admin Notes',
                hint: 'Enter admin-only notes (optional)',
                prefixIcon: Iconsax.note_text,
                maxLines: 4,
                helperText: 'These notes are only visible to admins',
              ),
              SizedBox(height: 32.h),

              // Save button
              AdminButton(
                label: AdminStrings.actionSave,
                icon: Iconsax.tick_circle,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Iconsax.tick_circle;
      case 'inactive':
        return Iconsax.close_circle;
      case 'suspended':
        return Iconsax.warning_2;
      case 'blocked':
        return Iconsax.forbidden;
      default:
        return Iconsax.info_circle;
    }
  }

  Color _getStatusColor(String status, AdminAppColors colors) {
    switch (status) {
      case 'active':
        return colors.success;
      case 'inactive':
        return colors.textSecondary;
      case 'suspended':
        return colors.warning;
      case 'blocked':
        return colors.error;
      default:
        return colors.textPrimary;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'vip':
        return Iconsax.star;
      case 'premium':
        return Iconsax.crown;
      default:
        return Iconsax.profile_2user;
    }
  }

  Color _getRoleColor(String role, AdminAppColors colors) {
    switch (role) {
      case 'vip':
        return colors.warning;
      case 'premium':
        return colors.primary;
      default:
        return colors.textSecondary;
    }
  }
}

