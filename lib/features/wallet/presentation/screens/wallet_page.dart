/// File: lib/features/wallet/presentation/screens/wallet_page.dart
/// Purpose: Main wallet screen with balance, transactions, and credits tabs
/// Belongs To: wallet feature
/// Route: /wallet
/// Customization Guide:
///    - Modify tab layout and content
///    - Add additional sections or tabs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../data/repositories/wallet_repository.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

/// Main wallet page showing balance, transactions, and credits.
///
/// Features:
/// - Large glassmorphism balance card
/// - Tab bar for Transactions/Credits
/// - Pull-to-refresh
/// - Floating recharge button
/// - Filter options for transactions
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WalletBloc(walletRepository: DummyWalletRepository())
            ..add(const LoadWalletData()),
      child: const _WalletPageContent(),
    );
  }
}

class _WalletPageContent extends StatefulWidget {
  const _WalletPageContent();

  @override
  State<_WalletPageContent> createState() => _WalletPageContentState();
}

class _WalletPageContentState extends State<_WalletPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<WalletBloc>().add(
        ChangeWalletTab(
          _tabController.index == 0
              ? WalletTab.transactions
              : WalletTab.credits,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppAppBar(
        title: 'Wallet',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.setting_2, size: 22.r),
          ),
        ],
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ),
            );
            context.read<WalletBloc>().add(const ClearWalletError());
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WalletBloc>().add(const RefreshWalletData());
              await Future<void>.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                // Balance Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: state.balance != null
                        ? WalletBalanceCard(
                            balance: state.balance!,
                            onRecharge: () =>
                                context.push(AppRoutes.walletRecharge.path),
                            onViewHistory: () {
                              _tabController.animateTo(0);
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // Credits Summary (compact)
                if (state.creditsSummary != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildCreditsPreview(state, isDark),
                    ),
                  ),

                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Transactions'),
                        Tab(text: 'Credits'),
                      ],
                    ),
                    isDark: isDark,
                  ),
                ),

                // Filter chips for transactions tab
                if (state.selectedTab == WalletTab.transactions)
                  SliverToBoxAdapter(child: _buildFilterChips(state, isDark)),

                // Content based on tab
                if (state.selectedTab == WalletTab.transactions)
                  _buildTransactionsList(state, isDark)
                else
                  _buildCreditsList(state, isDark),

                // Bottom padding
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.walletRecharge.path),
        backgroundColor: AppColors.primary,
        icon: Icon(Iconsax.add, color: Colors.white, size: 20.r),
        label: Text(
          'Recharge',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsPreview(WalletState state, bool isDark) {
    final summary = state.creditsSummary!;

    return GestureDetector(
      onTap: () => _tabController.animateTo(1),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.tertiary, AppColors.tertiaryDark],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Iconsax.star, color: Colors.white, size: 20.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${summary.availableCredits} Credits Available',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    'Worth ${summary.formattedAvailableValue}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(WalletState state, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: TransactionFilter.values.map((filter) {
          final isSelected = state.transactionFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(_getFilterLabel(filter)),
              selected: isSelected,
              onSelected: (_) {
                context.read<WalletBloc>().add(ChangeTransactionFilter(filter));
              },
              backgroundColor: isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceLight,
              selectedColor: AppColors.primaryContainer,
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.outlineDark : AppColors.outlineLight),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getFilterLabel(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return 'All';
      case TransactionFilter.credits:
        return 'Money In';
      case TransactionFilter.debits:
        return 'Money Out';
      case TransactionFilter.cashback:
        return 'Cashback';
      case TransactionFilter.recharge:
        return 'Recharge';
    }
  }

  Widget _buildTransactionsList(WalletState state, bool isDark) {
    final transactions = state.filteredTransactions;

    if (transactions.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          icon: Iconsax.document_text,
          title: 'No transactions yet',
          subtitle: 'Your wallet transactions will appear here',
          isDark: isDark,
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= transactions.length) {
              // Load more indicator
              if (state.hasMoreTransactions) {
                context.read<WalletBloc>().add(const LoadMoreTransactions());
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return null;
            }

            return TransactionTile(
              transaction: transactions[index],
              showDivider: index < transactions.length - 1,
              onTap: () {
                // TODO: Navigate to transaction details
              },
            );
          },
          childCount: transactions.length + (state.hasMoreTransactions ? 1 : 0),
        ),
      ),
    );
  }

  Widget _buildCreditsList(WalletState state, bool isDark) {
    if (state.creditsSummary != null) {
      return SliverPadding(
        padding: EdgeInsets.all(16.r),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            CreditsSummaryCard(summary: state.creditsSummary!),
            SizedBox(height: 20.h),
            Text(
              'Credits History',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 12.h),
            CreditsTimeline(entries: state.creditsHistory),
          ]),
        ),
      );
    }

    return SliverFillRemaining(
      child: _buildEmptyState(
        icon: Iconsax.star,
        title: 'No credits yet',
        subtitle: 'Start charging to earn credits',
        isDark: isDark,
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.r,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {required this.isDark});

  final TabBar tabBar;
  final bool isDark;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
