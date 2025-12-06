/// File: lib/features/value_packs/presentation/screens/compare_packs_screen.dart
/// Purpose: Screen for comparing multiple value packs side-by-side
/// Belongs To: value_packs feature
/// Route: AppRoutes.comparePacks
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../domain/entities/value_pack.dart';
import '../widgets/widgets.dart';

/// Compare packs screen.
class ComparePacksScreen extends StatelessWidget {
  const ComparePacksScreen({
    required this.packIds,
    super.key,
  });

  final List<String> packIds;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    // TODO: Load packs from repository
    final packs = <ValuePack>[];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppAppBar(
        title: AppStrings.valuePackCompare,
      ),
      body: packs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.document,
                    size: 64.r,
                    color: colors.textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No packs to compare',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: _ComparisonTable(packs: packs),
            ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.packs});

  final List<ValuePack> packs;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    if (packs.length < 2) {
      return const SizedBox.shrink();
    }

    final attributes = [
      'Price',
      'Billing Cycle',
      'Features',
      'Rating',
      'Savings',
    ];

    return Table(
      border: TableBorder.all(
        color: colors.outline.withOpacity(0.2),
        width: 1,
      ),
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
          ),
          children: [
            _TableCell(
              child: Text(
                'Feature',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...packs.map(
              (pack) => _TableCell(
                child: Column(
                  children: [
                    Text(
                      pack.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (pack.badge != null) ...[
                      SizedBox(height: 4.h),
                      TagBadge(label: pack.badge!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        // Attribute rows
        ...attributes.map((attr) {
          return TableRow(
            children: [
              _TableCell(
                child: Text(
                  attr,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...packs.map((pack) {
                Widget content;
                switch (attr) {
                  case 'Price':
                    content = PriceBadge(
                      price: pack.price,
                      currency: pack.priceCurrency,
                      oldPrice: pack.oldPrice,
                      billingCycle: pack.billingCycle,
                    );
                    break;
                  case 'Billing Cycle':
                    content = Text(pack.billingCycleText);
                    break;
                  case 'Features':
                    content = Text('${pack.features.length} features');
                    break;
                  case 'Rating':
                    content = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.star1, size: 16.r, color: colors.warning),
                        SizedBox(width: 4.w),
                        Text(pack.rating.toStringAsFixed(1)),
                      ],
                    );
                    break;
                  case 'Savings':
                    content = pack.hasDiscount
                        ? Text('${pack.discountPercent.toStringAsFixed(0)}% OFF')
                        : const Text('-');
                    break;
                  default:
                    content = const Text('-');
                }
                return _TableCell(child: content);
              }),
            ],
          );
        }),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: child,
    );
  }
}

