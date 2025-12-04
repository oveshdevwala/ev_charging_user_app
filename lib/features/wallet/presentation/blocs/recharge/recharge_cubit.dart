/// File: lib/features/wallet/presentation/blocs/recharge/recharge_cubit.dart
/// Purpose: Recharge wallet Cubit for managing recharge flow
/// Belongs To: wallet feature
/// 
/// ## Flow Diagram:
/// ```
/// Select Amount -> Apply Promo (optional) -> Select Payment -> Process -> Success
/// ```
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/wallet_repository.dart';
import 'recharge_state.dart';

/// Recharge Cubit managing wallet recharge operations.
/// 
/// ## Responsibilities:
/// - Handle amount selection
/// - Apply and validate promo codes
/// - Process payment
/// - Update wallet balance on success
class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(RechargeState.initial());

  final WalletRepository _walletRepository;

  /// Predefined quick amounts
  static const List<double> quickAmounts = [10, 25, 50, 100, 200, 500];

  /// Load available promo codes
  Future<void> loadPromoCodes() async {
    emit(state.copyWith(isLoadingPromos: true));

    try {
      final promos = await _walletRepository.getAvailablePromoCodes();
      emit(state.copyWith(
        isLoadingPromos: false,
        availablePromos: promos,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingPromos: false,
        promoError: e.toString(),
      ));
    }
  }

  /// Select a quick amount
  void selectAmount(double amount) {
    emit(state.copyWith(
      selectedAmount: amount,
      clearCustomAmount: true,
      clearPromo: true,
    ));
  }

  /// Set custom amount
  void setCustomAmount(double amount) {
    emit(state.copyWith(
      customAmount: amount,
      selectedAmount: 0,
      clearPromo: true,
    ));
  }

  /// Clear custom amount
  void clearCustomAmount() {
    emit(state.copyWith(clearCustomAmount: true));
  }

  /// Apply promo code
  Future<void> applyPromoCode(String code) async {
    if (code.isEmpty) {
      emit(state.copyWith(promoError: 'Please enter a promo code'));
      return;
    }

    if (!state.hasValidAmount) {
      emit(state.copyWith(promoError: 'Please select an amount first'));
      return;
    }

    emit(state.copyWith(isApplyingPromo: true));

    try {
      final result = await _walletRepository.applyPromoCode(
        code: code,
        amount: state.effectiveAmount,
      );

      if (result.isValid) {
        emit(state.copyWith(
          isApplyingPromo: false,
          appliedPromo: result.promo,
          discountAmount: result.discountAmount,
        ));
      } else {
        emit(state.copyWith(
          isApplyingPromo: false,
          promoError: result.errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isApplyingPromo: false,
        promoError: e.toString(),
      ));
    }
  }

  /// Remove applied promo
  void removePromo() {
    emit(state.copyWith(clearPromo: true));
  }

  /// Select payment method
  void selectPaymentMethod(String method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  /// Move to next step
  void nextStep() {
    switch (state.currentStep) {
      case RechargeStep.selectAmount:
        if (state.hasValidAmount) {
          emit(state.copyWith(currentStep: RechargeStep.applyPromo));
        }
        break;
      case RechargeStep.applyPromo:
        emit(state.copyWith(currentStep: RechargeStep.payment));
        break;
      case RechargeStep.payment:
        if (state.selectedPaymentMethod != null) {
          processPayment();
        }
        break;
      case RechargeStep.confirmation:
        // Final step
        break;
    }
  }

  /// Move to previous step
  void previousStep() {
    switch (state.currentStep) {
      case RechargeStep.selectAmount:
        // First step
        break;
      case RechargeStep.applyPromo:
        emit(state.copyWith(currentStep: RechargeStep.selectAmount));
        break;
      case RechargeStep.payment:
        emit(state.copyWith(currentStep: RechargeStep.applyPromo));
        break;
      case RechargeStep.confirmation:
        // Don't go back from confirmation
        break;
    }
  }

  /// Process payment
  Future<void> processPayment() async {
    if (!state.hasValidAmount || state.selectedPaymentMethod == null) {
      return;
    }

    emit(state.copyWith(isProcessingPayment: true));

    try {
      final transaction = await _walletRepository.rechargeWallet(
        amount: state.effectiveAmount,
        paymentMethod: state.selectedPaymentMethod!,
        promoCode: state.appliedPromo,
      );

      emit(state.copyWith(
        isProcessingPayment: false,
        lastTransaction: transaction,
        isSuccess: true,
        currentStep: RechargeStep.confirmation,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessingPayment: false,
        paymentError: e.toString(),
      ));
    }
  }

  /// Reset state for new recharge
  void reset() {
    emit(RechargeState.initial());
  }

  /// Clear promo error
  void clearPromoError() {
    emit(state.copyWith());
  }

  /// Clear payment error
  void clearPaymentError() {
    emit(state.copyWith());
  }
}

