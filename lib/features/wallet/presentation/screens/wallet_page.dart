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

import '../../../../core/extensions/context_ext.dart';
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
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
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
                backgroundColor: colors.danger,
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
                      child: _buildCreditsPreview(context, state),
                    ),
                  ),

                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: colors.primary,
                      unselectedLabelColor: colors.textSecondary,
                      indicatorColor: colors.primary,
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
                  ),
                ),

                // Filter chips for transactions tab
                if (state.selectedTab == WalletTab.transactions)
                  SliverToBoxAdapter(child: _buildFilterChips(context, state)),

                // Content based on tab
                if (state.selectedTab == WalletTab.transactions)
                  _buildTransactionsList(context, state)
                else
                  _buildCreditsList(context, state),

                // Bottom padding
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.walletRecharge.path),
        backgroundColor: colors.primary,
        icon: Icon(Iconsax.add, color: colors.textPrimary, size: 20.r),
        label: Text(
          'Recharge',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsPreview(BuildContext context, WalletState state) {
    final colors = context.appColors;
    final summary = state.creditsSummary!;

    return GestureDetector(
      onTap: () => _tabController.animateTo(1),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.tertiary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.tertiary, colors.tertiaryContainer],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Iconsax.star, color: colors.surface, size: 20.r),
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
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Worth ${summary.formattedAvailableValue}',
                    style: TextStyle(fontSize: 12.sp, color: colors.tertiary),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3, color: colors.textTertiary, size: 20.r),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WalletState state) {
    final colors = context.appColors;

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
              backgroundColor: colors.surfaceVariant,
              selectedColor: colors.primaryContainer,
              checkmarkColor: colors.primary,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected ? colors.primary : colors.outline,
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

  Widget _buildTransactionsList(BuildContext context, WalletState state) {
    final transactions = state.filteredTransactions;

    if (transactions.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          context,
          icon: Iconsax.document_text,
          title: 'No transactions yet',
          subtitle: 'Your wallet transactions will appear here',
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

  Widget _buildCreditsList(BuildContext context, WalletState state) {
    final colors = context.appColors;

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
                color: colors.textPrimary,
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
        context,
        icon: Iconsax.star,
        title: 'No credits yet',
        subtitle: 'Start charging to earn credits',
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64.r, color: colors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

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
    final colors = context.appColors;

    return ColoredBox(color: colors.background, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
