/// File: lib/features/vehicle_add/presentation/view/vehicle_add_screen.dart
/// Purpose: Add/Edit vehicle screen
/// Belongs To: vehicle_add feature
/// Route: AppRoutes.addVehicle, AppRoutes.editVehicle
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../widgets/widgets.dart';
import '../../domain/entities/entities.dart';
import '../bloc/bloc.dart';
import '../viewmodel/viewmodel.dart';
import 'widgets/widgets.dart';

/// Add/Edit vehicle screen.
class VehicleAddScreen extends StatefulWidget {
  const VehicleAddScreen({
    required this.userId,
    this.vehicleId,
    super.key,
  });

  final String userId;
  final String? vehicleId; // If provided, edit mode

  @override
  State<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends State<VehicleAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nickNameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _batteryController = TextEditingController();
  final _licensePlateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize form if not already initialized
    final bloc = context.read<VehicleAddBloc>();
    final currentState = bloc.state;
    if (currentState is! VehicleAddInitial) {
      bloc.add(
        VehicleAddInitialized(widget.userId, vehicleId: widget.vehicleId),
      );
    }
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _batteryController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.vehicleId != null;

    return Scaffold(
      appBar: AppAppBar(
        title: isEditMode ? 'Edit Vehicle' : 'Add Vehicle',
      ),
      body: BlocConsumer<VehicleAddBloc, VehicleAddState>(
        listener: (context, state) {
          if (state is VehicleAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditMode
                      ? 'Vehicle updated successfully'
                      : 'Vehicle added successfully',
                ),
                backgroundColor: context.appColors.success,
              ),
            );
            Navigator.of(context).pop(state.vehicle);
          } else if (state is VehicleAddFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: context.appColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VehicleAddLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VehicleAddInitial) {
            _syncControllersWithForm(state.form);
            final viewModel = VehicleAddViewModel(state.form);

            return _buildForm(context, state, viewModel);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _syncControllersWithForm(VehicleForm form) {
    if (_nickNameController.text != form.nickName) {
      _nickNameController.text = form.nickName;
    }
    if (_makeController.text != form.make) {
      _makeController.text = form.make;
    }
    if (_modelController.text != form.model) {
      _modelController.text = form.model;
    }
    if (form.year != null &&
        _yearController.text != form.year.toString()) {
      _yearController.text = form.year.toString();
    }
    if (form.batteryCapacityKWh != null &&
        _batteryController.text != form.batteryCapacityKWh.toString()) {
      _batteryController.text = form.batteryCapacityKWh.toString();
    }
    if (_licensePlateController.text != form.licensePlate) {
      _licensePlateController.text = form.licensePlate;
    }
  }

  Widget _buildForm(
    BuildContext context,
    VehicleAddInitial state,
    VehicleAddViewModel viewModel,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Picker
                  VehicleImagePicker(
                    imageFile: state.form.imageFile,
                    imageUrl: state.form.imageUrl,
                    onImagePicked: (file) {
                      context.read<VehicleAddBloc>().add(
                            VehicleImagePicked(file),
                          );
                    },
                    onImageRemoved: () {
                      context.read<VehicleAddBloc>().add(
                            const VehicleImageRemoved(),
                          );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Nickname
                  VehicleFormField(
                    label: 'Nickname (Optional)',
                    errorText: state.fieldErrors['nickName'] != null
                        ? 'Invalid nickname'
                        : null,
                    child: CommonTextField(
                      controller: _nickNameController,
                      hint: 'e.g., Daily Driver',
                      maxLength: 40,
                      onChanged: (value) {
                        context.read<VehicleAddBloc>().add(
                              VehicleNickNameChanged(value),
                            );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Make
                  VehicleFormField(
                    label: 'Make *',
                    errorText: state.fieldErrors['make'] != null
                        ? 'Make is required'
                        : null,
                    child: CommonTextField(
                      controller: _makeController,
                      hint: 'e.g., Tesla',
                      onChanged: (value) {
                        context.read<VehicleAddBloc>().add(
                              VehicleMakeChanged(value),
                            );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Model
                  VehicleFormField(
                    label: 'Model *',
                    errorText: state.fieldErrors['model'] != null
                        ? 'Model is required'
                        : null,
                    child: CommonTextField(
                      controller: _modelController,
                      hint: 'e.g., Model 3',
                      onChanged: (value) {
                        context.read<VehicleAddBloc>().add(
                              VehicleModelChanged(value),
                            );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Year
                  VehicleFormField(
                    label: 'Year *',
                    errorText: state.fieldErrors['year'] != null
                        ? 'Invalid year'
                        : null,
                    child: CommonTextField(
                      controller: _yearController,
                      hint: 'e.g., 2023',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final year = int.tryParse(value);
                        if (year != null) {
                          context.read<VehicleAddBloc>().add(
                                VehicleYearChanged(year),
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Battery Capacity
                  VehicleFormField(
                    label: 'Battery Capacity (kWh) *',
                    errorText: state.fieldErrors['batteryCapacity'] != null
                        ? 'Invalid battery capacity'
                        : null,
                    child: CommonTextField(
                      controller: _batteryController,
                      hint: 'e.g., 75.0',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        final capacity = double.tryParse(value);
                        if (capacity != null) {
                          context.read<VehicleAddBloc>().add(
                                VehicleBatteryCapacityChanged(capacity),
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Vehicle Type
                  VehicleFormField(
                    label: 'Vehicle Type *',
                    child: DropdownButtonFormField<VehicleType>(
                      initialValue: state.form.vehicleType,
                      decoration: InputDecoration(
                        hintText: 'Select type',
                        filled: true,
                        fillColor: context.appColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: VehicleType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(viewModel.getVehicleTypeLabel(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<VehicleAddBloc>().add(
                                VehicleTypeChanged(value),
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // License Plate
                  VehicleFormField(
                    label: 'License Plate (Optional)',
                    errorText: state.fieldErrors['licensePlate'] != null
                        ? 'Invalid license plate'
                        : null,
                    child: CommonTextField(
                      controller: _licensePlateController,
                      hint: 'e.g., ABC123',
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) {
                        context.read<VehicleAddBloc>().add(
                              VehicleLicensePlateChanged(value),
                            );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Set as Default
                  SwitchListTile(
                    title: const Text('Set as Default Vehicle'),
                    value: state.form.isDefault,
                    onChanged: (value) {
                      context.read<VehicleAddBloc>().add(
                            VehicleIsDefaultChanged(value),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    label: AppStrings.cancel,
                    variant: ButtonVariant.outlined,
                    onPressed: () => context.pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: CommonButton(
                    label: AppStrings.save,
                    onPressed: () {
                      context.read<VehicleAddBloc>().add(
                            const VehicleSaveRequested(),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

