/// File: lib/features/debug/value_packs_preview.dart
/// Purpose: Debug preview screen for value packs feature
/// Belongs To: debug feature
/// Customization Guide:
///    - Add more preview scenarios as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/di.dart';
import '../../core/extensions/context_ext.dart';
import '../../routes/app_routes.dart';
import '../value_packs/domain/usecases/usecases.dart';
import '../value_packs/presentation/cubits/cubits.dart';
import '../value_packs/presentation/screens/screens.dart';
import '../value_packs/presentation/widgets/widgets.dart';

/// Debug preview screen for value packs.
class ValuePacksPreviewScreen extends StatelessWidget {
  const ValuePacksPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Value Packs Preview'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          _PreviewSection(
            title: 'List Screen',
            child: BlocProvider(
              create: (context) => ValuePacksListCubit(sl<GetValuePacks>())
                ..load(),
              child: SizedBox(
                height: 600.h,
                child: const ValuePacksListScreen(),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _PreviewSection(
            title: 'Detail Screen',
            child: BlocProvider(
              create: (context) => ValuePackDetailCubit(
                sl<GetValuePackDetail>(),
                sl<GetValuePacks>(),
              )..load('pack_001'),
              child: SizedBox(
                height: 800.h,
                child: const ValuePackDetailScreen(packId: 'pack_001'),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _PreviewSection(
            title: 'Purchase Screen',
            child: SizedBox(
              height: 600.h,
              child: PurchaseScreen(packId: 'pack_001'),
            ),
          ),
          SizedBox(height: 24.h),
          _PreviewSection(
            title: 'Reviews Screen',
            child: SizedBox(
              height: 600.h,
              child: ReviewsScreen(packId: 'pack_001'),
            ),
          ),
          SizedBox(height: 24.h),
          _PreviewSection(
            title: 'Compare Packs',
            child: SizedBox(
              height: 400.h,
              child: ComparePacksScreen(packIds: ['pack_001', 'pack_002']),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.valuePacksList.path),
            child: const Text('Open Full List Screen'),
          ),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: child,
          ),
        ),
      ],
    );
  }
}


