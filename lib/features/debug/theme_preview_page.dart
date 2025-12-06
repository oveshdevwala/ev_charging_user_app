/// File: lib/features/debug/theme_preview_page.dart
/// Purpose: Theme preview screen for testing light/dark mode and all color tokens
/// Belongs To: debug feature
/// Route: /debug/theme_preview
/// Customization Guide:
///    - Use this screen to verify theme consistency
///    - Toggle between light/dark/system modes
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_colors.dart' as static_colors;
import '../../core/theme/app_theme_extensions.dart';

/// Theme preview page for testing all theme components.
class ThemePreviewPage extends StatefulWidget {
  const ThemePreviewPage({super.key});

  @override
  State<ThemePreviewPage> createState() => _ThemePreviewPageState();
}

class _ThemePreviewPageState extends State<ThemePreviewPage> {
  ThemeMode _selectedMode = ThemeMode.system;
  double _sliderValue = 0.5;
  bool _switchValue = false;
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preview'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Iconsax.sun_1 : Iconsax.moon),
            onPressed: () {
              setState(() {
                _selectedMode = isDark ? ThemeMode.light : ThemeMode.dark;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme mode selector
            _buildSectionTitle(colors, 'Theme Mode'),
            _buildThemeModeSelector(),
            SizedBox(height: 24.h),

            // Color palette
            _buildSectionTitle(colors, 'Color Palette'),
            _buildColorPalette(colors),
            SizedBox(height: 24.h),

            // Text styles
            _buildSectionTitle(colors, 'Typography'),
            _buildTypographyPreview(colors),
            SizedBox(height: 24.h),

            // Buttons
            _buildSectionTitle(colors, 'Buttons'),
            _buildButtonsPreview(),
            SizedBox(height: 24.h),

            // Cards
            _buildSectionTitle(colors, 'Cards'),
            _buildCardsPreview(colors),
            SizedBox(height: 24.h),

            // Form fields
            _buildSectionTitle(colors, 'Form Fields'),
            _buildFormFieldsPreview(colors),
            SizedBox(height: 24.h),

            // Chips
            _buildSectionTitle(colors, 'Chips'),
            _buildChipsPreview(),
            SizedBox(height: 24.h),

            // Progress indicators
            _buildSectionTitle(colors, 'Progress Indicators'),
            _buildProgressPreview(colors),
            SizedBox(height: 24.h),

            // Toggles and checkboxes
            _buildSectionTitle(colors, 'Toggles & Checkboxes'),
            _buildTogglesPreview(),
            SizedBox(height: 24.h),

            // Slider
            _buildSectionTitle(colors, 'Slider'),
            _buildSliderPreview(),
            SizedBox(height: 24.h),

            // Status colors
            _buildSectionTitle(colors, 'Status Colors'),
            _buildStatusColorsPreview(colors),
            SizedBox(height: 24.h),

            // Bottom sheet preview
            _buildSectionTitle(colors, 'Bottom Sheet'),
            _buildBottomSheetPreview(context, colors),
            SizedBox(height: 24.h),

            // Snackbar preview
            _buildSectionTitle(colors, 'Snackbar'),
            _buildSnackbarPreview(context),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(AppColors colors, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector() {
    return Row(
      children: [
        _buildModeChip('System', ThemeMode.system, Iconsax.mobile),
        SizedBox(width: 8.w),
        _buildModeChip('Light', ThemeMode.light, Iconsax.sun_1),
        SizedBox(width: 8.w),
        _buildModeChip('Dark', ThemeMode.dark, Iconsax.moon),
      ],
    );
  }

  Widget _buildModeChip(String label, ThemeMode mode, IconData icon) {
    final isSelected = _selectedMode == mode;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r),
          SizedBox(width: 4.w),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedMode = mode;
        });
      },
    );
  }

  Widget _buildColorPalette(AppColors colors) {
    return Column(
      children: [
        Row(
          children: [
            _buildColorBox('Background', colors.background, colors),
            _buildColorBox('Surface', colors.surface, colors),
            _buildColorBox('Surface Var', colors.surfaceVariant, colors),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildColorBox('Primary', colors.primary, colors),
            _buildColorBox('Primary Cnt', colors.primaryContainer, colors),
            _buildColorBox('Secondary', colors.secondary, colors),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildColorBox('Success', colors.success, colors),
            _buildColorBox('Danger', colors.danger, colors),
            _buildColorBox('Warning', colors.warning, colors),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildColorBox('Text Pri', colors.textPrimary, colors),
            _buildColorBox('Text Sec', colors.textSecondary, colors),
            _buildColorBox('Outline', colors.outline, colors),
          ],
        ),
      ],
    );
  }

  Widget _buildColorBox(String label, Color color, AppColors colors) {
    final isDark = color.computeLuminance() < 0.5;

    return Expanded(
      child: Container(
        height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colors.outline),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTypographyPreview(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Large',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        Text(
          'Headline Medium',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        Text(
          'Title Large',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        Text(
          'Body Large - Primary text color',
          style: TextStyle(fontSize: 16.sp, color: colors.textPrimary),
        ),
        Text(
          'Body Medium - Secondary text color',
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        ),
        Text(
          'Body Small - Tertiary text color',
          style: TextStyle(fontSize: 12.sp, color: colors.textTertiary),
        ),
        Text(
          'Caption - Disabled text color',
          style: TextStyle(fontSize: 11.sp, color: colors.textDisabled),
        ),
      ],
    );
  }

  Widget _buildButtonsPreview() {
    return Column(
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
        SizedBox(height: 8.h),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
        SizedBox(height: 8.h),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        SizedBox(height: 8.h),
        Row(
          children: [
            const Expanded(
              child: ElevatedButton(onPressed: null, child: Text('Disabled')),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Iconsax.flash_1, size: 18.r),
                label: const Text('With Icon'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsPreview(AppColors colors) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Standard Card',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "This is a standard card with the theme's surface color and border.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Iconsax.flash_1, color: colors.primary, size: 24.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surface Variant Card',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'With primary container icon',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldsPreview(AppColors colors) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Label',
            hintText: 'Enter text...',
            prefixIcon: Icon(Iconsax.user),
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          decoration: InputDecoration(
            labelText: 'Error State',
            errorText: 'This field has an error',
            prefixIcon: const Icon(Iconsax.warning_2),
            suffixIcon: Icon(Iconsax.close_circle, color: colors.danger),
          ),
        ),
        SizedBox(height: 12.h),
        const TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Disabled Field',
            hintText: 'Cannot edit',
          ),
        ),
      ],
    );
  }

  Widget _buildChipsPreview() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        const Chip(label: Text('Default Chip')),
        Chip(
          avatar: Icon(Iconsax.flash_1, size: 16.r),
          label: const Text('With Icon'),
        ),
        const FilterChip(
          selected: true,
          label: Text('Selected'),
          onSelected: null,
        ),
        const FilterChip(label: Text('Unselected'), onSelected: null),
        const InputChip(label: Text('Input Chip')),
      ],
    );
  }

  Widget _buildProgressPreview(AppColors colors) {
    return Column(
      children: [
        Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: 16.w),
            CircularProgressIndicator(
              value: 0.7,
              backgroundColor: colors.outline,
            ),
            SizedBox(width: 16.w),
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        const LinearProgressIndicator(),
        SizedBox(height: 8.h),
        LinearProgressIndicator(value: 0.6, backgroundColor: colors.outline),
      ],
    );
  }

  Widget _buildTogglesPreview() {
    return Row(
      children: [
        Switch(
          value: _switchValue,
          onChanged: (value) => setState(() => _switchValue = value),
        ),
        SizedBox(width: 16.w),
        Checkbox(
          value: _checkboxValue,
          onChanged: (value) => setState(() => _checkboxValue = value ?? false),
        ),
        SizedBox(width: 16.w),
        Radio<bool>(
          value: true,
          groupValue: _switchValue,
          onChanged: (value) => setState(() => _switchValue = value ?? false),
        ),
        Radio<bool>(
          value: false,
          groupValue: _switchValue,
          onChanged: (value) => setState(() => _switchValue = value ?? true),
        ),
      ],
    );
  }

  Widget _buildSliderPreview() {
    return Slider(
      value: _sliderValue,
      onChanged: (value) => setState(() => _sliderValue = value),
    );
  }

  Widget _buildStatusColorsPreview(AppColors colors) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.successContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.tick_circle, color: colors.success, size: 18.r),
                SizedBox(width: 4.w),
                Text(
                  'Success',
                  style: TextStyle(
                    color: colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.dangerContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.close_circle, color: colors.danger, size: 18.r),
                SizedBox(width: 4.w),
                Text(
                  'Error',
                  style: TextStyle(
                    color: colors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.warningContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.warning_2, color: colors.warning, size: 18.r),
                SizedBox(width: 4.w),
                Text(
                  'Warning',
                  style: TextStyle(
                    color: colors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetPreview(BuildContext context, AppColors colors) {
    final colors = context.appColors;
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (ctx) => Container(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bottom Sheet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "This is a bottom sheet with the theme's surface color.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
      child: const Text('Show Bottom Sheet'),
    );
  }

  Widget _buildSnackbarPreview(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Default snackbar message')),
              );
            },
            child: const Text('Default'),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.showSuccessSnackBar('Success message');
            },
            child: const Text('Success'),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.showErrorSnackBar('Error message');
            },
            child: const Text('Error'),
          ),
        ),
      ],
    );
  }
}
