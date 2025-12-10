/// File: lib/admin/features/offers/views/offer_detail_page.dart
/// Purpose: Offer detail screen with edit/delete/activate actions
/// Belongs To: admin/features/offers
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/offer_detail_bloc.dart';
import '../bloc/offer_detail_event.dart';
import '../bloc/offer_detail_state.dart';
import '../models/offer_model.dart';

/// Offer detail page shown in modal.
class OfferDetailPage extends StatelessWidget {
  const OfferDetailPage({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfferDetailBloc, OfferDetailState>(
      listener: (context, state) {
        if (state.error != null && state.status == OfferDetailStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage ?? '')));
          // Close modal on successful delete
          if (state.successMessage!.contains('deleted')) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.offer == null) {
          return SizedBox(
            height: 400.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == OfferDetailStatus.error && state.offer == null) {
          return AdminPageContent(
            child: AdminEmptyState(
              title: AdminStrings.offersDetailTitle,
              message: state.error,
              actionLabel: AdminStrings.actionRefresh,
              onAction: () =>
                  context.read<OfferDetailBloc>().add(LoadOfferDetail(offerId)),
            ),
          );
        }

        if (state.offer == null) {
          return const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final offer = state.offer!;
        final colors = context.adminColors;

        return AdminPageContent(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offer Summary Card
                AdminCard(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.title,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                if (offer.code != null)
                                  Text(
                                    'Code: ${offer.code}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          AdminStatusBadge(
                            label: _getStatusLabel(offer.status),
                            type: _getStatusType(offer.status),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.offersDiscountValue,
                              value: offer.formattedDiscount,
                              color: colors.success,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.offersCurrentUsesLabel,
                              value:
                                  '${offer.currentUses}${offer.maxUses != null ? '/${offer.maxUses}' : ''}',
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.offersDaysLeft,
                              value: '${offer.daysUntilExpiry}',
                              color: offer.daysUntilExpiry < 7
                                  ? colors.error
                                  : colors.info,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          AdminButton(
                            label: AdminStrings.actionEdit,
                            icon: Iconsax.edit,
                            onPressed: state.isProcessing
                                ? null
                                : () {
                                    // TODO: Open edit modal
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Edit feature coming soon',
                                        ),
                                      ),
                                    );
                                  },
                            isLoading: state.isProcessing,
                          ),
                          AdminButton(
                            label: offer.status == OfferStatus.active
                                ? AdminStrings.actionDeactivate
                                : AdminStrings.actionActivate,
                            icon: offer.status == OfferStatus.active
                                ? Iconsax.close_circle
                                : Iconsax.tick_circle,
                            variant: AdminButtonVariant.outlined,
                            onPressed: state.isProcessing
                                ? null
                                : () => _showActivateDialog(context, offer),
                            isLoading: state.isProcessing,
                          ),
                          AdminButton(
                            label: AdminStrings.actionDelete,
                            icon: Iconsax.trash,
                            variant: AdminButtonVariant.outlined,
                            onPressed: state.isProcessing
                                ? null
                                : () => _showDeleteDialog(context),
                            isLoading: state.isProcessing,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Offer Details Card
                AdminCard(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offer Details',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _DetailRow(
                        label: AdminStrings.labelDescription,
                        value: offer.description ?? 'No description',
                      ),
                      SizedBox(height: 12.h),
                      _DetailRow(
                        label: AdminStrings.offersDiscountType,
                        value: offer.discountType.name.toUpperCase(),
                      ),
                      SizedBox(height: 12.h),
                      _DetailRow(
                        label: AdminStrings.offersValidFrom,
                        value: DateFormat.yMMMd().add_jm().format(
                          offer.validFrom,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _DetailRow(
                        label: AdminStrings.offersValidUntil,
                        value: DateFormat.yMMMd().add_jm().format(
                          offer.validUntil,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (offer.minPurchaseAmount != null)
                        _DetailRow(
                          label: AdminStrings.offersMinPurchaseLabel,
                          value:
                              '\$${offer.minPurchaseAmount!.toStringAsFixed(2)}',
                        ),
                      if (offer.minPurchaseAmount != null)
                        SizedBox(height: 12.h),
                      _DetailRow(
                        label: AdminStrings.labelCreatedAt,
                        value: DateFormat.yMMMd().add_jm().format(
                          offer.createdAt,
                        ),
                      ),
                      if (offer.createdBy != null) ...[
                        SizedBox(height: 12.h),
                        _DetailRow(
                          label: AdminStrings.offersCreatedByLabel,
                          value: offer.createdBy!,
                        ),
                      ],
                      if (offer.applicableStations.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        _DetailRow(
                          label: AdminStrings.offersApplicableStationsLabel,
                          value: '${offer.applicableStations.length} stations',
                        ),
                      ],
                      if (offer.termsAndConditions != null) ...[
                        SizedBox(height: 12.h),
                        _DetailRow(
                          label: AdminStrings.offersTermsLabel,
                          value: offer.termsAndConditions!,
                          isMultiline: true,
                        ),
                      ],
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

  String _getStatusLabel(OfferStatus status) {
    switch (status) {
      case OfferStatus.active:
        return AdminStrings.statusActive;
      case OfferStatus.inactive:
        return AdminStrings.statusInactive;
      case OfferStatus.scheduled:
        return AdminStrings.statusPending;
      case OfferStatus.expired:
        return AdminStrings.statusCompleted;
    }
  }

  AdminStatusType _getStatusType(OfferStatus status) {
    switch (status) {
      case OfferStatus.active:
        return AdminStatusType.success;
      case OfferStatus.inactive:
        return AdminStatusType.warning;
      case OfferStatus.scheduled:
        return AdminStatusType.info;
      case OfferStatus.expired:
        return AdminStatusType.error;
    }
  }

  void _showActivateDialog(BuildContext context, OfferModel offer) {
    final isActivating = offer.status != OfferStatus.active;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isActivating
              ? AdminStrings.actionActivate
              : AdminStrings.actionDeactivate,
        ),
        content: Text(
          isActivating
              ? 'Are you sure you want to activate this offer?'
              : 'Are you sure you want to deactivate this offer?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AdminStrings.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<OfferDetailBloc>().add(
                isActivating
                    ? ActivateOffer(offer.id)
                    : DeactivateOffer(offer.id),
              );
            },
            child: Text(
              isActivating
                  ? AdminStrings.actionActivate
                  : AdminStrings.actionDeactivate,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AdminStrings.actionDelete),
        content: const Text(AdminStrings.msgConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AdminStrings.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<OfferDetailBloc>().add(DeleteOffer(offerId));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AdminStrings.actionDelete),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: context.adminColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isMultiline = false,
  });

  final String label;
  final String value;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12.sp, color: colors.textPrimary),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? null : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
