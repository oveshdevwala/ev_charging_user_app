/// File: lib/features/nearby_offers/presentation/screens/offer_redeem_screen.dart
/// Purpose: QR code redemption screen
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../blocs/offer_redeem/offer_redeem.dart';
import '../widgets/widgets.dart';

class OfferRedeemScreen extends StatelessWidget {
  const OfferRedeemScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OfferRedeemBloc(redeemOffer: sl(), analyticsService: sl())..add(
            RedeemOffer(offerId: offerId, userId: 'user_123'),
          ), // TODO: Real user ID
      child: const _OfferRedeemView(),
    );
  }
}

class _OfferRedeemView extends StatelessWidget {
  const _OfferRedeemView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Redeem Offer')),
      body: BlocBuilder<OfferRedeemBloc, OfferRedeemState>(
        builder: (context, state) {
          if (state.status == RedeemStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == RedeemStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Redemption failed'),
            );
          }

          if (state.redemption == null) {
            return const SizedBox.shrink();
          }

          final redemption = state.redemption!;

          return Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  redemption.offerTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  redemption.partnerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 32.h),
                RedeemQrWidget(redemption: redemption),
                SizedBox(height: 32.h),
                Text(
                  'Transaction ID: ${redemption.id.substring(0, 8)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
