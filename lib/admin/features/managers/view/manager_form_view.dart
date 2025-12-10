/// File: lib/admin/features/managers/view/manager_form_view.dart
/// Purpose: Manager create/edit form for admin panel
/// Belongs To: admin/features/managers
/// Customization Guide:
///    - Add additional fields as needed
///    - Modify validation rules in AdminValidators
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

import '../../../core/core.dart';
import '../../../models/manager.dart';

// Constant list for roles dropdown - must match dropdown item value exactly
const _defaultRoles = ['station_manager'];

/// Manager form view for create/edit.
class ManagerFormView extends StatefulWidget {
  const ManagerFormView({
    required this.onSaved, this.manager,
    super.key,
  });

  final Manager? manager;
  final void Function(Manager) onSaved;

  @override
  State<ManagerFormView> createState() => _ManagerFormViewState();
}

class _ManagerFormViewState extends State<ManagerFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _stationIdsController;
  late List<String> _roles;
  late String _status;

  @override
  void initState() {
    super.initState();
    final manager = widget.manager;
    _nameController = TextEditingController(text: manager?.name ?? '');
    _emailController = TextEditingController(text: manager?.email ?? '');
    _phoneController = TextEditingController(text: manager?.phone ?? '');
    _stationIdsController = TextEditingController(
      text: manager?.assignedStationIds.join(', ') ?? '',
    );
    // Use the same list instance as the dropdown item for reference equality
    _roles = _defaultRoles;
    _status = manager?.status ?? 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _stationIdsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final stationIds = _stationIdsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final manager = Manager(
      id: widget.manager?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      assignedStationIds: stationIds,
      roles: _roles,
      status: _status,
      createdAt: widget.manager?.createdAt ?? DateTime.now(),
    );

    widget.onSaved(manager);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isEdit = widget.manager != null;

    return AdminPageContent(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary.withValues(alpha: 0.1),
                      colors.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isEdit ? Iconsax.edit_2 : Iconsax.user_add,
                        size: 24.r,
                        color: colors.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? AdminStrings.managersEditTitle
                                : AdminStrings.managersAddTitle,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isEdit
                                ? 'Update manager information'
                                : 'Create a new manager account',
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
              ),
              SizedBox(height: 24.h),

              // Personal Information Section
              AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.profile_circle,
                          size: 20.r,
                          color: colors.primary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    // Name
                    AdminTextField(
                      controller: _nameController,
                      label: AdminStrings.labelName,
                      hint: 'Enter full name',
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
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Assignment & Settings Section
              AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.setting_2,
                          size: 20.r,
                          color: colors.primary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Assignment & Settings',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    // Assigned Station IDs
                    AdminTextField(
                      controller: _stationIdsController,
                      label: 'Assigned Station IDs',
                      hint: 'Enter station IDs separated by commas (e.g., st_1001, st_1002)',
                      prefixIcon: Iconsax.gas_station,
                      maxLines: 3,
                      helperText: 'Leave empty if no stations assigned yet',
                    ),
                    SizedBox(height: 20.h),
                    // Roles & Status Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.shield_tick,
                                    size: 16.r,
                                    color: colors.textSecondary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Role',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              DropdownButtonFormField<List<String>>(
                                value: _roles,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: _defaultRoles,
                                    child: Text('Station Manager'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _roles = value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _status == 'active'
                                        ? Iconsax.tick_circle
                                        : Iconsax.close_circle,
                                    size: 16.r,
                                    color: _status == 'active'
                                        ? colors.success
                                        : colors.error,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    AdminStrings.labelStatus,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              DropdownButtonFormField<String>(
                                value: _status,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'active',
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'inactive',
                                    child: Text('Inactive'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _status = value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AdminButton(
                      label: AdminStrings.actionCancel,
                      variant: AdminButtonVariant.outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: AdminButton(
                      label: AdminStrings.actionSave,
                      icon: Iconsax.tick_circle,
                      onPressed: _handleSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

