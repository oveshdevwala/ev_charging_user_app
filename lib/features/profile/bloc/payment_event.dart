/// File: lib/features/profile/bloc/payment_event.dart
/// Purpose: Payment BLoC events
/// Belongs To: profile feature
library;

/// Base class for payment events.
abstract class PaymentEvent {
  const PaymentEvent();
}

/// Load payment methods event.
class LoadPaymentMethods extends PaymentEvent {
  const LoadPaymentMethods();
}

/// Add payment method event.
class AddPaymentMethod extends PaymentEvent {
  const AddPaymentMethod({
    required this.gatewayToken,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });

  final String gatewayToken;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
}

/// Set default payment method event.
class SetDefaultPaymentMethod extends PaymentEvent {
  const SetDefaultPaymentMethod(this.id);

  final String id;
}

/// Remove payment method event.
class RemovePaymentMethod extends PaymentEvent {
  const RemovePaymentMethod(this.id);

  final String id;
}

/// Load wallet event.
class LoadWallet extends PaymentEvent {
  const LoadWallet();
}

/// Top up wallet event.
class TopUpWallet extends PaymentEvent {
  const TopUpWallet({
    required this.amount,
    required this.paymentMethodId,
  });

  final double amount;
  final String paymentMethodId;
}

/// Load billing history event.
class LoadBillingHistory extends PaymentEvent {
  const LoadBillingHistory();
}

/// Clear payment error event.
class ClearPaymentError extends PaymentEvent {
  const ClearPaymentError();
}

