/// File: lib/features/wallet/presentation/blocs/recharge/recharge_state.dart
/// Purpose: Recharge wallet BLoC state
/// Belongs To: wallet feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/models/models.dart';

/// Recharge step enum
enum RechargeStep {
  selectAmount,
  applyPromo,
  payment,
  confirmation,
}

/// Recharge state containing all recharge-related data.
class RechargeState extends Equatable {
  const RechargeState({
    this.selectedAmount = 0.0,
    this.customAmount,
    this.appliedPromo,
    this.discountAmount = 0.0,
    this.availablePromos = const [],
    this.isLoadingPromos = false,
    this.isApplyingPromo = false,
    this.isProcessingPayment = false,
    this.promoError,
    this.paymentError,
    this.currentStep = RechargeStep.selectAmount,
    this.selectedPaymentMethod,
    this.lastTransaction,
    this.isSuccess = false,
  });

  /// Initial state
  factory RechargeState.initial() => const RechargeState();

  /// Selected quick amount
  final double selectedAmount;

  /// Custom entered amount
  final double? customAmount;

  /// Applied promo code
  final PromoCodeModel? appliedPromo;

  /// Discount amount from promo
  final double discountAmount;

  /// Available promo codes
  final List<PromoCodeModel> availablePromos;

  /// Loading promos state
  final bool isLoadingPromos;

  /// Applying promo state
  final bool isApplyingPromo;

  /// Processing payment state
  final bool isProcessingPayment;

  /// Promo error message
  final String? promoError;

  /// Payment error message
  final String? paymentError;

  /// Current recharge step
  final RechargeStep currentStep;

  /// Selected payment method
  final String? selectedPaymentMethod;

  /// Last successful transaction
  final WalletTransactionModel? lastTransaction;

  /// Recharge success flag
  final bool isSuccess;

  /// Effective amount (selected or custom)
  double get effectiveAmount => customAmount ?? selectedAmount;

  /// Final amount after discount
  double get finalAmount => effectiveAmount - discountAmount;

  /// Has valid amount selected
  bool get hasValidAmount => effectiveAmount > 0;

  /// Has applied promo
  bool get hasPromo => appliedPromo != null;

  /// Can proceed to payment
  bool get canProceedToPayment =>
      hasValidAmount && selectedPaymentMethod != null;

  /// Copy with
  RechargeState copyWith({
    double? selectedAmount,
    double? customAmount,
    PromoCodeModel? appliedPromo,
    double? discountAmount,
    List<PromoCodeModel>? availablePromos,
    bool? isLoadingPromos,
    bool? isApplyingPromo,
    bool? isProcessingPayment,
    String? promoError,
    String? paymentError,
    RechargeStep? currentStep,
    String? selectedPaymentMethod,
    WalletTransactionModel? lastTransaction,
    bool? isSuccess,
    bool clearPromo = false,
    bool clearCustomAmount = false,
  }) {
    return RechargeState(
      selectedAmount: selectedAmount ?? this.selectedAmount,
      customAmount: clearCustomAmount ? null : (customAmount ?? this.customAmount),
      appliedPromo: clearPromo ? null : (appliedPromo ?? this.appliedPromo),
      discountAmount: clearPromo ? 0.0 : (discountAmount ?? this.discountAmount),
      availablePromos: availablePromos ?? this.availablePromos,
      isLoadingPromos: isLoadingPromos ?? this.isLoadingPromos,
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      promoError: promoError,
      paymentError: paymentError,
      currentStep: currentStep ?? this.currentStep,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      lastTransaction: lastTransaction ?? this.lastTransaction,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        selectedAmount,
        customAmount,
        appliedPromo,
        discountAmount,
        availablePromos,
        isLoadingPromos,
        isApplyingPromo,
        isProcessingPayment,
        promoError,
        paymentError,
        currentStep,
        selectedPaymentMethod,
        lastTransaction,
        isSuccess,
      ];
}

