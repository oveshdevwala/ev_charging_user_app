/// File: lib/admin/core/widgets/admin_search_bar.dart
/// Purpose: Search bar widget for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';

/// Admin search bar widget.
class AdminSearchBar extends StatefulWidget {
  const AdminSearchBar({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.width,
    this.showFilterButton = false,
    this.onFilterPressed,
    this.filterCount,
  });

  final TextEditingController? controller;
  final String hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final double? width;
  final bool showFilterButton;
  final VoidCallback? onFilterPressed;
  final int? filterCount;

  @override
  State<AdminSearchBar> createState() => _AdminSearchBarState();
}

class _AdminSearchBarState extends State<AdminSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return SizedBox(
      width: widget.width ?? 280.w,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Iconsax.search_normal_1,
                    size: 18.r,
                    color: colors.textSecondary,
                  ),
                  suffixIcon: _hasText
                      ? IconButton(
                          onPressed: _onClear,
                          icon: Icon(
                            Icons.close,
                            size: 18.r,
                            color: colors.textTertiary,
                          ),
                          visualDensity: VisualDensity.compact,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),
          ),
          if (widget.showFilterButton) ...[
            SizedBox(width: 8.w),
            Stack(
              children: [
                IconButton(
                  onPressed: widget.onFilterPressed,
                  icon: Icon(
                    Iconsax.filter,
                    size: 20.r,
                    color: colors.textSecondary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                if (widget.filterCount != null && widget.filterCount! > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.r,
                        minHeight: 16.r,
                      ),
                      child: Text(
                        '${widget.filterCount}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

