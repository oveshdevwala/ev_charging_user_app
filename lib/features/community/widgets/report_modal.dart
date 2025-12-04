/// File: lib/features/community/widgets/report_modal.dart
/// Purpose: Report issue modal/bottom sheet
/// Belongs To: community feature
/// Customization Guide:
///    - Add new report categories as needed
///    - Customize confirmation flow
// ignore_for_file: avoid_positional_boolean_parameters

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Report modal widget.
class ReportModal extends StatefulWidget {
  const ReportModal({
    required this.targetType,
    required this.targetId,
    required this.onSubmit,
    super.key,
    this.onCancel,
  });

  final ReportTargetType targetType;
  final String targetId;
  final Future<ReportModel?> Function(
    ReportCategory category,
    String description,
    bool isAnonymous,
  )
  onSubmit;
  final VoidCallback? onCancel;

  /// Show the report modal as a bottom sheet.
  static Future<ReportModel?> show({
    required BuildContext context,
    required ReportTargetType targetType,
    required String targetId,
    required Future<ReportModel?> Function(
      ReportCategory category,
      String description,
      bool isAnonymous,
    )
    onSubmit,
  }) {
    return showModalBottomSheet<ReportModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportModal(
        targetType: targetType,
        targetId: targetId,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  ReportCategory? _selectedCategory;
  final _descriptionController = TextEditingController();
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  ReportModel? _submittedReport;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: _submittedReport != null
            ? _buildSuccessView()
            : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Row(
            children: [
              Icon(Iconsax.flag, size: 24.r, color: AppColors.error),
              SizedBox(width: 12.w),
              Text(
                'Report Issue',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Help us improve by reporting issues',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 24.h),

          // Category selector
          Text(
            'Select Issue Category',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _getCategories().map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = category);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outlineLight,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 16.r,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondaryLight,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _getCategoryLabel(category),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),

          // Description
          Text(
            'Description (optional)',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Provide more details about the issue...',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textTertiaryLight,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.outlineLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.outlineLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              contentPadding: EdgeInsets.all(14.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Anonymous toggle
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.user_square,
                  size: 20.r,
                  color: AppColors.textSecondaryLight,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report anonymously',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        'Your name will not be shown publicly',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() => _isAnonymous = value);
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedCategory == null || _isSubmitting
                  ? null
                  : _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                disabledBackgroundColor: AppColors.outlineLight,
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Submit Report',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 12.h),

          // Cancel button
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.tick_circle,
              size: 40.r,
              color: AppColors.success,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Report Submitted',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Thank you for your feedback. We'll review this and respond within 48 hours.",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (_submittedReport?.ticketId != null) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ticket ID: ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    _submittedReport!.ticketId!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_submittedReport),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ReportCategory> _getCategories() {
    if (widget.targetType == ReportTargetType.station) {
      return [
        ReportCategory.socketBroken,
        ReportCategory.slowCharging,
        ReportCategory.paymentFailed,
        ReportCategory.inaccurateInfo,
        ReportCategory.other,
      ];
    }
    return [
      ReportCategory.spam,
      ReportCategory.harassment,
      ReportCategory.inappropriate,
      ReportCategory.inaccurateInfo,
      ReportCategory.other,
    ];
  }

  IconData _getCategoryIcon(ReportCategory category) {
    switch (category) {
      case ReportCategory.socketBroken:
        return Iconsax.electricity;
      case ReportCategory.slowCharging:
        return Iconsax.timer_1;
      case ReportCategory.paymentFailed:
        return Iconsax.card_remove;
      case ReportCategory.inaccurateInfo:
        return Iconsax.info_circle;
      case ReportCategory.spam:
        return Iconsax.message_remove;
      case ReportCategory.harassment:
        return Iconsax.danger;
      case ReportCategory.inappropriate:
        return Iconsax.eye_slash;
      case ReportCategory.copyright:
        return Iconsax.copyright;
      case ReportCategory.other:
        return Iconsax.more;
    }
  }

  String _getCategoryLabel(ReportCategory category) {
    switch (category) {
      case ReportCategory.socketBroken:
        return 'Socket Broken';
      case ReportCategory.slowCharging:
        return 'Slow Charging';
      case ReportCategory.paymentFailed:
        return 'Payment Failed';
      case ReportCategory.inaccurateInfo:
        return 'Inaccurate Info';
      case ReportCategory.spam:
        return 'Spam';
      case ReportCategory.harassment:
        return 'Harassment';
      case ReportCategory.inappropriate:
        return 'Inappropriate';
      case ReportCategory.copyright:
        return 'Copyright';
      case ReportCategory.other:
        return 'Other';
    }
  }

  Future<void> _submitReport() async {
    if (_selectedCategory == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final report = await widget.onSubmit(
        _selectedCategory!,
        _descriptionController.text,
        _isAnonymous,
      );

      if (report != null) {
        setState(() {
          _submittedReport = report;
          _isSubmitting = false;
        });
      } else {
        setState(() => _isSubmitting = false);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit report: $e')));
      }
    }
  }
}
