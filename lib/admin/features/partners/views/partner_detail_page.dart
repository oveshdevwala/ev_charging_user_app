/// File: lib/admin/features/partners/views/partner_detail_page.dart
/// Purpose: Partner detail screen shown in modal
/// Belongs To: admin/features/partners
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';

/// Partner detail page shown in modal.
class PartnerDetailPage extends StatelessWidget {
  const PartnerDetailPage({required this.partnerId, super.key});

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnerDetailBloc, PartnerDetailState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage ?? '')));
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.partner == null) {
          return SizedBox(
            height: 400.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.partner == null) {
          return AdminPageContent(
            child: AdminEmptyState(
              title: AdminStrings.partnersDetailTitle,
              message: state.error ?? 'Partner not found',
              actionLabel: AdminStrings.actionRefresh,
              onAction: () => context.read<PartnerDetailBloc>().add(
                LoadPartnerDetail(partnerId),
              ),
            ),
          );
        }

        final partner = state.partner!;
        final colors = context.adminColors;

        return AdminPageContent(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Partner Summary Card
                AdminCard(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      // Logo
                      if (partner.logoUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedNetworkImage(
                            imageUrl: partner.logoUrl!,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 80.w,
                              height: 80.h,
                              color: colors.surfaceVariant,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80.w,
                              height: 80.h,
                              color: colors.surfaceVariant,
                              child: Icon(
                                Iconsax.building,
                                size: 40.r,
                                color: colors.textTertiary,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Iconsax.building,
                            size: 40.r,
                            color: colors.textTertiary,
                          ),
                        ),
                      SizedBox(width: 16.w),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              partner.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                AdminStatusBadge(
                                  label: partner.statusName,
                                  type: _getStatusType(partner.status),
                                ),
                                SizedBox(width: 8.w),
                                AdminStatusBadge(
                                  label: partner.typeName,
                                  type: AdminStatusType.info,
                                ),
                                SizedBox(width: 8.w),
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.star1,
                                      size: 16.r,
                                      color: colors.warning,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      partner.formattedRating,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Actions
                      Column(
                        children: [
                          if (partner.status == PartnerStatus.pending) ...[
                            AdminButton(
                              label: AdminStrings.partnersApprove,
                              icon: Iconsax.tick_circle,
                              size: AdminButtonSize.small,
                              onPressed: state.isApproving
                                  ? null
                                  : () => context.read<PartnerDetailBloc>().add(
                                      ApprovePartner(partnerId),
                                    ),
                              isLoading: state.isApproving,
                            ),
                            SizedBox(height: 8.h),
                            AdminButton(
                              label: AdminStrings.partnersReject,
                              icon: Iconsax.close_circle,
                              size: AdminButtonSize.small,
                              variant: AdminButtonVariant.outlined,
                              onPressed: state.isRejecting
                                  ? null
                                  : () {
                                      // TODO: Show reason dialog
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Reject feature coming soon',
                                          ),
                                        ),
                                      );
                                    },
                              isLoading: state.isRejecting,
                            ),
                          ],
                          if (partner.status == PartnerStatus.active) ...[
                            AdminButton(
                              label: AdminStrings.partnersSuspend,
                              icon: Iconsax.pause_circle,
                              size: AdminButtonSize.small,
                              variant: AdminButtonVariant.outlined,
                              onPressed: state.isSuspending
                                  ? null
                                  : () => context.read<PartnerDetailBloc>().add(
                                      SuspendPartner(partnerId),
                                    ),
                              isLoading: state.isSuspending,
                            ),
                          ],
                          if (partner.status == PartnerStatus.suspended) ...[
                            AdminButton(
                              label: AdminStrings.partnersActivate,
                              icon: Iconsax.play_circle,
                              size: AdminButtonSize.small,
                              onPressed: state.isActivating
                                  ? null
                                  : () => context.read<PartnerDetailBloc>().add(
                                      ActivatePartner(partnerId),
                                    ),
                              isLoading: state.isActivating,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Details Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AdminCard(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersEmailLabel,
                              partner.email,
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersPhoneLabel,
                              partner.phone,
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersCountryLabel,
                              partner.country,
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersPrimaryContactLabel,
                              partner.primaryContact,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AdminCard(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Metadata',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersCreatedAtLabel,
                              DateFormat(
                                'MMM dd, yyyy HH:mm',
                              ).format(partner.createdAt),
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              context,
                              AdminStrings.partnersUpdatedAtLabel,
                              DateFormat(
                                'MMM dd, yyyy HH:mm',
                              ).format(partner.updatedAt),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Contracts Section
                AdminCard(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AdminStrings.partnersContracts,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          AdminButton(
                            label: AdminStrings.partnersAddContract,
                            icon: Iconsax.add,
                            size: AdminButtonSize.small,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Add contract feature coming soon',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (state.contracts.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.h),
                            child: Text(
                              AdminStrings.partnersNoContracts,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.contracts.map(
                          (contract) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: ListTile(
                              title: Text(contract.title),
                              subtitle: Text(
                                '${contract.formattedAmount} • ${contract.statusName}',
                              ),
                              trailing: Text(
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(contract.startDate),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Locations Section
                AdminCard(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AdminStrings.partnersLocations,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          AdminButton(
                            label: AdminStrings.partnersManageLocations,
                            icon: Iconsax.location,
                            size: AdminButtonSize.small,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Manage locations feature coming soon',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (state.locations.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.h),
                            child: Text(
                              AdminStrings.partnersNoLocations,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.locations.map(
                          (location) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: ListTile(
                              leading: Icon(
                                Iconsax.location,
                                color: colors.primary,
                              ),
                              title: Text(location.label),
                              subtitle: Text(location.fullAddress),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final colors = context.adminColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  AdminStatusType _getStatusType(PartnerStatus status) {
    switch (status) {
      case PartnerStatus.active:
        return AdminStatusType.success;
      case PartnerStatus.pending:
        return AdminStatusType.pending;
      case PartnerStatus.suspended:
        return AdminStatusType.error;
      case PartnerStatus.rejected:
        return AdminStatusType.rejected;
    }
  }
}
