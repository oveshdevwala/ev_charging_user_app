/// File: lib/admin/features/stations/view/station_edit_page.dart
/// Purpose: Station create/edit page for admin panel
/// Belongs To: admin/features/stations
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/admin_station_model.dart';
import '../bloc/stations_bloc.dart';
import '../bloc/stations_event.dart';
import '../bloc/stations_state.dart';

/// Station edit/create page.
class StationEditPage extends StatelessWidget {
  const StationEditPage({super.key, this.stationId});

  final String? stationId;

  bool get isEditing => stationId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = StationsBloc();
        if (stationId != null) {
          bloc.add(StationDetailLoadRequested(stationId!));
        }
        return bloc;
      },
      child: _StationEditView(stationId: stationId),
    );
  }
}

class _StationEditView extends StatefulWidget {
  const _StationEditView({this.stationId});

  final String? stationId;

  @override
  State<_StationEditView> createState() => _StationEditViewState();
}

class _StationEditViewState extends State<_StationEditView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _operatingHoursController;

  AdminStationStatus _status = AdminStationStatus.active;
  bool _isLoading = false;
  File? _imageFile;
  String? _initialImageUrl;

  bool get isEditing => widget.stationId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _descriptionController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _operatingHoursController = TextEditingController(text: '24/7');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  void _populateForm(AdminStation station) {
    _nameController.text = station.name;
    _addressController.text = station.address;
    _descriptionController.text = station.description ?? '';
    _phoneController.text = station.phone ?? '';
    _emailController.text = station.email ?? '';
    _latitudeController.text = station.latitude.toString();
    _longitudeController.text = station.longitude.toString();
    _operatingHoursController.text = station.operatingHours ?? '24/7';
    _status = station.status;
    _initialImageUrl = station.imageUrl;
  }

  Future<void> _saveStation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate save
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.showSuccessSnackBar(
          isEditing
              ? 'Station updated successfully'
              : 'Station created successfully',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to save station: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StationsBloc, StationsState>(
        listener: (context, state) {
          if (state.selectedStation != null && isEditing) {
            _populateForm(state.selectedStation!);
          }
        },
        builder: (context, state) {
          if (state.isLoadingDetail && isEditing) {
            return const AdminLoadingPage(message: 'Loading station...');
          }

          return AdminPageContent(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  AdminPageHeader(
                    title: isEditing
                        ? AdminStrings.stationsEditTitle
                        : AdminStrings.stationsAddTitle,
                    breadcrumbs: [
                      AdminStrings.navStations,
                      if (isEditing) 'Edit' else 'Create',
                    ],
                    actions: [
                      AdminButton(
                        label: AdminStrings.actionCancel,
                        variant: AdminButtonVariant.outlined,
                        onPressed: () => context.pop(),
                      ),
                      AdminButton(
                        label: AdminStrings.actionSave,
                        icon: Iconsax.tick_circle,
                        isLoading: _isLoading,
                        onPressed: _saveStation,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Form content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main form
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _ImageCard(
                              imageFile: _imageFile,
                              imageUrl: _initialImageUrl,
                              onImagePicked: (file) {
                                setState(() {
                                  _imageFile = file;
                                  _initialImageUrl = null; // Clear URL when new file is picked
                                });
                              },
                              onImageRemoved: () {
                                setState(() {
                                  _imageFile = null;
                                  _initialImageUrl = null;
                                });
                              },
                            ),
                            SizedBox(height: 16.h),
                            _BasicInfoCard(
                              nameController: _nameController,
                              addressController: _addressController,
                              descriptionController: _descriptionController,
                            ),
                            SizedBox(height: 16.h),
                            _LocationCard(
                              latitudeController: _latitudeController,
                              longitudeController: _longitudeController,
                            ),
                            SizedBox(height: 16.h),
                            _ContactCard(
                              phoneController: _phoneController,
                              emailController: _emailController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      // Side panel
                      Expanded(
                        child: Column(
                          children: [
                            _StatusCard(
                              status: _status,
                              onStatusChanged: (status) {
                                if (status != null) {
                                  setState(() => _status = status);
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            _OperatingHoursCard(
                              controller: _operatingHoursController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.imageFile,
    required this.imageUrl,
    required this.onImagePicked,
    required this.onImageRemoved,
  });

  final File? imageFile;
  final String? imageUrl;
  final ValueChanged<File> onImagePicked;
  final VoidCallback onImageRemoved;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Station Image',
      child: AdminImagePicker(
        imageFile: imageFile,
        imageUrl: imageUrl,
        onImagePicked: onImagePicked,
        onImageRemoved: onImageRemoved,
        height: 240.h,
        helperText: 'Upload a high-quality image of the charging station (recommended: 1920x1080px)',
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  const _BasicInfoCard({
    required this.nameController,
    required this.addressController,
    required this.descriptionController,
  });

  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Basic Information',
      child: Column(
        children: [
          AdminTextField(
            controller: nameController,
            label: 'Station Name *',
            hint: 'Enter station name',
            prefixIcon: Iconsax.gas_station,
            validator: (value) =>
                AdminValidators.required(value, fieldName: 'Name'),
          ),
          SizedBox(height: 16.h),
          AdminTextField(
            controller: addressController,
            label: 'Address *',
            hint: 'Enter full address',
            prefixIcon: Iconsax.location,
            maxLines: 2,
            validator: (value) =>
                AdminValidators.required(value, fieldName: 'Address'),
          ),
          SizedBox(height: 16.h),
          AdminTextField(
            controller: descriptionController,
            label: 'Description',
            hint: 'Enter station description',
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.latitudeController,
    required this.longitudeController,
  });

  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Location',
      child: Row(
        children: [
          Expanded(
            child: AdminTextField(
              controller: latitudeController,
              label: 'Latitude *',
              hint: 'e.g., 34.0522',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) =>
                  AdminValidators.required(value, fieldName: 'Latitude'),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AdminTextField(
              controller: longitudeController,
              label: 'Longitude *',
              hint: 'e.g., -118.2437',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              validator: (value) =>
                  AdminValidators.required(value, fieldName: 'Longitude'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Contact Information',
      child: Row(
        children: [
          Expanded(
            child: AdminTextField(
              controller: phoneController,
              label: 'Phone',
              hint: '+1 555-0100',
              prefixIcon: Iconsax.call,
              keyboardType: TextInputType.phone,
              validator: AdminValidators.optional(AdminValidators.phone),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AdminTextField(
              controller: emailController,
              label: 'Email',
              hint: 'station@example.com',
              prefixIcon: Iconsax.sms,
              keyboardType: TextInputType.emailAddress,
              validator: AdminValidators.optional(AdminValidators.email),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.onStatusChanged});

  final AdminStationStatus status;
  final void Function(AdminStationStatus?) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Status',
      child: AdminDropdownField<AdminStationStatus>(
        value: status,
        items: AdminStationStatus.values,
        onChanged: onStatusChanged,
        itemBuilder: (status) => Row(
          children: [
            AdminStatusDot.fromType(_getStatusType(status)),
            SizedBox(width: 8.w),
            Text(status.name[0].toUpperCase() + status.name.substring(1)),
          ],
        ),
      ),
    );
  }

  AdminStatusType _getStatusType(AdminStationStatus status) {
    switch (status) {
      case AdminStationStatus.active:
        return AdminStatusType.active;
      case AdminStationStatus.inactive:
        return AdminStatusType.inactive;
      case AdminStationStatus.maintenance:
        return AdminStatusType.maintenance;
      case AdminStationStatus.pending:
        return AdminStatusType.pending;
    }
  }
}

class _OperatingHoursCard extends StatelessWidget {
  const _OperatingHoursCard({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: 'Operating Hours',
      child: AdminTextField(
        controller: controller,
        hint: 'e.g., 24/7 or 6:00 AM - 10:00 PM',
        prefixIcon: Iconsax.clock,
      ),
    );
  }
}
