/// File: lib/features/vehicle_add/presentation/view/vehicle_list_screen.dart
/// Purpose: Vehicle list screen
/// Belongs To: vehicle_add feature
/// Route: AppRoutes.vehicleList
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../widgets/widgets.dart';
import '../../domain/entities/entities.dart';
import '../bloc/bloc.dart';
import 'vehicle_add_screen.dart';

/// Vehicle list screen.
class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({required this.userId, super.key});

  final String userId;

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  void initState() {
    super.initState();
    // Load vehicles will be triggered by the route's BLoC provider
    // No need to manually trigger here as route creates BLoC with event
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'My Vehicles',
        actions: [
          Builder(
            builder: (buttonContext) {
              return IconButton(
                icon: Icon(Icons.add, size: 24.r),
                onPressed: () {
                  final bloc = buttonContext.read<VehicleAddBloc>();
                  Navigator.of(buttonContext).push(
                    MaterialPageRoute(
                      builder: (newContext) => BlocProvider.value(
                        value: bloc,
                        child: VehicleAddScreen(userId: widget.userId),
                      ),
                    ),
                  );
                },
                tooltip: 'Add Vehicle',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<VehicleAddBloc, VehicleAddState>(
        listener: (context, state) {
          if (state is VehicleAddFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: context.appColors.danger,
              ),
            );
          }
          // Refresh list when vehicle is added/updated/deleted
          if (state is VehicleAddSuccess) {
            context.read<VehicleAddBloc>().add(
              VehicleListRefreshRequested(widget.userId),
            );
          }
        },
        builder: (context, state) {
          if (state is VehicleListLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VehicleListLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: context.appColors.danger,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CommonButton(
                    label: AppStrings.retry,
                    onPressed: () {
                      context.read<VehicleAddBloc>().add(
                        VehicleListRefreshRequested(widget.userId),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (state is VehicleListLoadSuccess) {
            if (state.vehicles.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<VehicleAddBloc>().add(
                  VehicleListRefreshRequested(widget.userId),
                );
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = state.vehicles[index];
                  return _buildVehicleCard(context, vehicle);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Builder(
        builder: (fabContext) {
          return FloatingActionButton(
            onPressed: () {
              final bloc = fabContext.read<VehicleAddBloc>();
              Navigator.of(fabContext).push(
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: bloc,
                    child: VehicleAddScreen(userId: widget.userId),
                  ),
                ),
              );
            },
            child: Icon(Icons.add, size: 24.r),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 80.r,
            color: context.appColors.textTertiary,
          ),
          SizedBox(height: 24.h),
          Text(
            'No vehicles yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first vehicle to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: context.appColors.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          Builder(
            builder: (buttonContext) {
              return CommonButton(
                label: 'Add Vehicle',
                onPressed: () {
                  final bloc = buttonContext.read<VehicleAddBloc>();
                  Navigator.of(buttonContext).push(
                    MaterialPageRoute(
                      builder: (newContext) => BlocProvider.value(
                        value: bloc,
                        child: VehicleAddScreen(userId: widget.userId),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicle vehicle) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        leading: CircleAvatar(
          radius: 32.r,
          backgroundColor: context.appColors.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.directions_car,
            size: 32.r,
            color: context.appColors.primary,
          ),
        ),
        title: Text(
          vehicle.displayName,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(vehicle.fullName, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 4.h),
            Row(
              children: [
                if (vehicle.isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (vehicle.isDefault) SizedBox(width: 8.w),
                Text(
                  '${vehicle.batteryCapacityKWh} kWh',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (menuContext) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20.r),
                  SizedBox(width: 8.w),
                  const Text('Edit'),
                ],
              ),
              onTap: () {
                // Use post-frame callback to ensure context is valid
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final navigatorContext = Navigator.of(context).context;
                  if (navigatorContext.mounted) {
                    final bloc = navigatorContext.read<VehicleAddBloc>();
                    Navigator.of(navigatorContext).push(
                      MaterialPageRoute(
                        builder: (newContext) => BlocProvider.value(
                          value: bloc,
                          child: VehicleAddScreen(
                            userId: widget.userId,
                            vehicleId: vehicle.id,
                          ),
                        ),
                      ),
                    );
                  }
                });
              },
            ),
            if (!vehicle.isDefault)
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20.r),
                    SizedBox(width: 8.w),
                    const Text('Set as Default'),
                  ],
                ),
                onTap: () {
                  context.read<VehicleAddBloc>().add(
                    VehicleSetDefaultRequested(vehicle.id),
                  );
                },
              ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 20.r,
                    color: context.appColors.danger,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Delete',
                    style: TextStyle(color: context.appColors.danger),
                  ),
                ],
              ),
              onTap: () {
                _showDeleteDialog(context, vehicle);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Vehicle vehicle) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Vehicle?'),
        content: Text(
          'Are you sure you want to delete ${vehicle.displayName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<VehicleAddBloc>().add(
                VehicleDeleteRequested(vehicle.id),
              );
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: context.appColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
