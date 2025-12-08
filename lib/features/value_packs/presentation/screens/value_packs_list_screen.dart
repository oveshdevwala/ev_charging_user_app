/// File: lib/features/value_packs/presentation/screens/value_packs_list_screen.dart
/// Purpose: Value packs list screen with filter, sort, and grid/list views
/// Belongs To: value_packs feature
/// Route: AppRoutes.valuePacksList
/// Customization Guide:
///    - Customize grid/list toggle behavior
///    - Add more filter options as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/loading_wrapper.dart';
import '../cubits/cubits.dart';
import '../widgets/widgets.dart';

/// Value packs list screen.
class ValuePacksListScreen extends StatelessWidget {
  const ValuePacksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ValuePacksListCubit>()..load(),
      child: const _ValuePacksListScreenView(),
    );
  }
}

class _ValuePacksListScreenView extends StatefulWidget {
  const _ValuePacksListScreenView();

  @override
  State<_ValuePacksListScreenView> createState() => _ValuePacksListScreenState();
}

class _ValuePacksListScreenState extends State<_ValuePacksListScreenView> {
  bool _isGridView = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ValuePacksListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppAppBar(
        title: AppStrings.valuePacks,
        actions: [
          // Grid/List toggle
          IconButton(
            icon: Icon(_isGridView ? Iconsax.menu : Iconsax.grid_1),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          // Filter button
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () => _showFilterDialog(context),
          ),
          // Sort button
          IconButton(
            icon: const Icon(Iconsax.sort),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ValuePacksListCubit, ValuePacksListState>(
        builder: (context, state) {
          if (state.isLoading && state.packs.isEmpty) {
            return const LoadingWrapper(isLoading: true, child: SizedBox.shrink());
          }

          if (state.hasError && state.packs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.danger,
                    size: 64.r,
                    color: context.colors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.error ?? 'An error occurred',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => context.read<ValuePacksListCubit>().load(),
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          if (state.packs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.box,
                    size: 64.r,
                    color: colors.textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No value packs available',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ValuePacksListCubit>().refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.r),
                  sliver: _isGridView
                      ? SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: context.isMobile ? 1 : 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final pack = state.packs[index];
                              return ValuePackCard(
                                pack: pack,
                                onTap: () => _onPackTap(context, pack.id),
                                onSave: () => context.read<ValuePacksListCubit>().toggleSelection(pack.id),
                                isSaved: state.selectedIds.contains(pack.id),
                              );
                            },
                            childCount: state.packs.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final pack = state.packs[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: ValuePackCard(
                                  pack: pack,
                                  onTap: () => _onPackTap(context, pack.id),
                                  onSave: () => context.read<ValuePacksListCubit>().toggleSelection(pack.id),
                                  isSaved: state.selectedIds.contains(pack.id),
                                  isCompact: true,
                                ),
                              );
                            },
                            childCount: state.packs.length,
                          ),
                        ),
                ),
                if (state.isLoading && state.packs.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onPackTap(BuildContext context, String packId) {
    context.pushToWithId(AppRoutes.valuePackDetail, packId);
  }

  void _showFilterDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.filter),
        content: const Text('Filter options coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.sort),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price: Low to High'),
              onTap: () {
                context.read<ValuePacksListCubit>().applySort('price_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Price: High to Low'),
              onTap: () {
                context.read<ValuePacksListCubit>().applySort('price_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Rating: Highest'),
              onTap: () {
                context.read<ValuePacksListCubit>().applySort('rating_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Most Popular'),
              onTap: () {
                context.read<ValuePacksListCubit>().applySort('popular');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

