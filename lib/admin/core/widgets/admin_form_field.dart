/// File: lib/admin/core/widgets/admin_form_field.dart
/// Purpose: Reusable form field widgets for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';

/// Admin text field widget.
class AdminTextField extends StatelessWidget {
  const AdminTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          autofocus: autofocus,
          focusNode: focusNode,
          style: TextStyle(
            fontSize: 14.sp,
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20.r, color: colors.textSecondary)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(suffixIcon, size: 20.r, color: colors.textSecondary),
                  )
                : null,
          ),
        ),
        if (helperText != null && errorText == null) ...[
          SizedBox(height: 4.h),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Admin dropdown field widget.
class AdminDropdownField<T> extends StatelessWidget {
  const AdminDropdownField({
    required this.items,
    super.key,
    this.value,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.itemBuilder,
    this.prefixIcon,
  });

  final T? value;
  final List<T> items;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final void Function(T?)? onChanged;
  final bool enabled;
  final Widget Function(T item)? itemBuilder;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder?.call(item) ?? Text(item.toString()),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20.r, color: colors.textSecondary)
                : null,
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: colors.textPrimary,
          ),
          dropdownColor: colors.surface,
        ),
        if (helperText != null && errorText == null) ...[
          SizedBox(height: 4.h),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Admin search field widget.
class AdminSearchField extends StatelessWidget {
  const AdminSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: 14.sp,
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Iconsax.search_normal_1,
          size: 20.r,
          color: colors.textSecondary,
        ),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
                icon: Icon(
                  Iconsax.close_circle,
                  size: 20.r,
                  color: colors.textTertiary,
                ),
              )
            : null,
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }
}

/// Admin date picker field.
class AdminDateField extends StatelessWidget {
  const AdminDateField({
    super.key,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  final DateTime? value;
  final String? label;
  final String? hint;
  final void Function(DateTime?)? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        InkWell(
          onTap: enabled
              ? () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(2000),
                    lastDate: lastDate ?? DateTime(2100),
                  );
                  onChanged?.call(date);
                }
              : null,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.calendar_1,
                  size: 20.r,
                  color: colors.textSecondary,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    value != null
                        ? '${value!.day}/${value!.month}/${value!.year}'
                        : hint ?? 'Select date',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value != null ? colors.textPrimary : colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

