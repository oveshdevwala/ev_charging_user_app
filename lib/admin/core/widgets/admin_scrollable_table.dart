/// File: lib/admin/core/widgets/admin_scrollable_table.dart
/// Purpose: Horizontal scrollable table wrapper with scroll controls
/// Belongs To: admin/core/widgets
/// Customization Guide:
///   - Wrap any table with this widget to enable horizontal scrolling
///   - Set minWidth to define minimum table width
///   - showScrollControls to toggle scroll buttons visibility
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';

/// A wrapper widget that provides horizontal scrolling for tables
/// with optional scroll controls (left/right arrows).
class AdminScrollableTable extends StatefulWidget {
  const AdminScrollableTable({
    required this.child,
    super.key,
    this.minWidth,
    this.showScrollControls = true,
    this.scrollControlSize = 36,
    this.scrollAmount = 200,
    this.borderRadius,
  });

  /// The table widget to be scrolled
  final Widget child;

  /// Minimum width for the scrollable content
  final double? minWidth;

  /// Whether to show scroll control buttons
  final bool showScrollControls;

  /// Size of scroll control buttons
  final double scrollControlSize;

  /// Amount to scroll when clicking controls
  final double scrollAmount;

  /// Border radius for the container
  final BorderRadius? borderRadius;

  @override
  State<AdminScrollableTable> createState() => _AdminScrollableTableState();
}

class _AdminScrollableTableState extends State<AdminScrollableTable> {
  late ScrollController _scrollController;
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollIndicators);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicators();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicators);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicators() {
    if (!mounted) return;

    final hasContent =
        _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0;

    setState(() {
      _showLeftArrow = hasContent && _scrollController.position.pixels > 0;
      _showRightArrow =
          hasContent &&
          _scrollController.position.pixels <
              _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - widget.scrollAmount).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + widget.scrollAmount).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final showControls =
        widget.showScrollControls && (_showLeftArrow || _showRightArrow);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          // Scrollable content
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: _isHovering,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: widget.minWidth ?? 800.w,
                  ),
                  child: IntrinsicWidth(child: widget.child),
                ),
              ),
            ),
          ),

          // Left scroll control
          if (showControls && _showLeftArrow)
            Positioned(
              left: 8.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ScrollControlButton(
                  icon: Iconsax.arrow_left_2,
                  size: widget.scrollControlSize,
                  onPressed: _scrollLeft,
                ),
              ),
            ),

          // Right scroll control
          if (showControls && _showRightArrow)
            Positioned(
              right: 8.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ScrollControlButton(
                  icon: Iconsax.arrow_right_3,
                  size: widget.scrollControlSize,
                  onPressed: _scrollRight,
                ),
              ),
            ),

          // Gradient fade on left
          if (showControls && _showLeftArrow)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.surface.withValues(alpha: 0.9),
                        colors.surface.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Gradient fade on right
          if (showControls && _showRightArrow)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        colors.surface.withValues(alpha: 0.9),
                        colors.surface.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Scroll control button widget
class _ScrollControlButton extends StatelessWidget {
  const _ScrollControlButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Material(
      color: colors.surface,
      elevation: 4,
      shadowColor: colors.shadow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size.r,
          height: size.r,
          alignment: Alignment.center,
          child: Icon(icon, size: (size * 0.5).r, color: colors.primary),
        ),
      ),
    );
  }
}

/// Extension to easily wrap any widget with scrollable table
extension AdminScrollableTableExt on Widget {
  Widget scrollable({
    double? minWidth,
    bool showScrollControls = true,
    double scrollControlSize = 36,
    double scrollAmount = 200,
  }) {
    return AdminScrollableTable(
      minWidth: minWidth,
      showScrollControls: showScrollControls,
      scrollControlSize: scrollControlSize,
      scrollAmount: scrollAmount,
      child: this,
    );
  }
}
